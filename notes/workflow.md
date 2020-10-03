Complete Setup Steps [ssh, bash, tmux, git, vim]
------------------------------------------------

* ssh
	- setup identity (use it for git to do password-less auth)

* bashrc
	- modify bash prompt to add git branch and conda env support
	- also add vimrg function, vi -> vim alias if needed

* tmux
	- copy `~/.tmux.conf`

* git
	- copy `~/.gitconfig`
	- copy `~/.gitignore`

* gdb
	- copy `~/.gdbinit`

* vim
	- copy `~/.vimrc`
	- copy `~/.vim` folder (including `colors` and `bundle` for themes and plugins respectively)
		- prefer to use iTerm2 with background color #1c1c1c and Vim with PaperColor theme
	- plugins
		- pathogen
			```
			$ mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
			```
			[add `execute pathogen#infect()` to vimrc]
			[add `call pathogen#helptags()` to vimrc]
		- vim-fugitive
			```
			$ git clone https://github.com/tpope/vim-fugitive.git ~/.vim/bundle/vim-fugitive
			```
			* features
				- G (or Gstatus)
				- Gdiffsplit
				- Gblame
				- G{commit, push, pull, rebase, merge}
		- fzf.vim
			```
			git clone https://github.com/junegunn/fzf.vim.git ~/.vim/bundle/fzf.vim
			```
			* features
				- Files (search files recursively)
				- Lines (search lines in open buffers)
				- Rg (search using ripgrep)
				- Buffers (open buffers), Windows (open windows)
				- GFiles (git ls-files), GFiles? (git status)
				- B{Lines, Commits, Tags} (for loaded buffer)
				- Lines, Commits, Tags (for open buffers)
				- `C-t`, `C-x`, `C-v` will open the buffer in tab split, a new split or a vertical split
				- History: (command history)
				- History/ (search history)
				- History (closed buffer history)
		- NERDTree

* fzf (fuzzy finder)
	```
	$ git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	$ ~/.fzf/install
	```
	[add `set rtp+=~/.fzf` to vimrc]
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

* rg (ripgrep)
	```
	$ curl https://sh.rustup.rs -sSf | sh # install rust & cargo
	$ cargo install ripgrep
	$ strip ~/.cargo/bin/rg # remove debug symbols from the binary
	```

	refer: http://owen.cymru/fzf-ripgrep-navigate-with-bash-faster-than-ever-before/

* VSCode (+extensions)
	- Remote Development (+SSH +Containers)
	- Rainbow CSV
	- vscode-icons
	- YAML
	- GitLens
	- Docker
	- C/C++ GNU Global
	- Python
	- LaTeX Workshop
