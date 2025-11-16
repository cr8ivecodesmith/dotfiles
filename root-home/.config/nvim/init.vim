" ################################
" ##### NEOVIM CONFIGURATION #####
" ################################

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
set colorcolumn=80
hi ColorColumn ctermbg=lightcyan guibg=lightcyan
set listchars=eol:¬,tab:——,trail:·,extends:>,precedes:<,nbsp:%
set list
set ff=unix
set ffs=unix,dos,mac

" Code folding defaults
set foldmethod=syntax
set foldlevelstart=1
let javaScript_fold=1
let xml_syntax_folding=1
let sh_fold_enabled=1

" Switch ESC with `jk`
inoremap jk <ESC>

" Saving and restoring views
" autocmd BufLeave *.* mkview
" autocmd BufEnter *.* silent loadview

" netrw customizations
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END

" ##### END GENERAL SETTINGS

" ##### UTILITY SETTINGS

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
noremap <Leader>w :silent w<CR>

" Clear the last search highlights
noremap <Leader>c :noh<CR>

" Redraw the screen
noremap <Leader>rr :redraw!<CR>:redrawstatus!<CR>

" Reload the buffer
noremap <Leader>rb :e<CR>

" Set background to light or dark
noremap <Leader>bd :set background=dark<CR>
noremap <Leader>bl :set background=light<CR>

" Fold method shortcuts
noremap <Leader>fi :set foldmethod=indent<CR>
noremap <Leader>fs :set foldmethod=syntax<CR>
noremap <Leader>fm :set foldmethod=manual<CR>
noremap <Leader>fc :set foldmethod=manual<CR>zE

" Netrw activation
noremap <Leader>t :Vex<CR>

" Show current directory
noremap <Leader>p :pwd<CR>

" Quit and save
noremap <Leader>x :x<CR>

" Quit
noremap <Leader>qq :q!<CR>


" ##### END LEADER SHORTCUTS SETTINGS

" ##### SPLIT SCREEN NAVIGATION (CTRL+hjkl)
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-H> <C-W>h<C-W>_
map <C-L> <C-W>l<C-W>_
" ##### END SPLIT SCREEN NAVIGATION (CTRL+hjkl)

" ##### TAB NAVIGATION
nnoremap th :tabprev<CR>:checktime<CR>
nnoremap tl :tabnext<CR>:checktime<CR>
nnoremap tn :tabnew<CR>
nnoremap tt :tabedit<CR>
nnoremap td :tabclose<CR>

nnoremap tL :tabmove +1<CR>
nnoremap tH :tabmove -1<CR>
" ##### END TAB NAVIGATION

" ##### STATUS LINE SETTINGS
" set statusline=%F%m%r%h%w\ [eol:%{&ff}][enc:%{&encoding}][src:%Y]\ [ascii:\%03.3b][hex:\%02.2B]\ [x:%04v,y:%04l][%p%%][len:%L]
set laststatus=2
" ##### END STATUS LINE SETTINGS
