Linux System Programming
========================

Accessing the Files
-------------------

* Unbuffered vs Buffered IO (user-space buffering)

| Feature               | Low-Level IO                     | Standard Library IO                  |
|-----------------------|----------------------------------|--------------------------------------|
| Read/Write access     | open(), close(), read(), write() | fopen(), fclose(), fread(), fwrite() |
| Random access         | lseek()                          | fseek(), rewind()                    |
| Type of descriptor    | int                              | FILE *                               |
| User-space buffering? | No                               | Yes                                  |
| Part of C Standard?   | No                               | Yes                                  |


* Formatted IO
    - printf()
    - sprintf(), snprintf()
    - fprintf()

* Scatter/Gather IO
    - readv(), writev() syscalls
    - the data is scattered into or gathered from the given vector of buffers
    - a single vectored IO operation can replace multiple linear IO operations (ie multiple read(), write() syscalls)

* Epoll
    - short for event poll
    - improves on the poll() and select() syscalls, especially when hundreds of file descriptors have to be polled in a single program
    - `epoll_create()`, `epoll_ctl()`, `epoll_wait()` syscalls
        - epoll_ctl() takes an argument `events` which if has the EPOLLET value set, makes the watch on fd edge-triggered, as opposed to level-triggered.
        - Level-triggered is the default behavior. It is how poll() and select() behave, and it is what most developers expect. Edge-triggered behavior requires a different approach to programming, commonly utilizing nonblocking IO, and careful checking for EAGAIN.

* Memory-mapped IO
    - mmap() syscall allows creating a mapping of bytes represented by file descriptor object to memory
    - munmap() syscall for removing a mapping created with mmap()


Managing Files & Directories
----------------------------

* Subdirectories of root directory:
    - `/bin` : common programs, shared by the system, the system administrator and the users
    - `/etc` : configuration files
    - `/home` : home directories of common users
    - `/lib` : library files, includes files for all kinds of programs needed by the system and the users
    - `/opt` : third party and extra software
    - `/proc` : virtual file system containing information about system resources
    - `/sbin` : programs for use by the system and the system administrator
    - `/tmp` : temporary space for use by the system, cleaned upon reboot, so don't use this for saving any work
    - `/usr` : programs, libraries, documentation etc. for all user-related programs

* File types (first character of each output line of `ls -l` denotes the file type)
    - In Linux, everything is a file and a file is fundamentally a link to an inode (a data structure that stores everything about a file apart from its name and actual content):
        1. - : Regular file
        2. d : Directory, files that are list of other files (`man 1 mkdir` or `man 2 mkdir`)
        3. l : Link, reference to another file in the system which can either a regular file or a directory
        4. p : Named pipe, allow inter-process communication by connecting the output of one process to the input of another (`man 1 mkfifo` or `man 2 mkfifo`)
        5. s : Socket, provide a means of inter-process communication, and can also transfer data and information between processes running on different environments (`man 2 socket`)
        6. b : Block file, device files that provide buffered access to system hardware components
        7. c : Character file, device files that provide unbuffered serial access to system hardware components
    - `stat` reads the inode and displays file attributes
```
struct stat {
    dev_t  st_dev;    /* ID of device containing file */
    ino_t  st_ino;    /* inode number */
    mode_t st_mode;   /* protection */
    ...
    uid_t  st_uid;    /* user ID of owner */
    gid_t  st_gid;    /* group ID of owner */
    ...
    off_t  st_size;   /* total size, in bytes */
    ...
    time_t st_atime;  /* last access time */
    time_t st_mtime;  /* last modification time */
    time_t st_ctime;  /* last status change (inode) time */
};
```
    - `stat.st_mode` (2 bytes)
    |_|_|_|_|s|g|t|r|w|x|r|w|x|r|w|x|
     _______ | | | _____ _____ _____
        |    | | |   |     |     |
      file   | | |   |     |   other permissions
      type   | | |   |     |   (rest of world)
             | | |   |     |
             | | |   |   group permissions
             | | |   |
             | | |  user permissions
             | | |
             | | |_____ "sticky bit"
             | |_______ set GID
             |_________ set UID

