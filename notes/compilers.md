* Compiler
	- converts pre-processed source code to symbolic code or directly executable code
	- may throw a compilation error
* Interpreter
	- converts source code to machine code in a line-by-line fashion
	- may throw a runtime error
* Assembler
	- converts symbolic code to machine code (relocatable, but usually not directly executable)
	- may throw an assembling error
* Linker
	- combine the object code of library files with the object code of our program
	- may throw a linker error
	|
	+ Static Linking
	|	* static libraries (.a "archive" files on nix or .lib files on Windows)
	|	* refers to the linking that is done during compile-time and involves copying the
	|	  linked content into the primary executable
	|	* downsides
	|		- compile time is longer
	|		- binary size becomes larger
	|
	+ Dynamic Linking
		* shared libraries (.so "shared object" files on nix or .dll files on Windows)
		* refers to the linking that is done during load or run-time and not when the
		  executable is created
		* downsides
			- startup time is longer
			- linker errors appear at runtime

* Loader
	- reads the executable file from the disk into the main memory (RAM) for execution
		- allocates memory space to the executable
		- maps addresses within executable file to the physical memory addresses
		- resolves the name dynamic library items
	- may throw a runtime error
	|
	+ Static Loading
	|	* means loading the entire program into the main memory before the start of
	|	  program execution
	|
	|
	+ Dynamic Loading
		* means loading the library (or any other binary for that matter) into the memory during load or run-time


References:
[1] https://www.csc2.ncsu.edu/faculty/xjiang4/csc501/readings/lec10-linkerloader.pdf

Compiled Languages (eg. C/C++)
------------------------------

[source code .c/.cc] -- Compiler --> [symbol code .s] --> Assembler --> [object code .o]
																			|
																			|
											  static libraries (.a) --->  Linker
													and/or					|
												other objects (.o)			|
																			|
																	    	v
																	  [machine code
																	   aka executable]
																		    |
																		    |
											dynamic libraries (.so)	--->  Loader
																		  	|
																		  	|
																		  	v
																	  [in-memory image of
																	   executable code]

Interpreted Languages (eg. Python/Perl)
---------------------------------------

[source code]
	|
	|
	|				runtime
Interpreter	 <----- library
	|				 files
	|
	|
	v
[in-memory image of
 executable code]


*Note* Java doesn't fit either of the above categories. Java compiler first converts source code to byte-code which can then be interpreted by JVM (with possibly JIT-compilation ie converting byte-code to machine code at runtime before executing it, namely "just-in time", for optimization).


Tools:
* `cc/c++` or `gcc/g++` or `clang/clang++` (C/C++ compilers for converting source code to object code)
* `ar` (manipulate archives, can be used to create a static library, converts .o object file to .a archive file)
* `ld` (static linker)
* `ld.so` (dynamic linker/loader)


Tools for viewing/parsing ELF objects:
* `ldd` - list shared objects (or shared libraries)
* `readelf` - display information from ELF files (similar to objdump but it goes into more detail and it exists independently of the BFD library unlike objdump)
* `objdump` - display information from object files
* `nm` - list symbols from object files

rpath
	* rpath designates the run-time search path hard-coded in an executable file or library
	* dynamic linking loaders use the rpath to find required libraries
	- `chrpath`
	- `patchelf`


Swapping
--------
	* main memory <-- pages <-- virtual memory (portion of secondary storage)
	* page replacement policy (fifo, lru, ff)
	* page transition: secondary storage to main memory is called "swap-in"
	* page transition (when page fault occurs): main memory to secondary storage is called "swap-out"
