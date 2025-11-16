# zoxide: set `cd` to use zoxide
# (Fish uses `... | source` instead of Bash's eval)
zoxide init fish --cmd cd | source

# FZF color scheme
set -x FZF_DEFAULT_OPTS " --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 --color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 --color=selected-bg:#494d64 --color=border:#363a4f,label:#cad3f5"

# print your current termux-desktop configuration
alias tdconfig 'cat "/data/data/com.termux/files/usr/etc/termux-desktop/configuration.conf"'

# Set DISPLAY unless on Termux
if not string match -q '*termux*' -- $HOME
    set -x DISPLAY :0
end

# open the folder where all the apps added by proot-distro are located
# (Fish uses `and` instead of `&&`; alias is fine here, or use a function if you prefer)
alias pdapps 'cd /data/data/com.termux/files/usr/share/applications/pd_added; and ls'

