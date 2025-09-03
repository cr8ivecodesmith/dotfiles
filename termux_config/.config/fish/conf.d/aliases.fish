# Extract archives with progress
function extract
    for archive in $argv
        if not test -f $archive
            echo "Error: '$archive' does not exist!"
            continue
        end
        set total_size (stat -c '%s' $archive ^/dev/null)

        switch $archive
            case '*.tar.gz' '*.tgz'
                pv -s $total_size $archive | tar xzf -
            case '*.tar.xz'
                pv -s $total_size $archive | tar xJf -
            case '*.tar.bz2' '*.tbz2'
                pv -s $total_size $archive | tar xjf -
            case '*.tar'
                pv -s $total_size $archive | tar xf -
            case '*.bz2'
                pv -s $total_size $archive | bunzip2 > (string replace -r '\.bz2$' '' $archive)
            case '*.gz'
                pv -s $total_size $archive | gunzip > (string replace -r '\.gz$' '' $archive)
            case '*.7z'
                pv -s $total_size $archive | 7z x -si -y > /dev/null
            case '*.rar'
                pv -s $total_size $archive | unrar x -
            case '*.zip'
                unzip $archive
            case '*.Z'
                pv -s $total_size $archive | uncompress -
            case '*'
                echo "Unsupported archive format: $archive"
        end
    end
end

# Search text in files
function ftext
    grep -iIHrn --color=always $argv[1] . | less -r
end

# Copy + go
function cpg
    if test -d $argv[2]
        cp $argv[1] $argv[2]; and cd $argv[2]
    else
        cp $argv[1] $argv[2]
    end
end

# Move + go
function mvg
    if test -d $argv[2]
        mv $argv[1] $argv[2]; and cd $argv[2]
    else
        mv $argv[1] $argv[2]
    end
end

# Mkdir + go
function mkdirg
    mkdir -p $argv[1]; and cd $argv[1]
end

# Interactive process killer with fzf
function fkill
    set tmpfile (mktemp)

    ps -eo user,pid,cmd --sort=-%mem \
        | sed 1d \
        | fzf --multi --reverse \
              --header=" Select processes to kill (Tab to mark, Enter to kill)" \
              --preview 'ps -p {2} -o pid,user,%cpu,%mem,cmd' \
              --bind 'ctrl-s:toggle-sort' > $tmpfile

    if test ! -s $tmpfile
        echo "No processes selected." >&2
        rm -f $tmpfile
        return 1
    end

    for line in (cat $tmpfile)
        set pid (echo $line | awk '{print $2}')
        if test -n "$pid"
            echo "Killing PID $pid…" >&2
            if kill -TERM $pid 2>/dev/null
                echo "Sent SIGTERM to $pid" >&2
            else
                echo "SIGTERM failed for $pid, sending SIGKILL…" >&2
                kill -KILL $pid 2>/dev/null \
                    && echo "Sent SIGKILL to $pid" >&2 \
                    || echo "Failed to kill $pid" >&2
            end
        end
    end
    rm -f $tmpfile
end

# fzf
alias preview 'fzf --preview "bat --color=always --style=numbers --theme OneHalfDark {}" --preview-window=down'
alias fnvim 'nvim (fzf -m --preview "bat --color=always --style=numbers --theme OneHalfDark {}" --preview-window=down)'
alias fvim 'vim (fzf -m --preview "bat --color=always --style=numbers --theme OneHalfDark {}" --preview-window=down)'

# System
alias q 'exit'
alias c 'clear'
alias sd 'cd /sdcard'
alias pf 'cd $PREFIX'
alias mkdir 'mkdir -p'
alias rm 'rm -i'
alias startssh 'termux-ssh'
alias stopssh 'termux-ssh stop'

# Navigation
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'

# Folders
alias ss 'cd /sdcard/Pictures/Screenshots/'
alias ms 'cd /sdcard/Movies'
alias dl 'cd /sdcard/Download'
alias ds 'cd /sdcard/Documents'

# Largest Files
alias largefile 'du -h -x -s -- * | sort -r -h | head -20'

# System Info
alias ls 'eza --icons'
alias la 'eza --icons -lgha --group-directories-first'
alias lt 'eza --icons --tree'
alias lta 'eza --icons --tree -lgha'
alias bat 'bat --theme OneHalfDark'
alias cat 'bat --theme OneHalfDark -p'
alias neofetch 'fastfetch'

# Magick
alias listfont "magick convert -list font | grep -iE 'font:.*'"

# Termux
alias reload 'termux-reload-settings'

alias psu 'ps aux'
alias psg 'ps aux | grep -i'
alias kill9 'kill -9'
alias myip 'curl ifconfig.me'
alias speedtest 'curl -s https://raw.githubusercontent.com/noreplyui5/speedtest-cli/master/speedtest.py | python'

# Utils
alias tmux="tmux -2"
alias mosh='mosh --server "mosh-server new -s -l LANG=en_US.UTF-8"'
alias docker-lab 'set -gx DOCKER_HOST ssh://dockerhost-lab.nexus'
alias docker-vm 'set -gx DOCKER_HOST ssh://dockerhost-vm.localhost'

