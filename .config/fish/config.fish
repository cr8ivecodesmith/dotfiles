# Load promptline configuration
function fish_prompt
  env FISH_VERSION=$FISH_VERSION PROMPTLINE_LAST_EXIT_CODE=$status bash ~/.promptline.sh left
end

function fish_right_prompt
  env FISH_VERSION=$FISH_VERSION PROMPTLINE_LAST_EXIT_CODE=$status bash ~/.promptline.sh right
end


function fish_greeting
    if type -q fortune
        if fortune -v 2>&1 | grep -q "fortune-mod"
            fortune -as
        else
            fortune
        end
    else
        echo ""
    end
end


##### Environment variables
set -Ux TERM "xterm-256color"


##### Aliases
alias tmux="tmux -2"
alias rm="rm -i"
alias cp='cp -i'
alias mv='mv -i'
alias mosh='mosh --server "mosh-server new -s -l LANG=en_US.UTF-8"'
alias mkdir='mkdir -p'
alias gits="git status"
alias gitf="git fetch"
alias gitpl="git pull"
alias gitps="git push"


##### Update PATH
# Define the paths you want to append
set paths_to_append /usr/sbin /sbin

# Loop over each path
for path in $paths_to_append
    # Check if the PATH already contains the current path
    if not contains $path $PATH
        # If not, append the path to the PATH variable
        set -gx PATH $PATH $path
    end
end


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


#### Local pip
if test -d $HOME/.local/bin
    set PATH $PATH $HOME/.local/bin
end


#### NPM and NVM config
if test -d $HOME/.npm-packages
    set NPM_PACKAGES $HOME/.npm-packages
    set PATH $NPM_PACKAGES/bin $PATH
end

if test -d $HOME/.nvm
    set NVM_DIR $HOME/.nvm
end


#### Rust binaries
if test -d $HOME/.cargo/bin
    set PATH $HOME/.cargo/bin $PATH
end


#### DEVKIT Pro (3DS Homebrew)
if test -d /opt/devkitpro
    set DEVKITPRO /opt/devkitpro
    set DEVKITARM $DEVKITPRO/devkitARM
    set PATH $DEVKITARM/bin $PATH
end


#### NGAGESDK
if test -d $HOME/projects/oss/ngage-toolchain
    set NGAGESDK $HOME/projects/oss/ngage-toolchain
end


#### CLOUDSDK config
# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/home/matt/Apps/google-cloud-sdk/path.fish.inc' ]; . '/home/matt/Apps/google-cloud-sdk/path.fish.inc'; end

# New auth plugin for gcloud as of kube V1.26
set USE_GKE_GCLOUD_AUTH_PLUGIN True


#### Docker Daemon on Android
if ps aux | grep -P "qemu-system-x86_64.+2375" | grep -v grep > /dev/null
    set -gx DOCKER_HOST tcp://127.0.0.1:2375
end


#### CONDA config
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# if test -d /home/matt/anaconda3/bin
#     eval /home/matt/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# end
# <<< conda initialize <<<
