# dotfiles

Setup Steps [bash, ssh, tools (like git, rg, tmux, fzf, vim etc)]
-----------------------------------------------------------------

* ssh
	- setup identity (use it for git to do password-less auth)

* bashrc

* micromamba
	- https://mamba.readthedocs.io/en/latest/installation/micromamba-installation.html#automatic-install
	```
	$ cd ~
	$ "${SHELL}" <(curl -L micro.mamba.pm/install.sh)
	```

	- Installation prompt answers:
	```
	Specify absolute path for "~/.local/bin" for MAMBA_EXE
	Specify absolute path for "~/micromamba" for MAMBA_ROOT_PREFIX
	```

	- Install tools to dedicated env
	```
	$ mm create -n toolenv
	$ mm activate toolenv
	$ echo $CONDA_PREIX # for adding to PATH later
	$ mm install conda-lock tmux xclip vim fzf ripgrep git clang-tools clangxx mold lld gdb rust
	$ mm deactivate
	```

	- Configure condarc (if not already copied condarc)
	```
	$ mm config set always_yes false
	$ mm config set auto_activate_base false
	```
	- Reproduce environment
	```
	$ mm activate toolenv
	$ mm env export > toolenv.yml
	$ conda-lock -f toolenv.yml -p linux-64 --lockfile toolenv-lock.yml
	$ conda-lock install --name toolenv2 toolenv-lock.yml
	```

* tmux
	- copy `~/.tmux.conf`

* git
	- copy `~/.gitconfig`
	- copy `~/.gitignore`

* gdb
	- copy `~/.gdbinit`

* clang++/mold
	- clang++ -std=c++20 -O3 -o main main.cpp -o main

	<br/>
	[Points to note]
	<br/>
 
	- Compiler choice (clang++ or clang)
		* `clang++` if not available, can be substituted with `clang -x c++ -lstdc++`. Installing clangxx from conda-forge should get you clangxx, clang, clang-19, libstdcxx.
	- Linker choice (mold > lld by LLVM > gold by GNU > ld by GNU; from performance perspective)
		* The default linker available on linux would be used when executing the above command (most likely, ld, by GNU).
		*	If you are looking to use lld (by LLVM), you can add:
			`-fuse-ld=lld --sysroot=$MAMBA_ROOT_PREIX/envs/toolenv/x86_64-conda-linux-gnu/sysroot`
		* If you are looking to use mold, you can add:
			`-fuse-ld=mold --sysroot=$MAMBA_ROOT_PREFIX/envs/toolenv/x86_64-conda-linux-gnu/sysroot`

	<br/>
	[Using several compilers via conda/mamba environments]
	<br/>
 
	- The Problem:
		- If you compiled the program using a newer version of GCC/Clang, which links against a newer version of libstdc++, but you are running it on a system that has an older version of the library, you may see:
		```
		./main: /lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.32' not found (required by ./main)
		```
 	- The Solution:
	1. Statically linking the standard library (-static-libstdc++ -static-libgcc) when compiling your program. Note static linking produces a larger executable than dynamic linking as it has to compile all code into a single executable. There are trade-offs in deciding whether to link statically or dynamically (generally preferred) - the former for ease of deployment with no external dependencies; the latter for reaping benefits when shared libraries are upgraded, as the binary doesn't have to be recompiled.
	2. By specifying rpath (or runpath or runtime library search path) at compile time.
	`-Wl,-rpath,/path/to/your/libs` or `-Wl,-rpath,/path/to/lib1,-rpath,/path/to/lib2` (for multiple paths)
	(That is, compile your program like `clang++ -std=c++20 -O3 -Wl,-rpath,$MAMBA_ROOT_PREFIX/envs/toolenv/lib main.cpp -o main`)
	3. By modifying rpath on the binary (after compilation).
	`patchelf --set-rpath /path/to/your/libs ./main`
	To view the current rpath on the binary, you may use `readelf -d ./main | grep "rpath"` (or see them in `ldd ./main`).
	(You can think this is how conda/mamba environment libs get used as rpath: `patchelf --set-rpath $CONDA_PREFIX/lib ./main`).

* rg (ripgrep)
	refer: http://owen.cymru/fzf-ripgrep-navigate-with-bash-faster-than-ever-before/

* fzf (fuzzy finder)
		* features
			- interactive output by `| fzf`
			- reverse search using `ctrl + r`
			- `kill -9 <TAB>`
			- `cd **<TAB>`, `<command> path/to/**<TAB>`
			- `ssh **<TAB>`, `telnet **<TAB>`
			- `alt+c` to open fzf for directory search (and do cd)
			- `ctrl+t` to open fzf for file search

			[see the following for option/alt behaviour on macOS:
			https://github.com/junegunn/fzf/issues/164#issuecomment-86962197]

* vim
	- copy `~/.vimrc`
	- copy `~/.vim/colors` folder (including `colors` and `bundle` for themes and plugins respectively)
		- prefer to use iTerm2 with background color #1c1c1c and Vim with PaperColor theme
	- plugins
		- pathogen
			```
			$ mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
			```
			[add `execute pathogen#infect()` to vimrc]
			[add `call pathogen#helptags()` to vimrc]
		- vim-fugitive
			```
			$ git clone https://github.com/tpope/vim-fugitive.git ~/.vim/bundle/vim-fugitive
			```
			* features
				- G (for git status)
				- Gblame
				- G {commit, push, pull, rebase, merge, etc.}
		- fzf.vim
			```
			git clone https://github.com/junegunn/fzf.vim.git ~/.vim/bundle/fzf.vim
			```

			* Set vim's `rtp` appropriately to detect fzf.vim plugin from fzf installation.
				reference - https://github.com/junegunn/fzf/blob/master/README-VIM.md
			* features
				- Files (search files recursively)
				- Lines (search lines in open buffers)
				- Rg (search using ripgrep)
				- Buffers (open buffers), Windows (open windows)
				- GFiles (git ls-files), GFiles? (git status)
				- B{Lines, Commits, Tags} (for loaded buffer)
				- Lines, Commits, Tags (for open buffers)
				- `C-t`, `C-x`, `C-v` will open the buffer in tab split, a new split or a vertical split
				- History (:oldfiles and open buffer)
				- History/ (search history)
				- History: (command history)
		- NERDTree [optional]
		  ```
			$ git clone https://github.com/preservim/nerdtree.git ~/.vim/bundle/nerdtree
			```
		- TermDebug [optional]
		- Copilot [optional]
		- ALE [optional]
			- Async Linting Engine: use clang-tidy for c/cpp files
