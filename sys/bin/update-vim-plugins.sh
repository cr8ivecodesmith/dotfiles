#!/bin/bash

BUNDLE_DIR=~/.vim/bundle

cd ${BUNDLE_DIR}/vim-fugitive && git pull origin master
cd ${BUNDLE_DIR}/dockerfile-vim && git pull origin master
cd ${BUNDLE_DIR}/csv-vim && git pull origin master
cd ${BUNDLE_DIR}/typescript-vim && git pull origin master
cd ${BUNDLE_DIR}/promptline-vim && git pull origin master
cd ${BUNDLE_DIR}/vim-airline && git pull origin master
cd ${BUNDLE_DIR}/vim-gitgutter && git pull origin master
cd ${BUNDLE_DIR}/ctrlp-vim && git pull origin master
cd ${BUNDLE_DIR}/jedi-vim && git pull origin master
cd ${BUNDLE_DIR}/supertab && git pull origin master
cd ${BUNDLE_DIR}/vim-indent-guides && git pull origin master
