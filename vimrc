" load plugins
execute pathogen#infect()
call pathogen#helptags()

" `:echo &rtp` from vim to verify runtime path addition
let &rtp.=','.expand("$MAMBA_ROOT_PREFIX/envs/toolenv/share/fzf")

set nocompatible                  " be iMproved, required first

filetype plugin indent on         " Enable file type detection

set hlsearch                      " Highlight found searches
set incsearch                     " Switch on incremental search
set ic                            " Ignore case in searches by default
set smartcase                     " ... but not when search pattern contains upper case characters
set showcmd                       " Show me what I'm typing
set showmatch                     " Show matching parentheses
set matchtime=2                   " Tenths of a second to blink when matching brackets
set number                        " Always show line numbers
set ruler                         " Show the cursor position all the time
set laststatus=2                  " Always show the status line
set splitright                    " Split vertical windows right to the current windows
set splitbelow                    " Split horizontal windows below to the current windows
set nospell                       " Enable spell checking depending as per need
set hidden                        " Allow buffers to be hidden even with unwritten changes
set fileformats=unix,dos,mac      " Prefer Unix over Windows over OS 9 formats
set backspace=indent,eol,start    " Makes backspace key more powerful
set autoindent                    " Make new line indent match that of previous line
set smartindent                   " Use smart indentation
set wrap                          " Wrap lines
set autowrite                     " Automatically save before :next, :make etc.
set autoread                      " Automatically reread changed files without asking me anything
set encoding=utf-8                " Use default encoding as UTF-8
set matchpairs+=<:>               " Make % jump between angular braces too in addition to other braces
set noeb vb t_vb=                 " No beeps
set noswapfile                    " Don't use swap file (*.ext.swp)
set nobackup                      " Don't use backup file (*.ext~)
set nowritebackup                 " Don't create temporary backups while saving files
set noundofile                    " Don't use persistent-undo files
set display+=lastline             " Show as much of lastline as possible instead of @

set clipboard=exclude:.*          " Vim 9.1+ speedup (https://stackoverflow.com/a/17719528)

" Better Completion
set complete=.,w,b,u,t
set completeopt=longest,menuone
set complete-=i                   " Limit the files searched for auto-completes

" Sane row/col appearance while scrolling
if !&scrolloff
  set scrolloff=1                 " The number of screen lines to keep above and below the cursor
endif
if !&sidescrolloff
  set sidescrolloff=5             " The number of screen columns to keep to the left and right of the cursor
endif

" Improve performance
set ttyfast                       " Allow fast scrolling
set lazyredraw                    " Don’t update screen during macro and script execution (can delay appearance of laststatus)
" Speed up syntax highlighting
set nocursorcolumn
set nocursorline
set norelativenumber
syntax sync minlines=256
set synmaxcol=1000
set re=1

" Increase command history
if &history < 1000
  set history=100
endif

" Time out on key codes but not mappings. Basically, this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=10


" Enable mouse mode if available
if has('mouse')
  set mouse=nic
  " For selecting text off vim (use `:set nonu` if required)
  "     Terminal copy - shift + mouse select (on macOS, use option/fn instead of shift)
  "     Tmux copy - <enable visual mode> and do mouse selection
  "     Vim copy - <enable visual mode> and do command mode operations
endif
" If linux then set ttymouse
let s:uname = system("echo -n \"$(uname)\"")
if !v:shell_error && s:uname == "Linux" && !has('nvim')
  set ttymouse=xterm
endif


" Enable syntax highlighting
syntax enable

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Use 24-bit (true-color) mode in vim/neovim
" outside tmux or in tmux>=2.2
if has("termguicolors")
  set termguicolors
endif

set background=dark
try
  colorscheme PaperColor " desert, slate, peachpuff, solarized, etc.
catch
endtry


" Set the tab key to indent 4 spaces
set shiftwidth=4
set softtabstop=4
" Use spaces instead of tabs
set expandtab

" Set the spelling language to American English
set spelllang=en_us

" For command mode tab-completion (shift-tab for opposite order)
set wildmenu
set wildmode=longest:full,list,full

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup vimrcEx
  autocmd!

    " Clear trailing whitespace on save
    autocmd BufWritePre * :%s/\s\+$//e

    " Jump to last known cursor position in the file
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif

    " Disable smartindent for python, creates problem typing hash in a newline
    autocmd FileType python setlocal nosmartindent indentkeys-=<:>

    " For c/cpp
    autocmd BufNewFile,BufFilePre,BufRead *.h,*.c setfiletype cpp

    " For go
    autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4 nolist

    " Don't expand tabs for configs, dockerfiles
    autocmd FileType gitconfig,sh,toml,dockerfile,tsv setlocal noexpandtab

    " For yaml, json
    autocmd FileType yaml,json setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

    " For Makefile
    autocmd FileType make setlocal noexpandtab shiftwidth=8 softtabstop=0

    " For Dockerfile
    autocmd FileType dockerfile set noexpandtab

    " shell/config/systemd settings
    autocmd FileType fstab,systemd set noexpandtab
    autocmd FileType gitconfig,sh,toml set noexpandtab

    " Enable spell check for git commits
    autocmd FileType gitcommit setlocal spell

    " For Markdown
    autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
    autocmd FileType markdown setlocal spell tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab

  augroup END
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
        command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                                \ | wincmd p | diffthis
