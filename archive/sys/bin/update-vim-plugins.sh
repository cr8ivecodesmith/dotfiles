#!/bin/bash

BUNDLE_DIR=~/.vim/bundle

cd ${BUNDLE_DIR}/vim-fugitive && git pull origin master
cd ${BUNDLE_DIR}/dockerfile-vim && git pull origin master
cd ${BUNDLE_DIR}/csv-vim && git pull origin master
cd ${BUNDLE_DIR}/typescript-vim && git pull origin master
cd ${BUNDLE_DIR}/promptline-vim && git pull origin master
cd ${BUNDLE_DIR}/tmuxline-vim && git pull origin master
cd ${BUNDLE_DIR}/vim-airline && git pull origin master
cd ${BUNDLE_DIR}/vim-gitgutter && git pull origin master
cd ${BUNDLE_DIR}/ctrlp-vim && git pull origin master
cd ${BUNDLE_DIR}/jedi-vim && git pull origin master
cd ${BUNDLE_DIR}/supertab && git pull origin master
cd ${BUNDLE_DIR}/vim-indent-guides && git pull origin master

##########################
##### NEOVIM PLUGINS #####
##########################
NEOVIM_PLUGINS_DIR=~/.config/nvim
if command -v nvim 1>/dev/null 2>&1;then
    cd ${NEOVIM_PLUGINS_DIR}/deoplete.nvim && git pull origin master && git submodule update --init
    cd ${NEOVIM_PLUGINS_DIR}/deoplete-jedi && git pull origin master && git submodule update --init
fi
