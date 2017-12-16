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

" Switch ESC with `jk`
inoremap jk <ESC>

" Saving and restoring views
" autocmd BufLeave *.* mkview
" autocmd BufEnter *.* silent loadview

" ##### END GENERAL SETTINGS


" ##### BACKUP AND SWAP SETTINGS
let g:_backup_home = $HOME . "/sys/src/backups/"
let g:_swap_home = $HOME . "/sys/src/swap/"

if !isdirectory(g:_backup_home)
    call mkdir(g:_backup_home, "p")
endif

if !isdirectory(g:_swap_home)
    call mkdir(g:_swap_home, "p")
endif

fun WriteBackup()
    " Write a backup file per day, per minute
    " following the file directory structure
    let g:_script_path = expand("%:p:h")
    let g:_backup_path = g:_backup_home . g:_script_path
    if !isdirectory(g:_backup_path)
        call mkdir(g:_backup_path, "p")
    endif
    let &bdir = g:_backup_path
    let &bex = "-" . strftime("%Y%m%d%H%M")

endfun

fun WriteSwap()
    " Write a swap file
    " following the file directory structure
    let g:_script_path = expand("%:p:h")
    let g:_swap_path = g:_swap_home . g:_script_path
    if !isdirectory(g:_swap_path)
        call mkdir(g:_swap_path, "p")
    endif
    let &dir = g:_swap_path
endfun

" Enable backup and swap
set backup
set writebackup
set swapfile

" Hook commands to the the pre-write event for all files
au BufWritePre * call WriteBackup()
au BufWritePre * call WriteSwap()

" ##### END BACKUP AND SWAP SETTINGS


" ##### UTILITY SETTINGS
" Install vim-plug to get this working
" https://github.com/junegunn/vim-plug
if !empty(glob(expand("~/.local/share/nvim/site/autoload")))
    call plug#begin()
        Plug 'tpope/vim-fugitive'
        Plug 'honza/dockerfile.vim'
        Plug 'leafgarland/typescript-vim'
        Plug 'edkolev/promptline.vim'
        Plug 'edkolev/tmuxline.vim'
        Plug 'vim-airline/vim-airline'
        Plug 'airblade/vim-gitgutter'
        Plug 'ctrlpvim/ctrlp.vim'
        Plug 'davidhalter/jedi-vim'
        Plug 'ervandew/supertab'
        Plug 'Shougo/deoplete.nvim'
        Plug 'zchee/deoplete-jedi'
    call plug#end()
endif

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
noremap <Leader>c :noh<CR>

" Redraw the screen
noremap <Leader>rr :redraw!<CR>:redrawstatus!<CR>

" Set background to light or dark
noremap <Leader>bd :set background=dark<CR>
noremap <Leader>bl :set background=light<CR>

" Fold method shortcuts
noremap <Leader>fi :set foldmethod=indent<CR>
noremap <Leader>fs :set foldmethod=syntax<CR>
noremap <Leader>fm :set foldmethod=manual<CR>
noremap <Leader>fc :set foldmethod=manual<CR>zE


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

nnoremap tL :tabmove +1<CR>
nnoremap tH :tabmove -1<CR>
" ##### END TAB NAVIGATION

" ##### STATUS LINE SETTINGS
" set statusline=%F%m%r%h%w\ [eol:%{&ff}][enc:%{&encoding}][src:%Y]\ [ascii:\%03.3b][hex:\%02.2B]\ [x:%04v,y:%04l][%p%%][len:%L]
set laststatus=2
" ##### END STATUS LINE SETTINGS

" ##### VIM THEME SETTINGS
" Sets gui font as suggested in: http://stackoverflow.com/questions/3316244/set-gvim-font-in-vimrc-file
" set t_Co=16
" set background=light
" ##### END VIM THEME SETTINGS

" ##### POWERLINE FONTS SETTINGS
if !empty(glob(expand("~/.config/nvim/plugged/vim-airline")))
    let g:airline_powerline_fonts = 1
endif
" ##### END POWERLINE FONTS SETTINGS

" ##### CTRLP PLUGIN SETTINGS
if !empty(glob(expand("~/.config/nvim/plugged/ctrlp.vim")))
    " Set keymapping
    let g:ctrlp_map = '<c-p>'
    let g:ctrlp_cmd = 'CtrlP'

    " Configure ignored files
    set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pid,__pycache__
    let g:ctrlp_custom_ignore = {
        \ 'dir':  '\v[\/]\.(git|hg|svn)$',
        \ 'file': '\v\.(exe|so|dll)$',
        \ }

    " Ignore files in .gitignore
    " let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
endif
" ##### END CTRLP PLUGIN SETTINGS

" ##### PROMPTLINE PLUGIN SETTINGS
if !empty(glob(expand("~/.config/nvim/plugged/promptline.vim")))
    let g:promptline_preset = {
        \'a': [ promptline#slices#host() ],
        \'b': [ promptline#slices#user() ],
        \'c': [ promptline#slices#cwd() ],
        \'y': [ promptline#slices#python_virtualenv() ],
        \'z': [ promptline#slices#vcs_branch() ],
        \'warn': [ promptline#slices#last_exit_code() ]}

    if !empty(glob(expand("~/.config/nvim/plugged/vim-airline")))
        let g:promptline_theme = 'airline'
    endif
endif
" ##### END PROMPTLINE PLUGIN SETTINGS

" ##### DEOPLETE PLUGIN SETTINGS
if !empty(glob(expand("~/.config/nvim/plugged/deoplete.vim")))
    let g:deoplete#enable_at_startup = 1
endif
if !empty(glob(expand("~/.config/nvim/plugged/deoplete-jedi")))
    let g:deoplete#sources#jedi#show_docstring = 1
endif
" ##### END DEOPLETE PLUGIN SETTINGS

" ##### JEDI PLUGIN SETTINGS
if !empty(glob(expand("~/.config/nvim/plugged/jedi-vim")))
    let g:jedi#completions_enabled = 0
endif
" ##### END JEDI PLUGIN SETTINGS