endif " to exit this `:bd` to delete buffer scratch and `:diffoff` to hide the bar

" This comes first, because we have mappings that depend on leader
" With a map leader it's possible to do extra key combinations
" i.e: <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Close quickfix easily
nnoremap <leader>a :cclose<CR>

" Remove search highlight
nnoremap <leader><space> :noh<CR>

" Toggle paste mode on and off (trailing ! is a neat trick for toggling an option) and show status
map <c-p> :setl paste! paste?<CR>


" ================ vim-fugitive ===============
" :h fugitive   for help
nnoremap <leader>gp :Git push
" :G<CR>        for git status;
"               g? for staging/unstaging maps
"                   move cursor to file and
"                       press 's' for stage
"                       press 'u' for unstage
"                       press '=' for inline diff
"                       press 'o' to open file in another split (use :q to
"                           quit specific window (represents viewport to a buffer),
"                           using :bd deletes buffer (represents open file) from
"                           buffer list effectively closing all windows.)
"                       press 'I' for git add -p (on staged file) or
"                           git reset -p (on unstaged file)
"
"               d? for diff maps
"                   move cursor to stage/unstaged file and
"                       press 'dv' for :Gvdiffsplit view
"
"               c? for commit maps
"                   move cursor to commit and
"                       press 'ca' for commit ammend
"                       press 'coo' to checkout to the commit under cursor
"                       press 'c<space>' for :Git commit<space>
"                       press 'co<space>' for :Git checkout<space>
"                       press 'cr<space>' for :Git revert<space>
"                       press 'cm<space>' for :Git merge<space>
"                       press 'crc' to revert the commit under cursor
"                       press 'crn' same as crc but dont actually commit
"
"               cz? for stash maps
"                       press 'cz<space>' for :Git stash<space>
"
"               r? for rebase maps
"                       press 'ri' for interactive rebase (on the commit under cursor)
"                       press 'ra' for abort the current rebase
"
" :G log        for git log
" :G blame      for git blame
" :Gw           for write, git add
" :Gwq          for write, git add, quit if successful (similarly, Gwq! iykyk)
" :Gr           for :Git read, similar to git checkout -- filename,
"                   but does not write anything to disk, which means,
"                   you can do 'u' (undo) to redo the changes.

nnoremap <leader>gd :Gvdiffsplit<space>
" with
"   (no args) <CR> it shows the dirty diff (current vs staged)
"   HEAD <CR>      it shows the diff of current (unstaged+staged) from HEAD
"   HEAD~3:% <CR>  it shows the diff of current (unstaged+staged) from 3 commits ago
" from current version to 3 commits ago

" set status line to include git branch (if version controlled)
set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P


" ==================== fzf ====================
if executable('tmux')
  let g:fzf_layout = { 'tmux': '90%,70%' }
else
  let g:fzf_layout = { 'window': 'enew' }
endif

" for grepping all file(s) lines
nnoremap <leader>g/  :Rg<CR>
" for grepping git ls-file(s) lines
nnoremap <leader>gg/ :Rgg<CR>
" for open file(s) lines
nnoremap <leader>l/  :Lines<CR>
" for current file lines
nnoremap <leader>/   :BLines<CR>
" for current file commits
nnoremap <leader>c   :BCommits<CR>
" for old/open files
nnoremap <leader>h   :History<CR>
" for open files
nnoremap <leader>b   :Buffers<CR>
" for all files
nnoremap <leader>f   :Files<CR>
" for git ls-files
nnoremap <leader>gf  :GFiles<CR>
" for git status
nnoremap <leader>gs  :GFiles?<CR>


if executable('rg')
  " Use ripgrep for :grep
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --hidden

  command! -bang -nargs=* Rgg
    \ call fzf#vim#grep(
    \   'git ls-files -z | xargs -0 rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>),
    \   1,
    \   fzf#vim#with_preview(),
    \   <bang>0)

elseif executable('ag')
  " Use ag for :grep
  set grepprg=ag\ --vimgrep\ --nogroup\ --nocolor\ --hidden\ --smart-case
endif


"==================== NerdTree ====================
"" For toggling
nmap <C-n> :NERDTreeToggle<CR>
noremap <leader>n :NERDTreeToggle<CR>

let NERDTreeShowHidden=1

let NERDTreeIgnore=['\.vim$', '\~$', '\.git$', '.DS_Store']

" Close nerdtree and vim on close file
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif


"==================== TermDebug ====================
if v:version >= 801
  packadd! termdebug  " ensure gdb >= 7.12

  " For widescreen code viewing
  let g:termdebugger_layout='vertical'

  " Add mapping to load termdebug
  noremap <silent> <leader>td :Termdebug<CR>
endif

"==================== Copilot ====================
let g:copilot_enabled=0

"==================== ALE ====================

" Enable Asynchronous Linting Engine
let g:ale_enabled = 1

" Set clang-tidy as the only linter for C and C++
let g:ale_linters = {
    \ 'cpp': ['clangtidy'],
    \ 'c': ['clangtidy'],
    \ }

" Disable fixers for C and C++ (optional)
let g:ale_fixers = {
    \ 'cpp': [],
    \ 'c': [],
    \ }

" Customize clang-tidy options (optional)
let g:ale_clangtidy_options = '-checks=*,-clang-analyzer-alpha.*'

" Set when to lint
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'always'
