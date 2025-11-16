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
            echo ""
    end
end


function __user_name
    # Termux check: PREFIX contains /com.termux/
    if set -q PREFIX; and string match -q '*com.termux*' -- $PREFIX
        echo matt
    else
        echo (whoami)
    end
end


function __venv_name --description 'Print active venv/conda env name'
    if set -q VIRTUAL_ENV
        echo ' ('(basename $VIRTUAL_ENV)')'
        return 0
    else if set -q CONDA_DEFAULT_ENV
        echo ' ('$CONDA_DEFAULT_ENV')'
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
    #echo -n $bold$orange'╭─'$blue'['$cyan$uname$orange $icon $cyan$host$blue']'$reset' '
    #echo -n $bold$orange'╭─'$blue'['$orange$icon$blue']'$reset' '
    #echo -n $blue'['$orange$icon$blue']'$reset' '
    #echo -n $blue'['$yellow$cwd$blue']'$reset' '
    echo -n $blue'['$orange$icon' '$yellow$cwd$blue']'$reset' '
    echo -n $blue$ven $reset
    echo -n $blue$vcs $reset

    # Line 2: ╰─❯ 
    echo $reset' '
    #echo -n $bold$orange'╰─❯ '$reset
    echo -n $bold$orange'❯ '$reset
end


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


# ~/.config/fish/functions/use-docker-lab.fish
function use-docker-lab --description "Switch to remote Docker host via SSH"
    # 1. unset DOCKER_HOST to avoid override warnings
    set -e DOCKER_HOST

    # 2. make sure the context exists
    if not docker context inspect homelab >/dev/null ^/dev/null
        echo "Creating Docker context 'homelab'..."
        docker context create homelab --docker "host=ssh://dockerhost-lab.nexus"
    end

    # 3. switch to that context
    docker context use homelab

    # 4. ensure a remote builder exists and is set to use
    if not docker buildx inspect homelab >/dev/null ^/dev/null
        echo "Creating buildx builder 'homelab'..."
        docker buildx create --name homelab --use ssh://dockerhost-lab.nexus
    else
        docker buildx use homelab
    end

    echo (set_color green)"Now using Docker host: dockerhost-lab.nexus with buildx 'homelab'"(set_color normal)
end


#### Update PATH
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

set paths_to_prepend \
    $HOME/.local/bin \
    $HOME/.codex-cli-env/bin \
    $HOME/.opt/llama.cpp/bin/

# Loop over each path
for path in $paths_to_prepend
    # Check if path exists and if the PATH already contains the current path
    if test -d $path; and not contains $path $PATH
        # If not, prepend the path to the PATH variable
        set -gx PATH $path $PATH
    end
end

#### CLOUDSDK config
# New auth plugin for gcloud as of kube V1.26
set USE_GKE_GCLOUD_AUTH_PLUGIN True


#### Huggingface env cache
set HF_HOME $HOME/Downloads/huggingface
set HUGGINGFACE_HUB_CACHE $HF_HOME/hub


#### Interactive
if status is-interactive
    # Commands to run in interactive sessions can go here

    #### direnv
    if type -q direnv
        direnv hook fish | source
    end

    #### nvm config
    if test -d $HOME/.nvm
        set -Ux nvm_default_version latest
    end

    #### Set codex cli helpers
    if test -d $HOME/.codex-cli-env
        source ~/.codex-cli-env/shell/codexenv.fish
    end

end
