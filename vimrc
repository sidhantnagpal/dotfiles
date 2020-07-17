" load plugins
execute pathogen#infect()
call pathogen#helptags()
set rtp+=~/.fzf

set nocompatible                  " be iMproved, required first

filetype plugin indent on         " Enable file type detection

set hlsearch                      " Highlight found searches
set incsearch                     " Switch on incremental search
set ic                            " Ignore case in searches by default
set smartcase                     " ... but not when search pattern contains upper case characters
set showmatch                     " Show matching parentheses
set number                        " Always show line numbers
set laststatus=2                  " Always show status, current position (instead of `set ruler`)
set splitright                    " Split vertical windows right to the current windows
set splitbelow                    " Split horizontal windows below to the current windows
set nospell                       " Enable spell checking depending as per need
set hidden                        " Allow buffers to be hidden even with unwritten changes
set fileformat=unix               " Prefer UNIX file format
set backspace=indent,eol,start    " Makes backspace key more powerful
set autoindent                    " Make new line indent match that of previous line
set display+=lastline             " Show as much of lastline as possible instead of @
set diffopt+=vertical             " Prefer vertical diff

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

" Increase undo history
if &history < 1000
  set history=100
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

" Use default encoding as UTF-8
set encoding=utf-8

" Enable syntax highlighting
syntax enable
if has("gui_running")
  set regexpengine=1
  syntax enable
endif

colorscheme molokai-custom
" set background=dark
" colorscheme slate

" Use the macOS/Linux system clipboard
set clipboard=unnamedplus
" Set the tab key to indent 4 spaces
set shiftwidth=4
set softtabstop=4
set smartindent
set autoindent
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

    " Don't expand tabs for configs, dockerfiles
    autocmd FileType gitconfig,sh,toml,dockerfile,tsv set noexpandtab

    " For yaml, json
    autocmd FileType yaml,json setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

    " For Makefile
    autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

    " Enable spell check for git commits
    autocmd FileType gitcommit setlocal spell

  augroup END
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
        command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                                \ | wincmd p | diffthis
endif " to exit this `:bd` to delete buffer scratch and `:diffoff` to hide the bar

" Ctags
set tags=.git/tags;/

" This comes first, because we have mappings that depend on leader
" With a map leader it's possible to do extra key combinations
" i.e: <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Close quickfix easily
nnoremap <leader>a :cclose<CR>

" Remove search highlight
nnoremap <leader><space> :noh<CR>

" ================ vim-fugitive ===============
nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gd :Gvdiffsplit<space>

" ==================== fzf ====================
" let g:fzf_layout = { 'down': '~70%' }
let g:fzf_layout = { 'window': 'enew' }
nnoremap <leader>r/ :Rg<CR>
nnoremap <leader>l/ :Lines<CR>
nnoremap <leader>/ :BLines<CR>
nnoremap <leader>c :BCommits<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>w :Windows<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>gf :GFiles<CR>
nnoremap <leader>h :Hist

if v:version >= 801
  packadd termdebug  " make sure gdb >= 7.12
endif
