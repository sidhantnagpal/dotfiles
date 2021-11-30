Extraction
----------
* `sed` [-inE], (n is for suppressing automatic printing)
* `awk` [-F]
* `cut` [-cdf]
    - `cut -d',' -f1,3,6-8` : select fields (cols) - 1,3,6,7,8
    - `cut -c 9-` : select chars - 9 to EOL
    - `cut -f -9` : select fields - till 9
    - `cut -f -8,10-` : select fields - all but 9
* `tr`
    - `tr -d '\r\n'` : delete carriage return and newline chars
    - `tr 'abc' 'xyz'`: replace a with x, b with y, c with z
* `sort` [-ugnsrm], (u - unqiue, g - float, n - numeric, s - stable, r - reverse, m - merge)
* `uniq`
* `strings`
* `tee`
* `nohup <command> &`
* `seq`
* `tar xzf` (extract) or `tar czf` (compress) [use `v` for verbose, `z` creates .tar.gz/.tgz & without `z` .tar is created]

General
-------
* `cat`, `zcat` (on gz files) (concatenate files and print on standard output)
* `less`, `zless` (on gz files, less also works)
* `grep` [-ionErvcC], `zgrep` (r - recursive, v - invert, c - count, C - context of lines, above and below)
* `tail` [-fFn]
    - `tail -10` or `tail -n10`  # get last 10 lines
    - `tail -n +10`  # get all but first 10 lines

* `head` [-n]
    - `head -10` or `head -n10`  # get first 10 lines
    - `head -n -10`  # get all but last 10 lines
* `xargs`
* `diff` [-qs], `cmp`, `vimdiff`
* `shasum` [-a 256]
* `column` [-tns]
* `which` [-a]
* `who`, `whoami`
* `rup`  (displays the status of a remote host by broadcasting on the local network)
* `type`, `file`, `stat`
* `true`, `false`
* `time`
    - "user" denotes time spent in user-space
    - "sys" denotes time spent in kernel-space (syscalls)
    - "real" denotes total time elapsed (= user + sys) ie the wall-clock time
* `man` [-k]
    - `man chmod` gives the manual page for "chmod" user command (like `man 1 chmod`)
    - `man 2 chmod` gives the manual page for "chmod" syscall (system call)
    - section 1 contains user commands, section 2 contains system calls

Directory
---------
* `tree`
* `find` [-name]
* `ls` [-ltr]
* `cd ..`  or  `cd -`  or `cd .`
* `mkdir` [-p]
* `rm` [-rf]
* `pushd .`, `popd`, `dirs` (list the directories in stack)
    - `pushd <dir>` will push to directory stack and also cd to path (to prevent the latter use `pushd -n <dir>`)
    - `popd` pop the top of directory stack
    - `dirs -v` to list the directory stack (with indices)
    - `pushd` without args swaps the top two elements of stack
    - `dirs -c` to clear the directory stack
        * When working with just two directories:
            - `cd <dir>` and `cd -` will suffice
        * When working with more than two directories:
            - `pushd <dir>` for the working directories
            - `dirs -v` to list dir stack
            - `cd ~0` (or 0,1,2,..N index from the above output)
            - `dirs -c` to clear the directory stack
* `df -ah` (disk free, reads superblocks)
* `du -sh` (disk usage, reads individual blocks and sums them)
* `mount` (list existing mounts)

Git
---
* Checking-in from another repo, while preserving commit history:
    - https://stackoverflow.com/a/11426261
    ```
    git log --pretty=email --patch-with-stat --reverse -- path/to/file_or_folder | (cd /path/to/new_repository && git am --committer-date-is-author-date)
    ```
* Checkout
        - git checkout -b <branch> <base>
* Commit
        - git commit --amend (delete everything to abort)
* Stash
    - git stash
    - git stash [list | pop | drop]
    - git stash show -p  # view most recent stash diff
    - git stash show -p stash@{1}  # view diff of arbitrary stash
* Diff
        - git diff > patch  # create a patch file
        - git diff branch1..branch2  # compare two branches
        - git diff branch1..branch2 <filepath>  # compare file on two different branches
        - git diff --no-index <dir1> <dir2>  # compare contents of two directories (even if they're not vc'ed, that's why --no-index)
