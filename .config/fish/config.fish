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
        case pop
            echo ""
        case '*'
            echo ""
    end
end


function __user_name
    echo (whoami)
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

    # Line 1:
    echo -n $blue'['$orange$icon' '$yellow$cwd$blue']'$reset' '
    echo -n $blue$ven $reset
    echo -n $blue$vcs $reset

    # Line 2: 
    echo $reset' '
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

set paths_to_prepend $HOME/.local/bin $HOME/.cargo/bin

# Loop over each path
for path in $paths_to_prepend
    # Check if path exists and if the PATH already contains the current path
    if test -d $path; and not contains $path $PATH
        # If not, prepend the path to the PATH variable
        set -gx PATH $path $PATH
    end
end


#### NPM and NVM config
if test -d $HOME/.npm-packages
    set NPM_PACKAGES $HOME/.npm-packages
    set PATH $NPM_PACKAGES/bin $PATH
end

if test -d $HOME/.nvm
    set NVM_DIR $HOME/.nvm
end


#### CLOUDSDK config
# New auth plugin for gcloud as of kube V1.26
set USE_GKE_GCLOUD_AUTH_PLUGIN True
