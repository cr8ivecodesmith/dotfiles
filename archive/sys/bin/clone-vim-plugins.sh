#!/bin/bash

BUNDLE_DIR=~/.vim/bundle

git clone https://github.com/tpope/vim-fugitive.git \
    ${BUNDLE_DIR}/vim-fugitive
git clone https://github.com/honza/dockerfile.vim.git \
    ${BUNDLE_DIR}/dockerfile-vim
git clone https://github.com/chrisbra/csv.vim.git \
    ${BUNDLE_DIR}/csv-vim
git clone https://github.com/leafgarland/typescript-vim.git \
    ${BUNDLE_DIR}/typescript-vim
git clone https://github.com/edkolev/promptline.vim.git \
    ${BUNDLE_DIR}/promptline-vim
git clone https://github.com/edkolev/tmuxline.vim.git \
    ${BUNDLE_DIR}/tmuxline-vim
git clone https://github.com/vim-airline/vim-airline \
    ${BUNDLE_DIR}/vim-airline
git clone https://github.com/airblade/vim-gitgutter.git \
    ${BUNDLE_DIR}/vim-gitgutter
git clone https://github.com/ctrlpvim/ctrlp.vim.git \
    ${BUNDLE_DIR}/ctrlp-vim
git clone https://github.com/davidhalter/jedi-vim.git \
    ${BUNDLE_DIR}/jedi-vim
git clone https://github.com/ervandew/supertab.git \
    ${BUNDLE_DIR}/supertab
git clone https://github.com/nathanaelkane/vim-indent-guides.git \
    ${BUNDLE_DIR}/vim-indent-guides

##########################
##### NEOVIM PLUGINS #####
##########################
NEOVIM_PLUGINS_DIR=~/.config/nvim
if command -v nvim 1>/dev/null 2>&1;then
    git clone --recursive https://github.com/Shougo/deoplete.nvim.git \
        ${NEOVIM_PLUGINS_DIR}/deoplete.nvim
    git clone --recursive https://github.com/zchee/deoplete-jedi.git \
        ${NEOVIM_PLUGINS_DIR}/deoplete-jedi
fi
