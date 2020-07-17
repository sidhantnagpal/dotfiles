ESC - Normal Mode (prefer to be here mostly and switch to other modes on demand)
i - Insert Mode
: - Command Mode
v - Visual Mode (lowercase v for character selection, shift+v for line selection)

Vim commands can be combined, e.g.,
* :25,35y will yank lines from 25 to 35
* :25,35d will cut/delete lines from 25 to 35
* :%y will yank all lines

Vim
* In `less`, use `g` for beginning (or `g5` for 5th line from begin), `G` for end (or `G5` for 5th line from end), use `F` for follow (equivalent to `tail -f`).
* Shift+A - insert mode from last character of current line
  o - insert mode from beginning of next line
* yy - copy current line
  10yy - copy 10 lines from current line
  10dd - cut 10 lines from current line
  10p - paste contents 10 times below current line

* p (or ""p) - paste from default register `"` (points to last used register)
 "0p - paste from the yank register ("0)
 "1p - paste from the delete register ("1)
 "[2-9]p - paste from numbered register ("[2-9])
 `"_d` - cut to black hole register (ie delete without saving)


* "1p to paste the last delete and then use `.` to repeatedly to paste the subsequent deletes, ie:
    `"1p...` is basically equivalent to `"1p"2p"3p"4p`
  This trick can be used to reverse-order a handful of lines:
    `dddd"1p...`

:w - write
:q - quit
:wq - write and quit
:q! - quit ignoring changes

:!{command} - execute shell command from vim (e.g., :4,7 !sort -u) (e.g., :!sed 's/:\([^ ]\*\)/\1/p' vim.md)

:set (no)nu[mber] - turn off/on line numbers
:syntax on - turn on syntax highlighting

:u[ndo] - undo
:red[o] - redo

<Enter Visual Mode>
<Select Lines>
:y - yank (copy) selected lines to clipboard (to default register "")
:p - paste from clipboard
:d - cut/delete selected lines (to default register "")

:help 'undo'
/searchstring - find forward from here (press n to continue in same dirn, N for opposite), searchstring can also be a regular expression
?searchstring - find previous from here (press n to continue in same direction, N for opposite), searchstring can also be a regular expression
:s/search/replace/ - find and replace first occurence in current line
:s/search/replace/g - find and replace globally in current line
:%s/search/replace/g - find and replace globally in the whole file
:8,10 s/search/replace/g - find and replace gloablly in range of lines 8 to 10

:m 12 - move current line to after line 12
:5,7m 12 - move lines 5 through 7 after line 12
:t 12 - copy current line to after line 12
:5,7t 12 - copy lines 5 through 7 to after line 12

:noh - turn off highlighting after find

:0/% - beginning/end of file
:25 - goto row (line) 25
25| - goto column 25
0/$ - beginning/end of line
)/( - move a sentence forward/back
w/e - move forward to beginning/end of word
3w - move forward 3 words
b - move back to beginning of word
3b - move back 3 words
d0 - delete to 0th column
dd - delete line
dw - delete subword forward (from cursor position)
db - delete subword backward (excluding cursor position)

:e filename - edit another file
:ls - show current buffers
:b2 - open buffer #2 in current window
:bn - next buffer
:bp - prev buffer
:bd - delete buffer (close buffer)

:split filename - split window horizontally and load another file
:vsplit filename - split window vertically and load another file

"1y or "1p or "1d - `"` is used for selecting register in vim
"2y or "2p or "2d - do operations after selecting 2nd register
"+y or "+p or "+d - do operations on system clipboard register
""y (equivalent to `y`) - default register (similarily for `d`, `p`)
(note:
	y or ""y - yanks to "" register (default) and 0 register
	d or ""d - deletes to "" register (default) and 1 register
hence:
	last yank (y) can be accessed using "0p
	last delete (d)/change (c) can be accessed using "1p
)
(
in fact:
	vim has 1 unnamed register "" (which is the default register)
	vim has 10 numbered registers ranging from 0-9
		last yank can be accessed using "0p
		last 9 delete/change can be accessed using "1p,"2p ... "9p
	vim has 26 named registers a-z or A-Z
		these are populated only by explicit commands
		the uppercase letters are used to append to lowercase register
		"ayy - write yank contents to register a
		"Ayy - append yank contents to register a
)
:reg - get all register contents
:reg " - get contents of register "
:reg + - get clipboard contents
:reg 0 - get contents of register 0
:reg a - get contents of register a

ctrl+w and arrow keys - move cursor to another window
ctrl+e/y - move viewport up/down

vi 1976
 | \      more 1978
 |  \     /
 |   \   /
 |     v
 |   less 1983
 v
vim 1991

vim is vi improved, so add `alias vi=vim` in `.bashrc` file

