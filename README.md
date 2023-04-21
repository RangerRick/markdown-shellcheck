# markdown-shellcheck
This AKW script extracts shell code blocks from Markdown files and runs [shellcheck](https://www.shellcheck.net/) on them. 

Only fenced code blocks where the [info string][0] starts with `bash`, `ksh`, `zsh`, or `sh` are extracted.

The [`&|`][1] and [`ENDFILE`][2] GNU AWK extensions are used.
If you don't like that, remove the `ENDFILE` block and replace `&|` with temporary files.

## Example usage
```console
$ ./markdown-shellcheck.awk file1.md file2.md

In file1.md line 126:
if [ $1 == b ]; then
     ^-- SC2086 (info): Double quote to prevent globbing and word splitting.
        ^-- SC3014 (warning): In POSIX sh, == in place of = is undefined.

Did you mean: 
if [ "$1" = b ]; then

In file2.md line 62:
    xdotool windowunmap $(xdotool getactivewindow)
                        ^------------------------^ SC2046 (warning): Quote this to prevent word splitting.
```

## Installation
Copy [markdown-shellcheck.awk](./markdown-shellcheck.awk) into a directory inside your `$PATH`.

## License
MIT

[0]: https://spec.commonmark.org/0.30/#code-fence
[1]: https://www.gnu.org/software/gawk/manual/html_node/Two_002dway-I_002fO.html
[2]: https://www.gnu.org/software/gawk/manual/html_node/BEGINFILE_002fENDFILE.html
