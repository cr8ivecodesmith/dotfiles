" ##### GENERAL SETTINGS
syntax on
filetype plugin indent on
set showmode
set number
set linebreak
set showbreak=+++
set textwidth=100
set showmatch
set visualbell
set hlsearch
set smartcase
set ignorecase
set incsearch
set autoindent
set expandtab
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4
set ruler
set undolevels=1000
set backspace=indent,eol,start
set cursorline
set colorcolumn=80,100
hi ColorColumn ctermbg=lightcyan guibg=lightcyan
set listchars=eol:¬,tab:——,trail:·,extends:>,precedes:<,nbsp:%
set list
set ff=unix
set ffs=unix,dos,mac

" Backups and swap management
if !isdirectory(expand("~/sys/tmp"))
    call mkdir(expand("~/sys/tmp"), "p")
endif
set backup
set backupdir=~/sys/tmp
set dir=~/sys/tmp

" Switch ESC with `jk`
inoremap jk <ESC>

" ##### END GENERAL SETTINGS

" ##### UTILITY SETTINGS
" Load pathogen and plugins if exists
if !empty(glob(expand("~/.vim/autoload"))) && !empty(glob(expand("~/.vim/bundle")))

    filetype off
    execute pathogen#infect()
    execute pathogen#helptags()

    syntax on
    filetype plugin indent on

endif

" Auto-reload of .vimrc
autocmd! bufwritepost ~/.vimrc source %

" Fix for pasting in insert mode
set pastetoggle=<F2>

" Map yanks to system clipboard
" set clipboard=unnamedplus

" Always switch to the current file's directory
autocmd BufEnter * silent! lcd %:p:h

" ##### END UTILITY SETTINGS

" ##### FILE-TYPES SETTINGS

" Kivy atlas file support
au BufNewFile,BufRead *.atlas set filetype=json

" Kivy kv file support
au BufNewFile,BufRead *.kv set filetype=yaml

" Kivy markdown support
au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.mdown set filetype=markdown

" Vagrantfile and Dockerfile support
au BufNewFile,BufRead Vagrantfile* set filetype=ruby

" ##### END FILE-TYPES SETTINGS

" ##### LEADER SHORTCUTS SETTINGS
" Set leader key to `,`
let mapleader = "\<space>"

" Save the file as sudo then reload it manually with `:edit!`
noremap <Leader>W :silent w !sudo tee % > /dev/null

" Clear the last search highlights
noremap <Leader>c :noh

" Reload vimrc
noremap <Leader>R :so ~/.vimrc

" Set background to light or dark
noremap <Leader>bd :set background=dark
noremap <Leader>bl :set background=light


" ##### END LEADER SHORTCUTS SETTINGS

" ##### SPLIT SCREEN NAVIGATION (CTRL+hjkl)
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-H> <C-W>h<C-W>_
map <C-L> <C-W>l<C-W>_
" ##### END SPLIT SCREEN NAVIGATION (CTRL+hjkl)

" ##### TAB NAVIGATION
nnoremap th :tabprev<CR>
nnoremap tl :tabnext<CR>
nnoremap tn :tabnew<CR>
nnoremap tt :tabedit<CR>
nnoremap td :tabclose<CR>
" ##### END TAB NAVIGATION

" ##### STATUS LINE SETTINGS
set statusline=%F%m%r%h%w\ [eol:%{&ff}][enc:%{&encoding}][src:%Y]\ [ascii:\%03.3b][hex:\%02.2B]\ [x:%04v,y:%04l][%p%%][len:%L]
set laststatus=2
" ##### END STATUS LINE SETTINGS

" ##### VIM THEME SETTINGS
" Sets gui font as suggested in: http://stackoverflow.com/questions/3316244/set-gvim-font-in-vimrc-file
set t_Co=16
set background=light
if has("gui_running")
    colorscheme solarized
    set background=light
    set guifont=Fixedsys\ Neo+:h14
endif
" ##### VIM GUI SETTINGS


" ##### CTRLP PLUGIN SETTINGS
if !empty(glob(expand("~/.vim/bundle/ctrlp-vim")))
    " Set keymapping
    let g:ctrlp_map = '<c-p>'
    let g:ctrlp_cmd = 'CtrlP'

    " Ignore files in .gitignore
    let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
endif
" ##### END CTRLP PLUGIN SETTINGS