* Creating Files
    - creat() syscall
    - link(oldname, newname) syscall behind the command `ln` (gives an existing file an additional name)
    - unlink(name) syscall behind the command `rm` (if this is the last remaining link, file is deleted ie its inode and data blocks will be freed)
        - exception: deletion is postponed if a process has the file open (anonymous file)

    - Link (or Hard Link) vs Soft Link (or Symbolic Link)
        - Logical difference
            - Hard links create another name for inode number
            - Symbolic links create another name for name
        - Functional difference
            - Hard links cannot be created across different filesystems (partitions/volumes) or for directories
            - Symbolic link is a file that contains name of another file (like a shortcut) and unlike hard links it can be created across different filesystem boundaries or for directories

    - symlink(oldname, newname) syscall behind the command `ln -s`


* Directories
    - getcwd(), chdir(), mkdir(), rmdir(), opendir(), readdir() syscalls

* Monitoring Filesystem Events
    - inotify API
        - creating inotify instance `fd = inotify_init()  // returns file descriptor`
        - adding to the watch list `wd = inotify_add_watch(fd, path, mask)  // returns watch descriptor`
        - reading events `read(fd, buf, size)  // will block until watched event occurs` (more than one event may be returned in a single read)


Command Line
------------

* Environment
    - A list of strings carried by each environment.
    ```
    $ export FOO=BAR  # creating an environment variable (upper-case)
    $ env | grep FOO
    FOO=BAR
    ```

    - Inheriting the environment
        - Environment is normally passed down from a process to its children and their children in turn. Note that, a process can choose not to pass its environment.
        - `export` will make a variable available to both the shell and children. If `export` is not used, the variable will only be available in the shell, and only shell builtins can access it.

* Time
    - Time Zones and Locales
        - `TZ="America/New_York" <command>`
        - `export TZ="Europe/London"`
        - gettimeofday() returns struct timeval
        - time() returns time_t calendar time which may be converted using ctime(), gmtime(), localtime()
        - gmtime() and locatime() return struct tm which may be converted to human-readable format using strftime() and asctime()

    - Process Time
        - clock() returns clock_t (elapsed process time in usecs) (does not include process time of child processes)
        - times() returns struct tms, used for (detailed breakdown) system and user time of process and its terminated children


Processes
---------

* Program vs Process
    - A program is a list of instructions to be executed (passive) and a process is an instance of a running program (active).
    - More precisely, a process holds the resources that program needs to execute. These resources are pid, effective & real uid, memory, priority, environment, open streams, signal dispositions and current directory.
        - Process memory constitutes:
            1. Heap: area used to dynamically allocate storage for data at runtime - malloc() and free(); there is also a system call sbrk() that can change the heap size but is rarely used
            2. Stack: holds a functions local variables; a function's "stack frame" is allocated when the function is called and de-allocated when it returns
            3. Data: holds global and static variables; divided into initialized and uninitialized pieces
            4. Code: a.k.a text segment; holds the program code; read-only; may be shared with other processes

