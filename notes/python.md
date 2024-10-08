Python
------
* Python CLI
	- `-c` (specify the command to execute)
		`python -c "print("0"*8)"`
	- `-i` (enter interactive mode after executing)
		`python -i script.py`
* Python tricks
  - generators (yield, next, send)
  - iterators (iter, next)
  - metaclasses (eg. for Singleton)
  - decorators
  - type annotations (typing module, mypy library)
  - polymorphism (using `*args` and/or `**kwargs`)
  - dataclass, namedtuple, Enum
  - arguments
    - position-only: use `/` (argument clinic) in argument list
    - keyword-only: use `*` in argument list (disallowing positional args beyond this point)
  - `@property`, `@classmethod` (alternate constructors use-case), `@staticmethod` (tied to a class instead of its objects)
  - prefer using `None` over `()` (empty tuple) as immutable default arguments in methods
  - `None or []` evaluates to `[]` (empty list)
  - `dir()`, `vars()`
  - dunders
    - `__new__`, __init__`, `__slots__`
    - `__len__`, `__getitem__`, `__reversed__`
    - `__eq__`, `__lt__`, `__le__`
    - `__add__`, `__radd__`
    - `__getattr__`, `__setattr__`, `__delattr__`
    - `__enter__`, `__exit__`
    - `__call__`
    - `__name__`, `__doc__`, `__bases__`, `__dict__`
    - `__repr__, `__str__`, `__format__`
      * TL;DR: repr is unambiguous representation of the object, str is meant for human readable format.
        If you want to define just one of them, it should be repr.
      * Conversion flags `!s` and `!r` which call `str()` and `repr()` respectively:
        * '{0}'.format(a) will use the result of `a.__format__()` to display the value
        * '{0!s}'.format(a) will use the result of `a.__str__()` to display the value
        * '{0!r}'.format(a) will use the result of `a.__repr__()` to display the value
      * Eg.
