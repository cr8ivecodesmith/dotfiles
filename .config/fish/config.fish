# Load promptline configuration
function fish_prompt
  env FISH_VERSION=$FISH_VERSION PROMPTLINE_LAST_EXIT_CODE=$status bash ~/.promptline.sh left
end

function fish_right_prompt
  env FISH_VERSION=$FISH_VERSION PROMPTLINE_LAST_EXIT_CODE=$status bash ~/.promptline.sh right
end


function fish_greeting
    if type -q fortune
        fortune
    else
        ""
    end
end

#### pyenv config

# Set PATH variables
set PYENV_ROOT $HOME/.pyenv
set PATH $PYENV_ROOT/bin $PATH

# Enable pyenv autocompletion
if type -q pyenv
    status --is-interactive; and source (pyenv init -|psub)

    # Enable auto activation of pyenv virtualenvs
    status --is-interactive; and source (pyenv virtualenv-init -|psub)
end


#### NPM config
set NPM_PACKAGES $HOME/.npm-packages
set PATH $NPM_PACKAGES/bin $PATH
