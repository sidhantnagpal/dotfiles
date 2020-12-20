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
		* shared libraries (.so "shared object" files on Linux or .dll files on Windows or .dylib files on macOS)
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

Swapping
--------
	* main memory <-- pages <-- virtual memory (portion of secondary storage)
	* page replacement policy (fifo, lru, ff)
	* page transition: secondary storage to main memory is called "swap-in"
	* page transition (when page fault occurs): main memory to secondary storage is called "swap-out"


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


Tools
-----
* `cc/c++` or `gcc/g++` or `clang/clang++` (C/C++ compilers for converting source code to object code)
* `ar` (manipulate archives, can be used to create a static library, converts .o object file to .a archive file)
* `ld` (static linker)
* `ld.so` (dynamic linker/loader)


Tools for viewing/parsing ELF objects
-------------------------------------
* `ldd` - list shared objects (or shared libraries)
* `readelf` - display information from ELF files (similar to objdump but it goes into more detail and it exists independently of the BFD library unlike objdump)
* `objdump` - display information from object files
* `nm` - list symbols from object files

rpath
	- rpath designates the run-time search path hard-coded in an executable file or library
	- dynamic linking loaders use the rpath to find required libraries
	* `chrpath`
	* `patchelf`


CMake Build Types
-----------------

* The default build types that come with cmake more or less mean the following:
	1. Release: high optimization level, no debug info, code or asserts.
	2. Debug: No optimization, asserts enabled, [custom debug (output) code enabled],
	   debug info included in executable (so you can step through the code with a
	   debugger and have address to source-file:line-number translation).
	3. RelWithDebInfo: optimized, *with* debug info, but no debug (output) code or asserts.
	4. MinSizeRel: same as Release but optimizing for size rather than speed.

* In terms of compiler flags that usually means (since these are supported in most cases on all platforms anyway):
	1. Release: `-O3 -DNDEBUG`
	2. Debug: `-O0 -g`
	3. RelWithDebInfo: `-O2 -g -DNDEBUG`
	4. MinSizeRel: `-Os -DNDEBUG`
  Where defining NDEBUG is added on platforms that support this (it disables `assert()`).


C++ Compiler Flags
------------------
- See https://github.com/lefticus/cpp_starter_project/blob/master/cmake/CompilerWarnings.cmake for a good set of warnings to use.
	- Use `-Wall -Wextra -Wshadow -Wnon-virtual-dtor -pedantic` for prototyping.
- Instrumented builds using Sanitizers. See https://github.com/lefticus/cpp_starter_project/blob/master/cmake/Sanitizers.cmake for reference.
	- To summarize:
		- AddressSanitizer (ASan), detects addressability issues. (-fsanitize=address)
		- LeakSanitizer (LSan), detects run-time memory leaks. (-fsanitize=leak)
		- UndefinedBehaviorSanitizer (UBSan), detects division by zero and other UB. (-fsanitize=undefined)
		- ThreadSanitizer (TSan), detects race conditions between threads. (-fsanitize=thread) doesn't work with ASan/LSan enabled.
		- MemorySanitizer (MSan), detects use of uninitialized memory. (-fsanitize=memory) doesn't work with ASan/LSan/TSan enabled.
	- See https://stackoverflow.com/a/47261999/10960444 for time/memory impact of each of the sanitizers among other pros/cons.
	- Use `-fsanitize=address,leak,undefined` for prototyping.

* Verbosity (warnings)
	-Wall : turn on a lot of warnings
	-Wextra : turn on additional warnings
	-Werror : treat warnings as errors
	-Wpedantic : issue warnings if not compliant to ISO C/C++

* Standard
	-std=c++11 : ISO C++11
	-std=c++17 : ISO C++17
	-std=gnu++ : ISO C++ with GNU extensions

* Output file
	-o <outputfile>

* Optimization
	-O3 : most aggressive optimization (function inlining, loop vectorization and SIMD instructions)
	-Ofast : activate (-O3) optimization disregarding strict standard compliance
	-Og : enables all optimization that does not conflict with debugging (can be used with -g)

* Misc options
	-fPIC : generate position independent code

* Special options
	-g : builds executable with debugging symbols
	-c : compile source code to object code (input to linker)
	-S : only run the preprocess and compilation steps; convert source code to symbolic code (input to assembler)
	-shared : build a shared library (.so or .dylib on nix or or .dll on Windows); for predictable results, specify the same set of options used for compilation (-fPIC, or model suboptions) when specifying this linker option

* Pass args to preprocessor/assembler/linker
	-Wp,<arg> : pass the comma separated arguments in <arg> to the preprocessor
	-Wa,<arg> : 				"				" 				   assembler
	-Wl,<arg> : 				"				" 				   linker
		* -Wl,-static : perform a completely static link (no shared libraries used at all)
		* -Wl,-Bstatic : for any `-lfoo` that follows, use only archive version of the library
		* -Wl,-Bdynamic : for any `-lfoo` that follows, use shared object of the library
		* -Wl,-rpath=dir : add a directory to runtime library search path

	Example:
	To link your program with lib1, lib3 dynamically and lib2, lib4 statically, use:
		```
		gcc program.o -llib1 -Wl,-Bstatic -llib2 -llib4 -Wl,-Bdynamic -llib3 -Wl,--as-needed
		```
	Assuming that default setting of ld is to use dynamic libraries (it is on Linux).
	`--as-needed` will drop any unused dynamic library.

* Search paths and linking flags
	-l[pthread] : links to shared library (or shared object); specifically it links to libpthread.so on nix systems; similarly, `-llinalg` links to linalg.so on nix systems
	-L[path/to/shared-libs] : add search path to shared libraries
	-I[path/to/include-dirs] : add search path to header files (.h) or (.hpp)
	-D[FLAG] or -D[FLAG]=VALUE : pass preprocessor flag

* Emulation
	-mcpu=pentium4 : tune to pentium4
	-march=pentium4 : generate instructions for pentium4


Create and use a static library
-------------------------------
```
# create object (.o) file
g++ -c header.cpp

# create archive silently
#	r - replace/add files to archive
#	c - silently, opposite of v(erbose)
#	s - write an object file index into the archive
ar rcs header.a header.o

# use static library
g++ main.cpp header.a
```
