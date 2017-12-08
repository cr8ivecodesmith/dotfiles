#!/bin/bash

SCRIPT=$(basename $0)
SCRIPT_NAME="${SCRIPT%.*}"
SCRIPT_PATH=$(readlink -f $0)
SCRIPT_DIR=$(dirname $SCRIPT_PATH)
PID=$$

PROJECT_DIR=$(dirname $(dirname $SCRIPT_DIR))
PROJECT_NAME=$(basename $PROJECT_DIR)


function make_link() {
    target=$1
    replacement=$2

    if [ -f $target ];then
        rm -rf $target
        echo "--> Link target removed: $target"
    fi

    ln -s $replacement $target
    echo "--> Link created: $replacement -> $target"
}


echo "-> Configuring $PROJECT_NAME"
echo "-> PROJECT_DIR: $PROJECT_DIR"


#mkdir -p $HOME/sys/tmp
#target=$HOME/sys/bin
#replacement=$PROJECT_DIR/sys/bin
#make_link $target $replacement

echo "-> Installing pyenv"
if [ -f $HOME/.pyenv ];then
    rm -rf $HOME/.pyenv
fi
git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git $HOME/.pyenv/plugins/pyenv-virtualenv

mkdir -p $HOME/.npm-packages/bin
target=$HOME/.npmrc
replacement=$PROJECT_DIR/.npmrc
make_link $target $replacement

target=$HOME/.gitconfig
replacement=$PROJECT_DIR/.gitconfig
make_link $target $replacement

target=$HOME/.hgrc
replacement=$PROJECT_DIR/.hgrc
make_link $target $replacement

target=$HOME/.tmux.conf
replacement=$PROJECT_DIR/.tmux.conf
make_link $target $replacement

target=$HOME/.promptline.sh
replacement=$PROJECT_DIR/.promptline.sh
make_link $target $replacement

target=$HOME/.tmuxline.sh
replacement=$PROJECT_DIR/.tmuxline.sh
make_link $target $replacement

target=$HOME/.dircolors
replacement=$PROJECT_DIR/.dircolors
make_link $target $replacement

target=$HOME/.bashrc
replacement=$PROJECT_DIR/.bashrc
make_link $target $replacement

target=$HOME/.config/fish
replacement=$PROJECT_DIR/.config/fish
make_link $target $replacement

#target=$HOME/.config/nvim
#replacement=$PROJECT_DIR/.config/nvim
#make_link $target $replacement

#target=$HOME/.local/share/nvim
#replacement=$PROJECT_DIR/.local/share/nvim
#make_link $target $replacement

echo "-> Installing Docker Container Removal Service"
sudo cp $PROJECT_DIR/sys/bin/docker-remove-containers /usr/local/bin/
sudo cp $PROJECT_DIR/systemd/service/docker-remove-containers.service \
    /etc/systemd/service/
sudo systemctl daemon-reload
sudo systemctl enable docker-remove-containers

echo "-> End"
