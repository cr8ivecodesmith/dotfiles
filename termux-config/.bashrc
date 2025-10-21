### Detect Linux Distro ###
if command -v grep &> /dev/null && [ -f /etc/os-release ]; then
    distro_id=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
else
    distro_id="unknown"
fi

### Set Distro Icon ###
case "$distro_id" in 
  kali) DISTRO_ICON="" ;;   # Kali Linux
  arch*) DISTRO_ICON="" ;;   # Arch Linux
  ubuntu) DISTRO_ICON="" ;; # Ubuntu
  debian) DISTRO_ICON="" ;; # Debian
  fedora) DISTRO_ICON="" ;; # Fedora
  alpine) DISTRO_ICON="" ;; # Alpine
  void) DISTRO_ICON="" ;;   # Void Linux
  opensuse*|sles) DISTRO_ICON="" ;; # openSUSE
  gentoo) DISTRO_ICON="" ;; # Gentoo
  nixos) DISTRO_ICON="" ;; # NixOS
  *) DISTRO_ICON="" ;;      # Default Linux Icon
esac

### Username ###
if [[ -n "$PREFIX" && "$PREFIX" == */com.termux/* ]]; then
    USER_NAME=matt
else
    USER_NAME="$(whoami)"
fi

### Build PS1 with proper escaping ###
#PS1='\[\e[1;32m\]╭─\[\e[1;34m\][\[\e[1;36m\]'"${USER_NAME}"'\[\e[1;33m\] '"${DISTRO_ICON}"' \[\e[1;36m\]\h\[\e[1;34m\]] [\[\e[1;33m\]\w\[\e[1;34m\]]\[\e[0m\]
#\[\e[1;32m\]╰─❯\[\e[0m\] '
PS1='\[\e[1;32m\]\[\e[1;34m\][\[\e[1;36m\]''\[\e[1;33m\]'"${DISTRO_ICON}"' \[\e[1;33m\]\w\[\e[1;34m\]]\[\e[0m\]
\[\e[1;32m\]❯\[\e[0m\] '

[[ -f /data/data/com.termux/files/home/.shell_rc_content ]] && source /data/data/com.termux/files/home/.shell_rc_content
[[ -f /data/data/com.termux/files/home/.aliases ]] && source /data/data/com.termux/files/home/.aliases
