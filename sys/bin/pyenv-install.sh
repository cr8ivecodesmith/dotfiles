#!/bin/bash

# pyenv and pyenv-virtualenv installer for bash
#
# Author: Matt Lebrun (matt@lebrun.org)


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