* Stage
    - `git add -p <dir/file>`  # interactively choose hunks from patch for staging, following options will be shown among others in prompt:
        * y - yes
        * n - no
        * a - all hunks following this hunk (inclusive)
        * s - split current hunk into smaller hunks
        * q - quit
        * ? - help
    - `git reset -p <dir/file>` # interactively choose hunks from patch for unstaging, similar prompt.
* Patch
    - `git apply <patch>`
    - `git apply -R <patch>`
    - `git apply -3 <path>` (3-way merge, shows conflict markers if any)
* Pull
    - `git pull --ff-only` (bail out if fast forward not possible)
    - `git pull --rebase` (or `git merge --no-ff`)
* Merge
    - git merge [upstream]
* Rebase
    * git rebase [upstream]
    * Interactive Rebase [fixup, reword, edit, pick etc.]
        - `git rebase -i HEAD~7` to perform interactive rebase of last 7 commits
            (_delete everything in the prompt to abort the rebase_)
* Log
    * `git log --pretty=format:'%h : %s' --graph > log.log`
        - https://stackoverflow.com/a/10063456
    * `git log -g` or `git reflog` to walk through reflog entries
        - `git reset --hard HEAD@{5}` can be used to do undo the last 5 git actions

Process
-------
* `top`, `htop` [-u <user>]
* `pgrep`
* `pkill` or `kill`
* `taskset` [-cp]
* `numactl` [--membind]
* `systemctl status <service>` (status of service)
* `ps`
    - `ps -fce`
        * ps -e, select all processes
        * ps -f, "full" format specifier
        * ps -c, CMD column contains just the executable name instead of full path
    - `ps -fcp $(pgrep -f docker)`
        * ps -p, select by pid (accept PID(s) as positional argument(s))
        * pgrep -f, search pattern in full path instead of the process name (which is the default)
        _Advantage of this approach over `ps -ef | grep docker` is that the header is retained in output of ps, plus, redundant matches are prevented due to other columns in output of ps._

    - `ps -eLo user,pid,ppid,lwp,state,pcpu,pmem,policy,rtprio,psr,comm`

    - Real-time monitoring (sorted in DESC by %mem and in ASC by %cpu)
        `watch -n 1 'ps -eo pid,ppid,cmd,pmem,pcpu --sort=-pmem,+pcpu | head'`

    - With thread information:
        - represented by LWP column (contains light weight process (thread) ID)
        - aliases: tid,spid
        * `ps -eLf`
    - With scheduling policy information:
        - represented by CLS column (contains sched class of the process)
        - aliases: policy,class
        * `ps -o user,pid,cmd,policy,rtprio,nice`
        * Possible values in CLS column:
            -   not reported
            TS  SCHED_OTHER
            FF  SCHED_FIFO
            RR  SCHED_RR
            B   SCHED_BATCH
            ISO SCHED_ISO
            IDL SCHED_IDLE
            DLN SCHED_DEADLINE
            ?   unknown value
        * `SCHED_OTHER` is the default universal time-sharing (TS) scheduler policy used by most processes; `SCHED_FIFO` and `SCHED_RR` are intended for special time critical applications aka real-time (RT) processes.
        * In order to select a process to run, the Linux scheduler must consider the priority of each process. There are two kinds of process priority:
            - A static priority (aka real-time priority) value is assigned to each process and scheduling depends on this static priority. Processes scheduled with `SCHED_OTHER` have _static priority 0_; processes scheduled under `SCHED_FIFO` or `SCHED_RR` can have a _static priority in the range 1 to 99_ (99 is the highest).
            - Dynamic priority (aka nice value) is used for non-real time processes.

* `mkfifo` (named pipes, used for IPC)
* `lsof` (list open files)
* `daemonize`

Jobs
----
* Processes that are managed by shell (each of which has a sequential job ID and an associated PID). See https://www.thegeekdiary.com/understanding-the-job-control-commands-in-linux-bg-fg-and-ctrlz/.

* `jobs` (list the jobs running in background)
    - `jobs -ps` (list the PIDs (-p) of stopped (-s) jobs)
