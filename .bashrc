# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
# HISTFILESIZE=10000
HISTFILE=$HOME/.bash_history

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Enable color prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Function to get distro icon
__distro_icon() {
    local id="unknown"
    if [ -r /etc/os-release ]; then
        id=$(grep '^ID=' /etc/os-release | head -n1 | sed 's/^ID=//' | tr -d '"')
    fi
    
    case "$id" in
        kali|ubuntu)
            echo ""
            ;;
        arch)
            echo ""
            ;;
        debian)
            echo ""
            ;;
        fedora)
            echo ""
            ;;
        alpine)
            echo ""
            ;;
        void)
            echo ""
            ;;
        opensuse*|sles)
            echo ""
            ;;
        gentoo)
            echo ""
            ;;
        nixos)
            echo ""
            ;;
        pop)
            echo ""
            ;;
        *)
            echo ""
            ;;
    esac
}

# Function to get virtualenv name
__venv_name() {
    if [ -n "$CONDA_DEFAULT_ENV" ]; then
        echo "($CONDA_DEFAULT_ENV)"
        return 0
    elif [ -n "$VIRTUAL_ENV" ]; then
        local venv_dir=$(basename "$VIRTUAL_ENV")
        local name=""
        
        # Respect explicit prompt if present
        if [ -n "$VIRTUAL_ENV_PROMPT" ]; then
            name="$VIRTUAL_ENV_PROMPT"
        # If the venv directory is a generic name, use the project folder
        elif [[ "$venv_dir" =~ ^(env|venv|\.env|\.venv)$ ]]; then
            local parent=$(basename $(dirname "$VIRTUAL_ENV"))
            # If venvs are centralized, fall back to CWD name
            if [[ "$parent" =~ ^(\.venvs|venvs|virtualenvs|\.virtualenvs)$ ]]; then
                parent=$(basename "$(pwd)")
            fi
            name="$parent"
        else
            name="$venv_dir"
        fi
        
        echo '' "($name)"
        return 0
    fi
    return 1
}

# Function to shorten path (similar to fish's prompt_pwd)
__prompt_pwd() {
    local dir="${PWD/#$HOME/\~}"
    
    # If we're in home directory, just show ~
    if [ "$dir" = "~" ]; then
        echo "~"
        return
    fi
    
    # Split path into array
    IFS='/' read -ra parts <<< "$dir"
    local result=""
    local last_index=$((${#parts[@]} - 1))
    
    for i in "${!parts[@]}"; do
        if [ $i -eq 0 ]; then
            # First element (empty for absolute paths, or ~ for home)
            if [ "${parts[$i]}" = "~" ]; then
                result="~"
            fi
        elif [ $i -eq $last_index ]; then
            # Last element - show full name
            if [ -n "$result" ]; then
                result="$result/${parts[$i]}"
            else
                result="/${parts[$i]}"
            fi
        else
            # Middle elements - abbreviate to first letter
            local first_char="${parts[$i]:0:1}"
            if [ -n "$result" ]; then
                result="$result/$first_char"
            else
                result="/$first_char"
            fi
        fi
    done
    
    echo "$result"
}

# Custom two-line prompt matching fish
if [ "$color_prompt" = yes ]; then
    # Colors (not local, used in PS1)
    Blue='\[\033[01;34m\]'
    Yellow='\[\033[01;33m\]'
    Orange='\[\033[38;5;215m\]'
    Green='\[\033[01;32m\]'
    Reset='\[\033[0m\]'
    Bold='\[\033[1m\]'
    
    # Line 1: [icon cwd] (venv) (git)
    PS1='${debian_chroot:+($debian_chroot)}'
    PS1+="${Blue}[${Green}\$(\__distro_icon) ${Yellow}\$(\__prompt_pwd)${Blue}]${Reset} "
    PS1+="${Blue}\$(\__venv_name)${Reset} "
    
    # Git status - check if we're in a git repo
    if command -v git &> /dev/null; then
        PS1+="${Blue}\$(git rev-parse --git-dir &>/dev/null && echo -n \" (\$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD 2>/dev/null))\" || echo \"\")${Reset} "
    fi
    
    # Line 2: ❯ (Green in bash, Orange in fish)
    PS1+="\n${Bold}${Green}❯${Reset} "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi

  # enable git completion if it exists
  if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
  fi
  if [ -f ~/.git-prompt.sh ]; then
    source ~/.git-prompt.sh
  fi

fi


# Bash color definitions
# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.

# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset

ALERT=${BWhite}${On_Red} # Bold White on red background

# Load SSH Keys
if [ -f ~/sys/bin/load_ssh_identities ]; then
    source ~/sys/bin/load_ssh_identities
fi


##### Update PATH
# Define the paths you want to append
paths_to_append=("/usr/sbin" "/sbin")

# Loop over each path
for path in "${paths_to_append[@]}"
do
    # Check if the PATH already contains the current path
    if [[ ! $PATH =~ (^|:)$path(:|$) ]]; then
        # If not, append the path to the PATH variable
        export PATH=$PATH:$path
    fi
done

# Define the paths you want to prepend
paths_to_prepend=("$HOME/.local/bin" "$HOME/.cargo/bin")

# Loop over each path
for path in "${paths_to_prepend[@]}"
do
    # Check if the PATH already contains the current path
    if [[ ! $PATH =~ (^|:)$path(:|$) ]]; then
        # If not, prepend the path to the PATH variable
        export PATH=$path:$PATH
    fi
done


##### Google Cloud SDK config

# New auth plugin for gcloud as of kube V1.26
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# Silence direnv loading messages (if direnv is used)
export DIRENV_LOG_FORMAT=""

# Turn off Python/virtualenv prompt modifications (we handle it in our custom prompt)
export VIRTUAL_ENV_DISABLE_PROMPT=1


#### NPM config
if [ -d $HOME/.npm-packages/bin ]; then
    export NPM_PACKAGES="$HOME/.npm-packages"
    export PATH="$NPM_PACKAGES/bin:$PATH"
fi


#### NVM config
if [ -d $HOME/.nvm ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
