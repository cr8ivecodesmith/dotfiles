function fish_greeting
    if type -q fortune
        set r (random)
        if test (math "$r % 3") -eq 0
            if fortune -v 2>&1 | grep -q "fortune-mod"
                fortune -as
            else
                fortune
            end
        end
    end
end


function __distro_icon
    set -l id unknown
    if test -r /etc/os-release
        set id (string replace -r '^ID=' '' (grep '^ID=' /etc/os-release | head -n1) | tr -d '"')
    end

    switch $id
        case kali ubuntu
            echo ""
        case arch
            echo ""
        case debian
            echo ""
        case fedora
            echo ""
        case alpine
            echo ""
        case void
            echo ""
        case 'opensuse*' sles
            echo ""
        case gentoo
            echo ""
        case nixos
            echo ""
        case '*'
            echo ""
    end
end


function __user_name
    echo (whoami)
end


function __venv_name1 --description 'Print active venv/conda env name'
    if set -q CONDA_DEFAULT_ENV
        echo '' "($CONDA_DEFAULT_ENV)"
        return 0
    else if set -q VIRTUAL_ENV
        if set -q VIRTUAL_ENV_PROMPT
            echo '' "($VIRTUAL_ENV_PROMPT)"
        else
            echo '' "("(path basename "$VIRTUAL_ENV")")"
        end
        return 0
    end
    return 1
end


function __venv_name --description 'Print active venv/conda env name'
    if set -q CONDA_DEFAULT_ENV
        echo "($CONDA_DEFAULT_ENV)"
        return 0
    else if set -q VIRTUAL_ENV
        set -l venv_dir (path basename "$VIRTUAL_ENV")
        set -l name ""

        # Respect explicit prompt if present (uv/venv can set this)
        if set -q VIRTUAL_ENV_PROMPT
            set name "$VIRTUAL_ENV_PROMPT"
        # If the venv directory is a generic name, use the project folder
        else if contains -- $venv_dir env venv .env .venv
            set -l parent (path basename (path dirname "$VIRTUAL_ENV"))
            # If venvs are centralized (e.g. ~/.venvs/...), fall back to CWD name
            if contains -- $parent .venvs venvs virtualenvs .virtualenvs
                set parent (path basename (pwd))
            end
            set name "$parent"
        else
            # Otherwise use the venv directory name itself
            set name "$venv_dir"
        end

        echo '' "($name)"
        return 0
    end
    return 1
end


function fish_prompt
    set -l green (set_color -o green)
    set -l blue  (set_color -o blue)
    set -l cyan  (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l orange (set_color 'FFB347')
    set -l bold  (set_color -o)
    set -l reset (set_color normal)

    set -l uname  (__user_name)
    set -l host   (hostname -s)
    set -l icon   (__distro_icon)
    set -l cwd    (prompt_pwd)

    set -l vcs  ''(fish_vcs_prompt)
    set -l ven  (__venv_name)

    # Line 1: ╭─[ user ICON host ] [ cwd ] *venv* *vcs*
    #echo -n $bold$orange'╭─'$blue'['$cyan$uname $orange$icon $cyan$host$blue']'$reset' '
    #echo -n $blue'['$yellow$cwd$blue']'$reset' '
    echo -n $blue'['$orange$icon' '$yellow$cwd$blue']'$reset' '
    echo -n $blue$ven $reset
    echo -n $blue$vcs $reset

    # Line 2: ╰─❯ 
    echo $reset' '
    #echo -n $bold$orange'╰─❯ '$reset
    echo -n $bold$orange'❯ '$reset
end


##### Environment variables
set -Ux TERM "xterm-256color"

# Turn off Python/uv prompt tweaks
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx CONDA_CHANGEPS1 no

# Silence direnv loading messages
set -gx DIRENV_LOG_FORMAT ""


##### Update PATH
# Define the paths you want to append
set paths_to_append /usr/sbin /sbin

# Loop over each path
for path in $paths_to_append
    # Check if path exists and if the PATH already contains the current path
    if test -d $path; and not contains $path $PATH
        # If not, append the path to the PATH variable
        set -gx PATH $PATH $path
    end
end

set paths_to_prepend /opt/matt/llama.cpp/build/bin

# Loop over each path
for path in $paths_to_prepend
    # Check if path exists and if the PATH already contains the current path
    if test -d $path; and not contains $path $PATH
        # If not, prepend the path to the PATH variable
        set -gx PATH $path $PATH
    end
end


##### JAVA config
if test -d /usr/lib/jvm/java-8-openjdk-amd64/bin
    set JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
    set PATH $JAVA_HOME/bin $PATH
end


#### pyenv config
#if test -d $HOME/.pyenv/bin; and test -d $HOME/.pyenv/plugins/pyenv-virtualenv
#    # Enable pyenv autocompletion
#    if type -q pyenv
#        status --is-interactive; and source (pyenv init -|psub)
#
#        # Enable auto activation of pyenv virtualenvs
#        status --is-interactive; and source (pyenv virtualenv-init -|psub)
#    end
#end


#### Local pip
if test -d $HOME/.local/bin
    set PATH $HOME/.local/bin $PATH 
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
# Consider using docker context instead
if ps aux | grep -P "qemu-system-x86_64.+2375" | grep -v grep > /dev/null
    set -gx DOCKER_HOST tcp://127.0.0.1:2375
end


#### Codex CLI Env
if test -d $HOME/.codex-cli-env/bin
    set PATH $HOME/.codex-cli-env/bin $PATH
    source $HOME/.codex-cli-env/shell/codexenv.fish
end


#### CONDA config
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# if test -d /home/matt/anaconda3/bin
#     eval /home/matt/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# end
# <<< conda initialize <<<
