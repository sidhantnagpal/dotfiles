# dotfiles

Setup Steps [bash, ssh, tools (like git, rg, tmux, fzf, vim etc)]
-----------------------------------------------------------------

* ssh
	- setup identity (use it for git to do password-less auth)

* bashrc
	- modify bash prompt to add git branch and conda env support
	- also add vimrg function, vi -> vim alias if needed

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
	$ mm install conda-lock tmux xclip vim fzf ripgrep git clang-tools mold gdb rust
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
