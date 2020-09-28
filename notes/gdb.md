* build with -Og flags to have debug symbols and not let optimization mess-up debugging
* Keep ~/.gdbinit minimal and the following useful options:
```
set history save on
set print pretty on
```

Shortcuts
---------
- C-x a  (for toggling tui mode)
	* once in tui, C-x 2 can show both source & assembly
	* C-x 2 again, will show assembly & registers (and it cycles if pressed again)
	* C-x 1 will switch back to inital view with only the source display
- C-p  (prev cmd in tui mode)
- C-n  (next cmd in tui mode)
- C-l  (or `shell clear`, for repainting the screen if display gets messy)

Python interpreter in GDB
-------------------------
* python print('hello')  (python cmd from gdb console)
* python  (for writing a script from gdb console, terminated by `end`)

GDB commands
============

Controlling Execution
---------------------
* set args <test1> <test2>  (or just start debugger as `gdb --args <program> <args>`)
* show args
* r[un]

* s[tep]
* n[ext]
* c[ontinue]
* finish - step out
* kill - stops debugging but does not quit the debugger

* quit

* b[reak] <funcname>
* b <file.c:n>
* b WHERE if COND - conditional breakpoints
* [disable|enable] <bn> - disable/enable breakpoints

* command <bn>
	* command(s) to execute whenever breakpoint number n is hit

* p[rint]
	```
	(gdb) set $foo = 4
	(gdb) p $foo
	```

Memory
------
* x - examine memory (format: `x/nfu addr`, where n is repeat count, f is display format, u is unit size)
	* x/c - examine as chars
	* x/d - examine as signed decimals
	* x/x - examine as hex digits
	* x/i - examine as instructions
	* x/s - examine as C strings

Stack
-----
* bt - print a backtrace of the entire stack, one line per frame for all frames in the stack
* info frame - print the description of the selected stack frame
* info locals - print all local variables
* info reg - print names and values of registers

Miscellaneous
-------------
* file <program> - load an executable under debugger control
* disas - disassemble
* watch - debugger stops the program when the value of expression changes (also see rwatch, awatch)
* `p *data@10` - print array
* reverse-[step|next|continue|finish] - reverse execution
* set exec-direction [reverse|forward] - GDB will perform all execution commands in specified direction until the it is changed again


Core Dump Analysis
------------------
* gdb <program> <corefile>  (or `gdb <program>` followed by `(gdb) core <corefile>`)
* (gdb) bt  - will give the backtrace (`bt` and `where` are synonymous and give same outputs)
* As mentioned in [link](https://cxwangyi.wordpress.com/2010/01/08/generate-core-dump-files/),
  make sure the shell command `ulimit -c unlimited` was executed before the buggy program
	cored (short for "core-dumped", which is synonymous with "seg-faulted").

References
----------
[1] https://github.com/CppCon/CppCon2015/blob/master/Demos/Becoming%20a%20GDB%20Power%20User/Becoming%20a%20GDB%20Power%20User%20-%20Greg%20Law%20-%20CppCon%202015.pdf
[2] https://gist.github.com/savanovich/eb6ee6b264e773968e71#controlling-execution
