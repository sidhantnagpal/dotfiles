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
"if has("termguicolors")
"  set termguicolors
"endif

set background=dark
let g:solarized_termcolors=16
let g:solarized_termtrans=1
try
  colorscheme solarized " desert, slate, peachpuff, etc.
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
nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gd :Gvdiffsplit<space>


" ==================== fzf ====================
"let g:fzf_layout = { 'down': '~70%' }
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

if executable('rg')
    set grepprg=rg\ --color=never
    let $FZF_DEFAULT_COMMAND='rg --files -g "" --hidden'
elseif executable('ag')
    set grepprg=ag\ --nocolor
    let $FZF_DEFAULT_COMMAND='ag -g "" --hidden'
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
  packadd termdebug  " ensure gdb >= 7.12

  " For widescreen code viewing
  let g:termdebug_wide=1

  " Add mapping to load termdebug
  noremap <silent> <leader>td :Termdebug<CR>
endif
