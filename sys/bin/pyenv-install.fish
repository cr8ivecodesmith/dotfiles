# pyenv and pyenv-virtualenv installer for fishshell
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
set PYENV_ROOT \$HOME/.pyenv
set PATH \$PYENV_ROOT/bin \$PATH

# Enable pyenv autocompletion
if type -q pyenv
    status --is-interactive; and source (pyenv init -|psub)

    # Enable auto activation of pyenv virtualenvs
    status --is-interactive; and source (pyenv virtualenv-init -|psub)
end

References:
https://github.com/pyenv/pyenv
https://github.com/pyenv/pyenv-virtualenv

#####
"""

echo "-> Done"
