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


##### Environment variables
set -Ux TERM "xterm-256color"


##### Aliases
alias tmux="tmux -2"
alias rmi="rm -i"


##### JAVA config
if test -d /usr/lib/jvm/java-8-openjdk-amd64/bin
    set JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
    set PATH $JAVA_HOME/bin $PATH
end


#### pyenv config
if set -q PYENV_ROOT; and test -d $PYENV_ROOT; and test -d $PYENV_ROOT/plugins/pyenv-virtualenv
    status is-login; and pyenv init --path | source
    pyenv init - | source
    status --is-interactive; and pyenv virtualenv-init - | source
end


#### NPM config
if test -d $HOME/.npm-packages
    set NPM_PACKAGES $HOME/.npm-packages
    set PATH $NPM_PACKAGES/bin $PATH
end



#### DEVKIT Pro (3DS Homebrew)
if test -d /opt/devkitpro
    set DEVKITPRO /opt/devkitpro
    set DEVKITARM $DEVKITPRO/devkitARM
    set PATH $DEVKITARM/bin $PATH
end


#### CLOUDSDK config
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/matt/Apps/google-cloud-sdk/path.fish.inc' ]; . '/home/matt/Apps/google-cloud-sdk/path.fish.inc'; end

#### CONDA config
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -d /home/matt/anaconda3/bin
    eval /home/matt/anaconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<
