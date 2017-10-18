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
git clone https://github.com/vim-airline/vim-airline \
    ${BUNDLE_DIR}/vim-airline
git clone https://github.com/airblade/vim-gitgutter.git \
    ${BUNDLE_DIR}/vim-gitgutter
git clone https://github.com/ctrlpvim/ctrlp.vim.git \
    ${BUNDLE_DIR}/ctrlp-vim