* Status of a job
    - Foreground
        * `fg [%N]` (bring the current or specified job with job ID N to foreground)
    - Background
        * `<command> &`
        * `bg [%N]` (place th current or specified job with job ID N to background)
    - Stopped
        * If `^Z` is pressed for a fg job or `stop` is issued for a bg job, the job stops.
        * Note, when you place a stopped job either in the foreground or background, the job restarts.
* `%-` indicates last job, `$!` indicates last background process


Network
-------
* `ping`, `traceroute`
* `ethtool`

* net-tools commands    superseded by   iproute commands
    * `arp`                                 `ip neigh`
    * `ifconfig`                            `ip [addr|link]`
    * `netstat`                             `ss`
    * `route`                               `ip route`

    - net-tools commands are legacy but still more widely available than iproute commands.
    - `arp` (view or modify ARP tables on the system to see information about neighbors)
    - `ifconfig` "interface configuration" (view or modify network interfaces on a system)
    - `netstat` "network statistics" (monitor network connections both incoming/outgoing, view routing tables, interface statistics, etc.)
    - `route` (view or modify IP routing table)

    Overview of `ip` subcommands to view/modify:
        * Kernel's ARP table
            `ip n[eigh]`
                (use `ip n [show <inet-prefix>]` to display entries for specific address)
                (use `ip n [show dev <ifname>]` to display entries for specific interface)
        * Network devices & configuration:
            `ip l[ink]` (use `[show <ifname>]` for details of a specifc interface)
            `ip a[ddr]` (similar to `ip link`, also shows inet addresses)
            `ip m[addr]` (for multicast addresses)
        * Kernel's Routing Table
            `ip r[oute]` (`ip route get <dst>` is useful for querying the interface (and gateway) which will be used to route a packet to a given IP address)

    Networking Mnemonics:
        - inet: Internet protocol (IP) family
        - inet6: Internet protocol version 6 (IPv6) family
        - ifname: Interface name
        - dev: Device
        - ARP: Address Resolution Protocol

* `netstat` [-nap]
    - p shows protocol information, for only tcp ports use -t, for only udp ports use -u
* `nc` or `ncat` (concatenate and redirect sockets)
    * protocol options
        -4 (IPv4 only)
            Force the use of IPv4 only.

        -6 (IPv6 only)
            Force the use of IPv6 only.

        -U, --unixsock (Use Unix domain sockets)
            Use Unix domain sockets rather than network sockets. This option may be used on its own for stream sockets, or combined with
           --udp for datagram sockets.

        -u, --udp (Use UDP)
            Use UDP for the connection (the default is TCP).

    * connect mode options
        -p port, --source-port port (Specify source port)
        -s host, --source host (Specify source address)

    * listen mode options
        -l, --listen (Listen for connections)
            Listen for connections rather than connecting to a remote machine

        -m numconns, --max-conns numconns (Specify maximum number of connections)
            The maximum number of simultaneous connections accepted by an Ncat instance. 100 is the default (60 on Windows).

        -k, --keep-open (Accept multiple connections)

    * output options
        -o file, --output file (Save session data)
        -x file, --hex-dump file (Save session data in hex)
        --append-output (Append output)

    * misc options
        --recv-only (Only receive data)
        --send-only (Only send data)

* `socat` (Socket CAT)
    * more flexible than `nc` (or `ncat`)
        * more flexible than `telnet`
* `nslookup` (name server lookup for DNS)

* `hexdump` [-C]
    - for displaying contents of binary files in hex/dec/oct/ascii
    - `-c` for one-byte character display, `-C` for one-byte canonical display (hex+ascii), `-b` for one-byte octal display

* `xxd` [-r]
    - make a hexdump or reverse it (using -r)
    - `-s offset -l len` can be used to run `xxd` on a portion of input
    - `-g bytes` can be used to specify the size of group in bytes
    - `-p` for plain hexdump style

    _Analyzing or converting a hexdump output to specific format_
        `cat | cut -c 6- | tr -d ' \n' | xxd -r -p | hexdump -C`
    - paste the hexdump output to stdin for input to `cat`
    - `cut` will strip the starting address prefixes
    - `tr` will convert the hexdump to plain format (like the output of `xxd -p`)
    - `xxd -r` will then reverse the hexdump output to binary format
    - `hexdump -C` or `xxd -g 1` or custom format can be used to analyze the hexdump

