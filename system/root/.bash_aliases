# Aliases for safer file operations
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Directory management
alias mkdir='mkdir -p'
alias du='du -h'
alias df='df -h'

# Editors
alias vim='nvim'
alias vi='nvim'

# Navigation
alias ..='cd ..'
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Use bat/batcat if available
if command -v batcat &> /dev/null; then
    alias bat='batcat --theme OneHalfDark'
    alias cat='batcat --theme OneHalfDark -p'
elif command -v bat &> /dev/null; then
    alias bat='bat --theme OneHalfDark'
    alias cat='bat --theme OneHalfDark -p'
fi
