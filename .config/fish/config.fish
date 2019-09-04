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
        echo ""
    end
end


##### JAVA config
if test -d /usr/lib/jvm/java-8-openjdk-amd64/bin
    set JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
    set PATH $JAVA_HOME/bin $PATH
end


#### pyenv config

# Set PATH variables
if test -d $HOME/.pyenv/bin; and test -d $HOME/.pyenv/plugins/pyenv-virtualenv
    set PYENV_ROOT $HOME/.pyenv
    set PATH $PYENV_ROOT/bin $PATH

    # Enable pyenv autocompletion
    if type -q pyenv
        status --is-interactive; and source (pyenv init -|psub)

        # Enable auto activation of pyenv virtualenvs
        status --is-interactive; and source (pyenv virtualenv-init -|psub)
    end
end


#### NPM config
if test -d $HOME/.npm-packages
    set NPM_PACKAGES $HOME/.npm-packages
    set PATH $NPM_PACKAGES/bin $PATH
end