* Creating a Process
    - `fork()` syscall
    - `exec[l|v]p?e?` syscall (7 variants, ie 8 combinations excluding `execlpe` which doesn't exist)
        - [l|v] specifies if command-line args are passed as a list or a vector
        - p? specifies if the new program is to be looked on the search path or not (if not specified, the complete path has to be passed)
        - e? specifies if the a new environment is to be used or if the environment has to be inherited

        - Note, for the sake of simplicity just remember execv variants: execvp?e? (ie 4 variants)
        - Note, `getpid()` syscall can be used to get PID of the current process

    - `man 3 exit`
        - `void exit(int status);`
        - used for normall process termination and the value (status & 255) is passed back to the parent (0 meaning success, 1-255 meaning failure)
    - `man 2 wait`
        - `pid_t wait(int* status);`
        - used for obtaining status information pertaining to one of caller's child processes
```
int status;
if (fork()) {  /* PARENT */
    wait(&status);
    if (WIFEXITED(status))
        printf("child ended normally, exit status = %d\n", WEXITSTATUS(status));
    if (WIFSIGNALED(status))
        printf("child terminated by signal %d: %s\n", WTERMSIG(status), strsignal(WTERMSIG(status)));
    if (WCOREDUMP(status))
        printf("child produced core dump, signal %d\n", WTERMSIG(status));  // or "child cored" or "child core dumped"
}
else {   /* CHILD */
    printf("child running ... PID is %d", getpid());
    ...
}
```
    - `kill -n <pid>` (n is the signal number >1)
        - `kill -9 <pid>` or `kill -KILL <pid>`
        - `kill -15 <pid>` or `kill -TERM <pid>`
        - `kill -2 <pid>` or `kill -INT <pid>`

* Process Life Cycle
        |
       fork()
        |   \
        |    \
(parent)|     \ (child)
        |      |
        |      |
        |     exec()
        |      |
        |      |
        |      |
wait()  |<---- = exit()
        |
        v

    - Note, the above shown mechanism is a common way of using fork(), exec(), exit(), wait().
    - This is precisely, how the shell operates too. For eg. when executing `ls`, the shell forks making the child execute `ls` while parent waits for it to complete, and then it loops around and prompts for the next command.

Pipes (Anonymous / Named)
-------------------------

- Widely used inter-process communication (IPC) mechanism
- Pipes are unidirectional (upstream end that can be written to and downstream end that can be read from)
- Pipes provide buffering and loose synchronisation between producer (upstream) and consumer (downstream)
    - Producer blocks when writing if pipe is full
    - Consumer blocks when reading if pipe is empty

```
int p[2];
pipe(p);  // system call
```
        __________
p[1] -> __________ -> p[0]

- Copying file descriptors (used for stream redirection)
    - dup(fd) : copies fd onto the lowest available fd; `man 2 dup`
    - dup2(fd1, fd2) : copies fd1 onto fd2 (fd2 is closed first) `man 2 dup2`

- Creating Named Pipes
    - On the command line, `mkfifo /tmp/mypipe`
    - In a program, `mkfifo("/tmp/mypipe", 0644);`

    - Named Pipes for Client/Server (on the same host ie not across a network)
         ----------     _____________
        | Client 1 | <- /tmp/mysrv183 <-
        |          |\   -------------   \
        | PID=183  | \                   \ --------
         ----------   \     __________    |        |
                       -->  /tmp/mysrv -->| Server |
         ----------   /     ----------    |        |
        | Client 2 | /                   / --------
        |          |/   _____________   /
        | PID=254  | <- /tmp/mysrv254 <-
         ----------     -------------

        - Clients 1, 2 can both write to the same named pipe /tmp/mysrv (unidirectional to server),
          but they will read from separate pipes (unidirectional from server for each client) which are named uniquely based on PID.
        - A named pipe allows many clients to write to the same pipe. Linux guarantees that at least
          PIPE_BUF bytes can be written to a pipe atomically (one-shot write). [PIPE_BUF = 4096]


Controlling Access, Identity & Permissions
------------------------------------------

- File permissions
    - `umask()` syscall is used to set permissions (`0666 & ~umask`) while creating a file (umask is short for user mask)
    - after the file has been created the permissions can be changed using `chmod()` syscall (for changing mode)
- File ownership
    - `chown()` syscall or command (for changing owner)
        - `chown` by default follows symbolic links and changes the owner of the actual files (to avoid this use `-h`)
        - `chown` can be used with `-R` for recursively changing the owner
        - `chown [OPTIONS] USER[:GROUP] FILE(s)`
            - `chown -R :infra /spare/local`  # recursively change the group
            - `chown -h snagpal /spare/local`  # change the user and don't follow symlinks
            - `chown --from=snagpal infrad /spare/local`  # verify user and then change to new user
            - `chown --from=snagpal:infra /spare/local/file.txt`  # just verify the user and group
            - `chown --from=infrad:infra snagpal:infra /spare/local/` # change both the user and group


Signals
-------

- An event or notification delivered by kernel to a process that something has happened (possibly external to a process). A process can choose what it needs on receiving a signal to do by providing a signal handler and installing the handler.

- Signal Types

| Signal Name | Number | Default Action |                               Description                               |
|:-----------:|:------:|:--------------:|:-----------------------------------------------------------------------:|
|    SIGHUP   |    1   |      Term      | Hangup detected on controlling terminal or death of controlling process |
|    SIGINT   |    2   |      Term      |               Signal sent by ^C (interrupt from keyboard)               |
|   SIGTRAP   |    5   |      Core      |                          Trace/breakpoint trap                          |
|   SIGABRT   |    6   |      Core      |    assertion failures or abort (causing abnormal process termination)   |
|    SIGFPE   |    8   |      Core      |                         Floating-point exception                        |
|   SIGKILL   |    9   |      Term      |       Kill signal (lethal - cannot be caught, blocked, or ignored)      |
|   SIGSEGV   |   11   |      Core      |                         Invalid memory reference                        |
|   SIGPIPE   |   13   |      Term      |                Broken pipe: write to pipe with no readers               |
|   SIGTERM   |   15   |      Term      |                     Polite "please terminate" signal                    |
|   SIGCHLD   |   17   |  Ign (Ignore)  |                       Child stopped or terminated                       |

- Establishing a Signal Handler
    - `signal(SIGINT, handler);`  // installs SIGHUP signal handler
                |       |
            signal    pointer to signal
             type     handler function
                      or one of:
                       - SIG_IGN to ignore signal
                       - SIG_DFL to restore default
    - `sigaction(SIGINT, &newact, &oldact);`  // much more flexible than `signal()` syscall and should be used always
        - `newact` and `oldact` are of type:
        ```
        struct sigaction {
            void     (*sa_handler)(int);  // handler or SIG_IGN or SIG_DFL
            ...
            sigset_t   sa_mask;  // set of signals to be blocked during execution of handler
            int        sa_flags; // mpdify the behavior of signal (like automatically restart syscalls)
            ...
        };
        ```
        - old sigaction info may be received in `oldact` or can be `NULL` if not desired

```
void handler(int sigtype)
{
    /* handling */
    ...
    return;
}
```

- Signal delivery is entirely asynchronous with whatever the program is doing and it can occur at any point.
  Signals can be blocked during parts of execution of program which shouldn't be interrupted.
  Multiple signals may also be blocked but they are not queued, ie only of them will be delivered when the program unblocks.
    - `sigprocmask(how, &set, &oldset)` can be used for blocking signals
        - `how` can be
            - SIG_BLOCK   - add these signals to mask
            - SIG_UNBLOCK - remove these signals from mask
            - SIG_SETMASK - assign this signal set to the mask
        - `set` of signals to add / remove
        - `oldset` to get old set of signals if desired or `NULL`

- `raise(SIGHUP);`  // raise can be used to send a signal to ourselves

- Use-cases for Signals
    1. Ignore them
    2. Clean-up and terminate
        * SIGTERM is a request to terminate gracefully
            - flush any in-memory data to a file
            - remove any temporary resources that can outlive the process
              like files, message queues, named pipes, child processes, etc.
    3. Re-configure on the fly
        * Daemon processes often use a configuration file when they start up.
            - To allow the daemon to be re-configured without restarting, a signal handler can
              be installed to re-read the file. (The signal used for this is typically SIGHUP.)
            - The daemon can control when this can and cannot happen by setting a process mask.
    4. Report status dynamically
        * Long running daemon program may accumulate internal state information
          which can be useful for dumping usage-statistics, diagnostic-info or
          debugging-output to a file. (The signal used for this is typically SIGUSR1.)
    5. Turn debugging on or off
    6. Implement a timeout
        * To implement timeouts for potentially blocking system calls like read().
          (SIGALRM signal can be used along with not restarting the syscall after the signal.)
    7. Schedule periodic actions
        * SIGALRM signal can be used for this use-case too. The trick is to request another
          alarm before exiting the handler.
