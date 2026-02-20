# Personal aliases and functions

# System
alias tmux="tmux -2"
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias q='exit'
alias c='clear'
alias mosh='mosh --server "mosh-server new -s -l LANG=en_US.UTF-8"'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Largest Files
alias largefile='du -h -x -s -- * | sort -r -h | head -20'

# System Info
alias du='du -h'
alias df='df -h'
alias psu='ps aux'
alias psg='ps aux | grep -i'
alias kill9='kill -9'
alias myip='curl ifconfig.me'
alias speedtest='curl -s https://raw.githubusercontent.com/noreplyui5/speedtest-cli/master/speedtest.py | python'

# Magick
alias listfont="convert -list font | grep -iE 'font:.*'"

# Git
alias gts="git status"
alias gtf="git fetch"
alias gtpl="git pull"
alias gtps="git push"

# fzf
alias preview='fzf --preview "bat --color=always --style=numbers --theme OneHalfDark {}" --preview-window=down'
alias fnvim='nvim $(fzf -m --preview "bat --color=always --style=numbers --theme OneHalfDark {}" --preview-window=down)'
alias fvim='vim $(fzf -m --preview "bat --color=always --style=numbers --theme OneHalfDark {}" --preview-window=down)'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    
    # Use eza if available, otherwise fallback to ls
    if command -v eza &> /dev/null; then
        alias ls='eza --icons'
        alias la='eza --icons -lgha --group-directories-first'
        alias ll='eza --icons -lgh --group-directories-first'
        alias l='eza --icons'
        alias lt='eza --icons --tree'
        alias lta='eza --icons --tree -lgha'
    else
        alias ls='ls --color=auto'
        alias ll='ls -alFh'
        alias la='ls -Ah'
        alias l='ls -CFh'
    fi
    
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Use bat/batcat if available
if command -v batcat &> /dev/null; then
    alias bat='batcat --theme OneHalfDark'
    alias cat='batcat --theme OneHalfDark -p'
elif command -v bat &> /dev/null; then
    alias bat='bat --theme OneHalfDark'
    alias cat='bat --theme OneHalfDark -p'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# Functions

# Copy + go
cpg() {
    if [ -d "$2" ]; then
        cp "$1" "$2" && cd "$2"
    else
        cp "$1" "$2"
    fi
}

# Move + go
mvg() {
    if [ -d "$2" ]; then
        mv "$1" "$2" && cd "$2"
    else
        mv "$1" "$2"
    fi
}

# Mkdir + go
mkdirg() {
    mkdir -p "$1" && cd "$1"
}

# Extract archives with progress
extract() {
    for archive in "$@"; do
        if [ ! -f "$archive" ]; then
            echo "Error: '$archive' does not exist!"
            continue
        fi
        
        local total_size=$(stat -c '%s' "$archive" 2>/dev/null)
        
        case "$archive" in
            *.tar.gz|*.tgz)
                pv -s "$total_size" "$archive" | tar xzf -
                ;;
            *.tar.xz)
                pv -s "$total_size" "$archive" | tar xJf -
                ;;
            *.tar.bz2|*.tbz2)
                pv -s "$total_size" "$archive" | tar xjf -
                ;;
            *.tar)
                pv -s "$total_size" "$archive" | tar xf -
                ;;
            *.bz2)
                pv -s "$total_size" "$archive" | bunzip2 > "${archive%.bz2}"
                ;;
            *.gz)
                pv -s "$total_size" "$archive" | gunzip > "${archive%.gz}"
                ;;
            *.7z)
                pv -s "$total_size" "$archive" | 7z x -si -y > /dev/null
                ;;
            *.rar)
                pv -s "$total_size" "$archive" | unrar x -
                ;;
            *.zip)
                unzip "$archive"
                ;;
            *.Z)
                pv -s "$total_size" "$archive" | uncompress -
                ;;
            *)
                echo "Unsupported archive format: $archive"
                ;;
        esac
    done
}

# Search text in files
ftext() {
    grep -iIHrn --color=always "$1" . | less -r
}

# Interactive process killer with fzf
fkill() {
    local tmpfile=$(mktemp)
    
    ps -eo user,pid,cmd --sort=-%mem \
        | sed 1d \
        | fzf --multi --reverse \
              --header=" Select processes to kill (Tab to mark, Enter to kill)" \
              --preview 'ps -p {2} -o pid,user,%cpu,%mem,cmd' \
              --bind 'ctrl-s:toggle-sort' > "$tmpfile"
    
    if [ ! -s "$tmpfile" ]; then
        echo "No processes selected." >&2
        rm -f "$tmpfile"
        return 1
    fi
    
    while IFS= read -r line; do
        local pid=$(echo "$line" | awk '{print $2}')
        if [ -n "$pid" ]; then
            echo "Killing PID $pid…" >&2
            if kill -TERM "$pid" 2>/dev/null; then
                echo "Sent SIGTERM to $pid" >&2
            else
                echo "SIGTERM failed for $pid, sending SIGKILL…" >&2
                if kill -KILL "$pid" 2>/dev/null; then
                    echo "Sent SIGKILL to $pid" >&2
                else
                    echo "Failed to kill $pid" >&2
                fi
            fi
        fi
    done < "$tmpfile"
    rm -f "$tmpfile"
}