* pcap (packet capture) tools
  - `tcpdump` - limited protocol decoding but available on most nix-systems (native capture format is libpcap aka regular pcap)
  - `termshark` - interactive CLI-based alternative for wireshark (uses `tshark`)
  - `wireshark` - powerful sniffer which can decode lots of protocols, lots of filters; following tools ship with wireshark:
    * `tshark` : command-line for wireshark (native capture format is libpcap like tcpdump)
    * `rawshark` : dump and analyze raw libpcap data

    * `dumpcap` : engine used by wireshark/tshark, whose only purpose is to capture network traffic while retaining advanced features
    * `editcap` : edit and/or translate the format of capture files (eg. `editcap -F pcapng in.pcap out.pcap` will convert in.pcap in libcap format to out.pcap with pcap-ng format)
    * `mergecap` : merges multiple capture files into one
    * `reordercap` : reorder input file by timestamp into output file

    * `text2pcap` : generates a capture file from an ASCII hexdump of packets
    * `randpkt` : random packet generator (generates a pcap file with random packets)

    * `capinfos` : capture information statistics from a saved capture file

  _Note 1_:
    - `wireshark` or `tshark` can be used for both capturing and analysing traffic
    - `dumpcap` and `tcpdump` can both be used for only capturing traffic
      * although, tcpdump is available by default on most nix-systems, dumpcap is suited for long-term capturing and has more features

  _Note 2_: pcap-ng (next generation pcap) is better than libpcap (regular pcap) format as
    - It supports captures form multiple interfaces
    - It improves timestamp resolutions (libpcap only supports microsecond resolution at best)
    - It has additional metadata in capture file and has an extendable format

* `tcpdump` -i<interface> -w<pcap-path> -Z<user> -nnls0 -c<count> 'expression'
    - for dumping network traffic as pcap
    - supports ARP, RARP, ICMP, TCP, UDP, IP, IPv6 among many protocols
    - eg. expressions (capture filters) (can include and/or/not)
        * host <ipaddr> and port <port>
        * dst <ipaddr> and src <ipaddr>
        * tcp and net 192.168.1.4/24
        * src port <port> and dst <ipaddr>
    - types of TCP control flags
        * SYN (synchronization) - initiates a connection
        * ACK (acknowledgement) - acknowledges received data
        * FIN (finish) - closes a connection
        * RST (reset) - aborts a connection in response to an error
        * PSH (push) - asks to push the buffered data to the receiving application
        * URG (urgent) - bypass the queue

* `termshark` [-r]
```
    -i=<interfaces> Interface(s) to read.
    -r=<file> Pcap file to read.
    -d=<layer type>==<selector>,<decode-as protocol> Specify dissection of layer type.
    -D Print a list of the interfaces on which termshark can capture.
    -Y=<displaY filter> Apply display filter.
    -f=<capture filter> Apply capture filter.
    -t=<timestamp format>[a|ad|adoy|d|dd|e|r|u|ud|udoy] Set the format of the packet timestamp printed in summary lines.
```
    - To read a capture: `termshark -t a -r <pcap>` (absolute) or `termshark -t r -r <pcap>` (relative)
    - To read a interface: `termshark -i eth0`
    - Example filter to use:
    `tcp && (ip.src==10.146.105.171 || ip.dst==10.146.105.171) && (tcp.port eq 20360 || tcp.port eq 40360) && tcp contains SCHLO`

* `wireshark`/`tshark` [-r]
    - for analysis of encrypted traffic from pcap and key
    - tshark is just terminal-based wireshark
    - tshark can work with compressed pcaps (pcap.gz)
    - eg.
        `tshark -r <pcap-path> -Tfields -Eheader=y -e frame.number -e frame.time_epoch -e frame.len -e _ws.col.Info -e data`
    - data is printed as a hex string
    - to get hex-ascii bytes printed, convert hex string to binary using `xxd -r` first and then use `hexdump -C`
        `echo <hex-string> | xxd -r -p | hexdump -C`
    - Len = length(data) = frame.len - length(TCPHeader)

