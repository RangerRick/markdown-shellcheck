#!/usr/bin/env gawk -f
BEGIN {
	# external command to pipe codeblocks into:
	linter = "shellcheck --color=always --wiki-link-count=0 --exclude=SC2148 -" # ignore missing shebang
}

function print_shellcheck_result() {
	close(linter, "to")
	while (linter |& getline line) {
		if (line ~ "In - line [0-9]+:") {
			match(line, /[0-9]+/)
			linenumber = substr(line, RSTART, RLENGTH)
			print "\033[1mIn " FILENAME " line " codeblock_start + linenumber ":\033[0m"
		} else {
			print line
		}
	}
	close(linter)
}

function match_codeblock_start(char) {
	# https://spec.commonmark.org/0.30/#fenced-code-blocks
	if ($0 ~ "^ {0,3}" char"{3,}" "(k|z|ba)?sh"){
		inside_fenced_codeblock = 1
		codeblock_start = FNR
		count = gsub(char, "")
		endpattern = "^ {0,3}" char"{"count",}" "[ \t]*$" 
		next
	}
}

function match_codeblock_end() {
	if ($0 ~ endpattern) {
		inside_fenced_codeblock = 0
		print_shellcheck_result()
	} else {
		print |& linter
	}
}

{
	if (inside_fenced_codeblock) {
		match_codeblock_end()
	} else {
		match_codeblock_start("`")  # backtick
		match_codeblock_start("~")  # tilde
	}
}

ENDFILE {
	if (inside_fenced_codeblock) {
		# CommonMark says that codeblocks are implicitly closed at EOF
		print_shellcheck_result()
	}
	inside_fenced_codeblock = 0
}
