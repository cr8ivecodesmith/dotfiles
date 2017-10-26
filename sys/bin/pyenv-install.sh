#!/bin/bash

# pyenv and pyenv-virtualenv installer for bash
# for Ubuntu-based systems
#
# Author: Matt Lebrun (matt@lebrun.org)

echo "-> Installing python build requirements"
sudo apt-get install -y \
    libreadline-gplv2-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev

echo "-> Installing pyenv"
git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv

echo "-> Installing pyenv-virtualenv"
git clone https://github.com/pyenv/pyenv-virtualenv.git $HOME/.pyenv/plugins/pyenv-virtualenv

echo """
##### NEXT STEPS
Add the ff. variables in your config.fish file:

# Set PATH variables
export PYENV_ROOT=\"\$HOME/.pyenv\"
export PATH=\"\$PYENV_ROOT/bin:\$PATH\"

# Enable pyenv autocompletion
if command -v pyenv 1>/dev/null 2>&1;then
    eval \"\$(pyenv init -)\"

    # Enable auto activation of pyenv virtualenvs
    eval \"\$(pyenv virtualenv-init -)\"
fi

References:
https://github.com/pyenv/pyenv
https://github.com/pyenv/pyenv-virtualenv

#####
"""

echo "-> Done"