```
>>> "repr() shows quotes: {!r}; str() doesn't: {!s}".format('test1', 'test2')
"repr() shows quotes: 'test1'; str() doesn't: test2"
```
* IPython tricks
	* general
		- getting help: `<object_name>?`, `<object_name>??`
		- executing in shell: `!<shell_command>`
		- auto complete: tab-completions, write partially and press up arrow
	* magic commands
		* line magics (if auto magic is ON, % prefix is not needed for line magics)
			- executing: `%run script.py`
			- profiling: `%time`, `%timeit`, `%memit`
			- editing: `%edit` (`%edit -p` with same contents as previous edit, `%edit _1` for specific)
			- debugging: `%debug` (ipython will automatically take you to ipdb if there's an error)
			- set env vars: `%env`
			- see vars in scope: `%who`
		* cell magics
			- `%%time`, `%%timeit`
			- `%%debug`
			- `%%capture`
			- `%%latex`, `%%bash`, `%%pypy`, `%%javascript`
* Standard Libraries
	- functools, itertools, collections, dataclasses, enum
	- argparse, configparser
	- pathlib, glob, tempfile
	- importlib
	- traceback, typing, logging
	- subprocess, shlex, io, fcntl, errno, signal, select
	- shelve, dbm, mmap
	- struct.{pack, unpack}
	- base64.b64{encode, decode}
	- binascii.crc32, binascii.{hexlify, unhexlify}
	- concurrent.futures.{ThreadPoolExecutor, ProcessPoolExecutor} as Pool
	- socket (for TCP/IP) (Network/Socket Programming)

* Open-Source Libraries
	- date/time
		* dateutil
	- ssh
		* paramiko, fabric
	- web
		* django, flask
		* celery
		* flower
	- scientific python
		* numpy, scipy
			- NumPy is an extension module for Python, mostly written in C. This makes sure that the precompiled mathematical and numerical functions and functionalities of Numpy guarantee great execution speed.
			- SciPy extends the capabilities of NumPy with further useful functions for minimization, regression, Fourier-transformation and many others.
			- https://numpy.org/doc/stable/user/c-info.python-as-glue.html
			- https://numpy.org/doc/stable/user/c-info.how-to-extend.html#writing-an-extension
			- Significant performance speedups can be achieved with NumPy over native Python code, particularly when computations follow the Single Instruction, Multiple Data (SIMD) paradigm.
			- https://realpython.com/numpy-array-programming/#what-is-vectorization
		* pandas
			- data analysis toolkit for series or tabular data
			- provides special data structures and operations for the manipulation of numerical tables (pd.DataFrame) and time series (pd.Series)
		* xarray - data analysis toolkit for n-dimensional data
		* matplotlib - plotting
		* scikit-learn - machine learning
		* jax (Google)
			- GPU/TPU-backed NumPy with differentiation and JIT compilation by Google
		* pytorch (Facebook) - neural networks
		* torchtext, spacy - natural language processing
	- optimizing computation
		* numba
			- translates python functions to optimized machine code at runtime (jit - just in time) using the industry-standard LLVM compiler library
			- numba-compiled numerical algorithms in python can approach the speeds of C/FORTRAN
		* dask, flexible library for parallel computing, composed of two parts:
			- dynamic task scheduling
				- this is similar to Airflow, Luigi, Celery, but optimized for interactive computational workloads
			- big data collections
				- like parallel arrays, dataframes, and lists that extend common interfaces like numpy, pandas, or python iterators to larger-than-memory or distributed environments
				- these parallel collections run on top of dynamic task schedulers
	- integrating python with other languages (like C++)
		[1] https://wiki.python.org/moin/IntegratingPythonWithOtherLanguages
		[2] https://youtu.be/jQedHfF1Jfw
		[3] https://taotie.readthedocs.io/en/latest/resource/programing/python_performance.html
		- C/C++ binding generators
			* generating python bindings for a C++ library
			* tools to make C/C++ functions/methods accessible from python by generating binding (Python extension or module) from header files
				* pybind11 > boost.python (simplicity and development time)
	- client-server
		* protobuf (Google) `conda install -c anaconda protobuf`
			- a method of serializing structured data
			- useful for IPC (inter-process communication) over a wire or for storing data
			- involves an IDL (interface description language) that describes the structure of some data and a program that generates source code from that description for generating or parsing a stream of bytes that represents the structured data
		* gRPC (Google) `conda install -c conda-forge grpcio grpc-cpp`
			- open source remote procedure call (RPC) system
			- uses HTTP/2 for transport, Protobuf as the IDL, and provides features such as authentication, bidirectional streaming and flow control, blocking or non-blocking bindings, and cancellation and timeouts
			- generates cross-platform client and server bindings for many languages
			- common use-cases include connecting services in microservices-style architecture and connect mobile devices, browser clients to backend services

			* gRPC vs REST
				- https://www.yonego.com/nl/why-milliseconds-matter/
				- https://nordicapis.com/when-to-use-what-rest-graphql-webhooks-grpc/

Concurrency
-----------
If your program doesn't fit one of the following three (processes, threads, greenlets), you have to understand the tradeoffs.
* Processes are good for running tasks that need to use CPU in parallel and don't need to share state, like doing some complex mathematical calculation to hundreds of inputs.
	- Have one major advantage: they can't interfere with each others' global objects by accident (if one crashes the others remain unaffected).
	- Have one major disadvantage: they can't share high-level objects, although they can pass objects around (like pickling objects)
	- Another disadvantage: starting a process is a pretty heavy thing to do, and using a Pool or Executor is the easy way around this problem, but it's not always appropriate.
* Threads are good for running a small number of I/O-bound tasks, like a program to download hundreds of web pages.
	- Have one major advantage: everything is shared, if you modify an object in one thread, another thread can see it.
	- Have one major disadvantage: everything is shared, if you modify an object in one thread it is not deterministic if the other thread sees the old value or the new value, and if an object is modified in two threads then you've got a race condition. This may be solved using locks or other synchronisation objects (like lock-free data types).
	- Python adds another disadvantage to threads: Under the covers, the Python interpreter itself has a bunch of globals that it needs, which it protects by a GIL (global interpreter lock).
	- Suitable if your code is mostly I/O-bound (meaning you spend more time waiting on the network, the filesystem, the user, etc. than doing actual work—you can tell this because your CPU usage is nowhere near 100%), threads will usually be simpler and more efficient.
* Greenlets are good for running a huge number of simple I/O-bound tasks, like a web server. See greenlets vs. explicit coroutines on deciding whether to use automatic greenlets or explicit ones.
	- Greenlets  (aka cooperative threads, user-level threads, green threads) are similar to threads, but the application has to schedule them manually. Unlike a process or a thread, your greenlet function just keeps running until it decides to yield control to someone else.
	- Another advantage of greenlets is that you know that your code will never be arbitrarily preempted as every operation that doesn't yield control is guaranteed to be atomic. Also, the application can schedule things much more efficiently than the general-purpose scheduler built into your OS kernel. This makes certain kinds of race conditions impossible. You still need to think through your synchronization, but often the result is simpler and more efficient.
	- The major disadvantage is that if you accidentally write some CPU-bound code in a greenlet, it will block the entire program, preventing any other greenlets from running at all, whereas with threads it will just slow down the other threads a bit. (Of course sometimes this can be a good thing as it makes it easier to reproduce and recognize the problem)
	- Greenlets can also be used with explicit waiting. While the older ways of doing this were a bit clumsy, with newer frameworks, the question really is as simple as whether you mark each wait with await (as in asyncio) vs. whether they happen automatically when you call magic functions like socket.recv (as in gevent). What happens under the covers is the same either way. The TL;DR is that there's usually more advantage than disadvantage in marking your yields explicitly.

Scaling Python Applications
---------------------------
Python isn't fast. That is a tradeoff we all made when we started using it. It can be scaled though and there are a lot of very large sites that run python fine. Here are some things to keep in mind when scaling web applications:

* Load Balancers: Run your application with multiple processes and use a load balancer to share traffic between them.
* CPU Monitoring: Make sure your application isn't maxed out on CPU. Even better, if you're using kubernetes(or something similar), setup auto scalers when CPU hits thresholds.
* Connection Pooling: Prevent simultaneous connections to python applications by using proxies/load-balancers that will pool requests in front of your application to ensure your application is servicing a healthy number of requests at a time.
* Message Queues: If you have CPU bound tasks, put them in a queue to be processed by another service. If you have a threaded application and have a lot of network-bound IO, you might also want to use a message queue for that.
* Microservices: If you are using AsyncIO, you can leverage micro-services to off-load potentially CPU-bound operations.
* Caching

See https://www.nathanvangheem.com/posts/2019/06/11/scaling-python-web-applications.html


Which concurrency model to use when?
------------------------------------
* Asyncio
	- performance is IO-bound rather than CPU-bound
	- when starting new codebase without synchronous legacy code

	_Note_
	* async/await allows cooperative multitasking

* Threads
	- need preemptive multitasking (ie tasks can interrupt other tasks)
	- when integrating synchronous code (which involves blocking system calls)
	- need fine-grained concurrency (tasks working with each other simultaneously)
	- need Python "glue" for optimized/compiled C (or other language) code

	_Note_
	* Python threads are actually OS (kernel) threads (or POSIX threads) which are preempted (interrupted) by the OS (kernel).
	* Golang threads are like green threads (or cooperative threads) which are application-level threads (or user-space threads) and are managed by Golang runtime. (Golang schedulers are *cooperative* whereas OS schedulers are *preemptive*)

* Processes
	- when there isn't need of substantial inter-task communication
	- since processes don't share memory, inter-process communication (IPC) becomes difficult and has to be done through files, pipes or mmap (memory-mapped regions)
  - need to be mindful of forking, pickling (which have overheads)

* Distributed Tasks
	- highly segmentable and distributable workload
	- need for shared state is minimal (as overhead of communication between nodes in a network is much more compared to IPC)
	- if there is large enough workload to overcome the performance overhead of orchestrator

Also, see https://realpython.com/python-concurrency.

Suggestions
-----------
* Python Concurrency from Ground-Up by David Beazley https://youtu.be/MCs5OvhV9S4
* Think outside the GIL (asyncio + multiprocessing) by John Reese (Facebook) https://youtu.be/0kXaLh8Fz3k
* Writing thread-safe code is hard (need to check locks, races, etc). (asyncio + multiprocessing) is generally all you need. Asyncio lets you be efficient for IO-bound tasks on a single core and multiprocessing allows distributing CPU-bound tasks across multiple cores.
  	_Note: Some quirks about asyncio_ (reference: https://youtu.be/iG6fr81xHKA)
  	* In asyncio, long CPU-intensive tasks should routinely release the CPU to avoid starving other tasks. This can be done by introducing `await asyncio.sleep(0)` to tell the loop to return control ASAP.
  	* Blocking library functions (socket, select, subprocess, os.waitpid, threading, multiprocessing, time.sleep) are incompatible with async frameworks.
