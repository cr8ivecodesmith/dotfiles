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
alias gits="git status"


##### JAVA config
if test -d /usr/lib/jvm/java-8-openjdk-amd64/bin
    set JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
    set PATH $JAVA_HOME/bin $PATH
end


#### pyenv config
if test -d $HOME/.pyenv/bin; and test -d $HOME/.pyenv/plugins/pyenv-virtualenv
    # I am unable to figure out a fix on the path issues I've experienced
    # since pyenv V2.0.0. The last version that worked for me with these
    # settings is V1.2.27. So to update my python version:
    # 1. Switch to master
    # 2. Install the desired version
    # 3. Switch back to tag 1.2.27

    # NOTE: No longer needed once you've set the variables
    # from the shell (i.e.):
    # set -Ux PYENV_ROOT $HOME/.pyenv
    # set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths

    # set PYENV_ROOT $HOME/.pyenv
    # set PATH $PYENV_ROOT/bin $PATH

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


#### DEVKIT Pro (3DS Homebrew)
if test -d /opt/devkitpro
    set DEVKITPRO /opt/devkitpro
    set DEVKITARM $DEVKITPRO/devkitARM
    set PATH $DEVKITARM/bin $PATH
end


#### CLOUDSDK config
# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/home/matt/Apps/google-cloud-sdk/path.fish.inc' ]; . '/home/matt/Apps/google-cloud-sdk/path.fish.inc'; end

#### CONDA config
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# if test -d /home/matt/anaconda3/bin
#     eval /home/matt/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# end
# <<< conda initialize <<<
