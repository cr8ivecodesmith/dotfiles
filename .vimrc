" ##### GENERAL SETTINGS
syntax on
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
set listchars=eol:¶,tab:——,trail:·,extends:>,precedes:<,nbsp:%
set list

" Backups and swap management
set backup
set backupdir=~/sys/tmp
set dir=~/sys/tmp

" Switch ESC with `jj`
inoremap jj <ESC>

" ##### END GENERAL SETTINGS

" ##### LEADER SHORTCUTS SETTINGS
" Set leader key to `,`
let mapleader = ","

" Save the file as sudo then reload it manually with `:edit!`
noremap <Leader>W :silent w !sudo tee % > /dev/null

" Clear the last search highlights
noremap <Leader>c :noh

" Reload vimrc
noremap <Leader>R :so ~/.vimrc

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
set statusline=%F%m%r%h%w\ [format:%{&ff}]\ [source:%Y]\ [ascii:\%03.3b]\ [hex:\%02.2B]\ [pos:%04l,%04v][%p%%]\ [len:%L]
set laststatus=2
" ##### END STATUS LINE SETTINGS

