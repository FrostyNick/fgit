#!/usr/bin/env bash

if [ ! -f "${XDG_CONFIG_HOME:=$HOME/.config}/fgit.ini" ] && [ ! -f "$HOME/.fgit.ini" ]; then
    cwd="$(pwd)"
    cwdp=${cwd%/*} # dirname $(pwd) # works in gnu but not everywhere
    echo "NOTE: If you want to create a directory, kill this program (ctrl + c) and do that first."
    echo "SETUP: Set a project path for projects to be cloned to. Options to type:"
    echo "- Type any absolute path. Example: /etc/projects (Locations with root permissions at your own risk. Not tested yet.)"
    echo "- Type . to use current directory: $cwd"
    echo "- Type ~ to use home directory: $HOME"
    echo "- Type .. to use parent directory: $cwdp"
    projects_path=""
    while read line; do
        if [ "$line" = "." ]; then
            projects_path="$cwd"
        elif [ "$line" = ".." ]; then
            projects_path="$cwdp"
        elif [ "$line" = "~" ]; then
            projects_path="$HOME"
        elif [ -d "$line" ]; then
            projects_path="$line"
        fi
        if [ "$projects_path" ]; then
            if [ -d "${XDG_CONFIG_HOME:=$HOME/.config}" ]; then
                config_path="${XDG_CONFIG_HOME:=$HOME/.config}/fgit.ini"
            else
                config_path="$HOME/.fgit.ini"
            fi
            read -p "\"$projects_path\" as an absolute path will be used. To change this again, modify or remove the file located in: $config_path. Otherwise, ctrl + c to not save changes. Enter/return to continue.";echo
            echo "projects_path=$projects_path" >> $config_path
            break
        fi

        echo "That directory doesn't exist. Try again."
    done
fi

if [ -f "$HOME/.config/fgit.ini" ]; then
    config_path="$HOME/.config/fgit.ini"
elif [ -f "$XDG_CONFIG_HOME/fgit.ini" ]; then
    config_path="$XDG_CONFIG_HOME/fgit.ini"
else
    config_path="$HOME/.fgit.ini"
fi

projects_path="$(grep '^projects_path=' $config_path | awk -F '=' '{print $2}')"
git_url="$(grep '^git_url=' $config_path | awk -F '=' '{print $2}')"
if [ "$git_url" = "" ]; then
    read -p "Pick starting URL that will be used if using short syntax. If left blank, \"https://github.com/\" will be set in $config_path. (Example: fgit neovim/neovim would be the same as fgit https://github.com/neovim/neovim)" git_url
    if [ "$git_url" = "" ]; then
        git_url="https://github.com/"
    fi
    echo "git_url=$git_url" >> $config_path
fi
olpwd="$(pwd)"

setname() {
    name="$(env ls -A --hyperlink=no)"
    if [ "$(echo)" = "$name" ]; then
        echo "ERROR: No directory found. Likely due to invalid git clone. Exiting."; cd "$olpwd"; (return -1 || exit)
    fi
}

initfgit() {
    tmpgc=$(mktemp -d)
    name=""
    echo "$1" | grep ":/\|^http" &> /dev/null && url="$1" || url="$(echo "$git_url$1")"

    if [ ! "$2" = "." ]; then
        echo "Running git clone without checkout \(empty\) in $tmpgc:"
        cd $tmpgc && git clone -n --depth=1 --filter=tree:0 $url || (return || exit)

        setname || return
        echo;echo Running git sparse-checkout in $name directory:

        # if directory exists, cd and do sparse-checkout
        cd "$name" && (git sparse-checkout set --no-cone $2; git checkout) || (return || exit)
        # if old dir exists, move directory and cd to non-empty dir
        cd - ; echo
    else
        cd $tmpgc && git clone --depth=1 $url
        setname || return
    fi

    # if [ -d "$projects_path/$name" ]; then # HACK: Transition from name to name_owner as default
    if [ -d "$projects_path/$name" ]; then # -d is directory
        name_="${name/_/__}"
        owner="$(echo "$url" | awk -F '/' '{print $(NF-1)}')"
        name_owner="$name_"_"$owner"
        # echo "Name + owner: ${name/_/__}"
        if [ -d "$projects_path/$name_owner" ]; then # -d is directory
            newName="$name_owner"Dup"$RANDOM" # Yes naming could be better. Also $RANDOM could also rarely collide.
            echo "NOTE: Existing directories/folders exist. Renaming from \"$name\" to \"$newName\"."
        else
            newName="$name_owner"
            echo "NOTE: Existing directory/folder exists. Renaming from \"$name\" to \"$newName\"."
        fi
        mv "$name" "$newName"
        name="$newName"
    fi

    (mv "$name" "$projects_path/$name") && echo "Successfully saved in $projects_path/$name" || echo "Error: Failed to move project."
    # cd $projects_path/$name && (cd $2;zoxide add .) # if this is added, disable by default
    cd "$projects_path/$name" && cd "$2"
    rmdir $tmpgc
    OLDPWD=$olpwd
}


if [ $2 ]; then
    [[ "${BASH_SOURCE[0]}" != "${0}" ]] || (echo;echo "WARNING: This is not sourced which may lead to unintended behavior. If this is not intentional, type Ctrl + C and try again. Run fgit without arguments for more info. Otherwise press enter.";read)
    initfgit $1 $2
else
    echo "Usage: fgit \$1 \$2"
    echo "Git cloning to the next level."
    echo "  \$1      git repo" # could be flag in future
    echo "  \$2      directory/folder to make repo with sparse checkout or '.' for minimal regular clone." # --filter=blob:none
    # echo "  \$name   comes from directory created after clone"
    echo
    if [ "$git_url" = "https://github.com/" ]; then
        echo "Example: fgit FrancisTR/Godot-Purified GodotGame"
    else
        echo "Example: fgit https://github.com/FrancisTR/Godot-Purified GodotGame"
    fi
    echo
    echo Other values:
    echo config_path=$config_path \(detected\)
    echo projects_path=$projects_path
    echo git_url=$git_url
    echo version=1.2.0 \(hardcoded\)
    echo
    # echo zoxide=$(command -v zoxide >/dev/null && echo "found" || echo "not found")
    if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
        echo;echo
        echo "  WARNING: This program is not being sourced while being ran which may lead to unintended behavior when running more than just the help menu.";echo
        echo "  Usage that sources this program: . fgit \$1 \$2"
        echo "  Alternatively, you may also add an alias to your .bashrc file by running this command (takes effect after restarting terminal):"
        echo '  echo "alias fgit=\". fgit\"" >> ~/.bashrc';echo;echo
    fi
fi