#### Capturing & Viewing Packets
```
tcpdump -i eth0 -Z snagpal port 22 and not host 172.30.247.4 -U -w - | tee filename.$(date +%Y-%m-%d.%Z.%H.%M.%S).pcap | tcpdump -U -n -r -
```

`-U` tells tcpdump to use packet buffering for writing
`-w -` tells tcpdump to write binary data to stdout
`tee` writes binary data to pcap file and its own stdout
`-r -` tells tcpdump to read binary data from stdin

_Note_ The final `-U` is important for displaying packets on stdout as they are captured. If the capture is not to be saved, the tee command (in the middle) can be removed. After the capture has been completed, it is better to use `tshark -r` instead of `tcpdump -r` for packet analysis.

#### Analyzing Packets
`tshark -nr capture.pcap` (or `tshark -nr capture.pcap.gz`) with `-V` optionally specified for viewing packet details (or `-Vx` if the hex, ASCII dump of packet data is also desired)

_The tcpdump equivalent for this would be `tcpdump -nr capture.pcap`._

*Points to Note*
1. TShark by default displays relative timestamps. To use absolute timestamps, the timestamp format can be specified as `-t a`.
2. For single-pass analysis (-Y <filter>), use `-Y 'tcp'` for display filtering. For two-pass analysis (-R <filter> -2 -Y <2nd-filter>), use `-R 'tcp' -2 -Y "frame.number == 5"` for display filtering.
3. To save just one particular packet as a pcap, copy the hexdump from data section in the output of `tshark -r <path/to/pcap> -Vx` and use `text2pcap - oup.pcap` to paste hexdump on stdin (and press ^D) to save the pcap. See [reference](https://www.wireshark.org/docs/wsug_html_chunked/ChIOImportSection.html).


Conda
-----
* conda activate <env-name>
* conda deactivate
* conda env list
* conda env export
* conda list <package-name>
* conda env remove -n <env-name>
* conda create -n <env-name> python=3.7
* conda create -n <env-name> --clone <env-name>
* conda config --add channels conda-forge

* conda config --set auto_activate_base false
* conda config --set changeps1 true


Docker
------
* Containers
    - `docker run -it --name geekc7 centos:7 /bin/bash`  # run a command inside a container, note that pressing `^D` exits (stops) the container
    - `docker ps -a`  # list all containers
    - `docker attach`  # attach standard streams to running container
    - `docker [start|stop|restart|kill] <name/id>`
    - `docker rm` # remove a container
* Images
    - `docker image ls -a`  # list all images
    - `docker image rm <name/id>`  # remove an image
    - `docker [push|pull]`  # push/pull image to/from a registry
    - `docker [save|import]`  # save or import tarball for filesystem image
    - `docker build`  # build an image from a Dockerfile
    - last 3 commands can also be accessed as subcommands of `docker image [push|pull|save|import|build]`

* Docker images are immutable as opposed to Conda environments which are mutable.
* Image is to Container, as, Program is to Process. (basically, a container is a running instance of image)
* To switch from interactive mode to daemon mode, the control sequence `^P^Q` can be used to detach and then the container can be reattached using `docker attach <name/id>`.
* Copy to/from docker container using `docker cp mycontainer:/foo.txt foo.txt` or `docker cp bar.txt mycontainer:/bar.txt`.
* Instead of using tmux inside containers, use tmux on the main system and in different tmux panes/windows attach the started container multiple times.

Usability
---------
* directory list using <tab> completion
* <ctrl+r> for reverse-i-search (also in ipython)
* partially typed command and <up-arrow> for completion (only in ipython)
* most bash commands work with glob expressions
* piping using "|", stream redirection using "<"/">"
* here-string "<<<" and here-doc "<<"
* `$!` is the PID of last job run in the background
* `$$` is the PID of script itself
* `$?` is the return value of last command
* see also, `$@` and `$#`
* `touch path/to/hello{a, b, c}` to create multiple files with same prefix
* `set`
    - Use `set -euxo pipefail` for safer bash scripts.
    [src](https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/)
    - Using '+' rather than '-' causes these options to be turned off. The options can also be used upon invocation of the shell. The current set of options may be found in $-. [src](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html#The-Set-Builtin)
    - This can also be written directly in the shebang line like:
    `#!/bin/bash -ex`

Utilities
---------
* `tmux`
* `vim`, `vi`, `nano`
* `curl`, `wget`
* `git`
* `jq`
* `ssh`, `scp` [-r], `rsync` [-azPL]
    - With -L specified in rsync, sync will happen for the contents of files/directories linked to, rather than the symlink
* `rlwrap` (readline wrapper)
* `crontab` [-elr], (e - edit, l - list, r - remove)
    * for scheduling cron jobs on linux
    * format of cron table entry (DOW stands for Day of Week, 0 = 7 = Sunday):
    ```
    Minute  Hour    Date    Month       DOW         CMD
    0-59    0-23    1-31    1-12        0-7
                            or          or
                            JAN-DEC     SUN-SAT     <cmd>
     *       *       *       *           *          <cmd>
    12,46   1,2,20  7,29    MAR,AUG     3,5         <cmd>
    12-34/2 6-12    7-14    3-8         MON-FRI     <cmd>
    ```
    * eg. To run a cron every 90 minutes, entry would look like:
    ```
    Minute  Hour    Date    Month       DOW         CMD
    0       */3     *       *           *           <cmd>
    30      1/3     *       *           *           <cmd>
    ```
        - the first entry will run the cmd every 180 minutes starting from 0hrs.
        - the second entry will run the cmd every 180 minutes
        starting from 1.5hrs, hence covering all the instants.
    * eg. To run a cron at 23:30 on last day of each month:
    ```
    Minute Hour Date  Month DOW     CMD
    30     23   28-31   *    *   test $(date -d tomorrow +%d) -eq 1 && <cmd>
    ```

C++
---
* `ldd` (used to find shared library dependencies of an executable) (short for "List Dynamic Dependencies")
    - there are two types of libraries
        - static libraries
            - `*.a` files in Linux or `*.lib` files in Windows
            - the actual code is extracted from the library by the linker and used to build the final executable at compilation
            - since everything is bundled with the application
                - speed: no additional run-time loading costs
                - recompilation: any change in static libraries needs a recompilation
                - clients of the application do not need to have the right library (and version) on their system

        - dynamic libraries
            - `*.so` files in Linux or `*.dll` files in Windows
            - doesn’t require the code to be copied, it is done by just placing name of the library in the binary file
            - actual linking happens when the program is run, when both the binary file and the library are in memory
            - hence, dynamically linked libraries leave smaller memory footprints (in terms of RAM) since they're shared across processes

* `gcc` (GNU C Compiler), `cc` (or `clang`) (LLVM Clang Compiler)
* `objdump` [-d]
  - display information from object files
  - `-d` can be used for disassembly (see https://stackoverflow.com/a/49732039)
* `ar` (GNU ar)
  - program creates, modifies, and extracts from archives
* `ld` (GNU Linker)
  - ld combines a number of object and archive files, relocates their data and ties up symbol references
  - Usually the last step in compiling a program is to run ld

* GNU Make (build system) vs Ninja
    - `make` uses Makefile or makefile
* GNU Autoconf vs CMake (build generator)
    - GNU Autoconf helps generate a (Makefile from Makefile.in) and/or (config.h from config.h.in) using a script `configure` based on system settings
    - CMake uses configuration file CMakeLists.txt to generate the build system
* Pointer interpretation
    - [Read backwards](https://stackoverflow.com/a/1143272)
```
Type const* const&; // reference to const pointer to const Type
Type const*; // pointer to const Type
Type * const; // const to pointer to Type
Type const **; // pointer to pointer to const Type
Type const * const *; // pointer to const pointer to const Type
```

    - Providing const iteration over internal class member through std::for_each and const qualifier
        - https://softwareengineering.stackexchange.com/a/264912
        - https://stackoverflow.com/q/5439393

Debugging
---------
* White-Box
    - `gdb`, `pdb`
    - `valgrind`
* Black-Box
    - `perf`
    - `strace`
    - `ltrace`
    - `ptrace`
