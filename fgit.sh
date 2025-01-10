#!/usr/bin/env bash

if [ ! -f "${XDG_CONFIG_HOME:=$HOME/.config}/fgit.ini" ] && [ ! -f "$HOME/.fgit.ini" ]; then
    echo "NOTE: If you want to create a directory, kill this program (ctrl + c) and do that first."
    echo "SETUP: Set a project path for projects to be cloned to. Options to type:"
    echo "- Type any absolute path. Example: /etc/projects (Locations with root permissions at your own risk. Not tested yet.)"
    echo "- Type . to use current directory: $(pwd)"
    echo "- Type ~ to use home directory: $HOME"
    echo "- Type .. to use parent directory: $(pwd)/.."
    projects_path=""
    while read line; do
        if [ "$line" = "." ]; then
            projects_path="$(pwd)"
        elif [ "$line" = ".." ]; then
            projects_path="$(pwd)/.."
        # elif [ "$line" = "./" ]; then
        #     # read next line with:
        #     projects_path="$(pwd)/$line"
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

projects_path="$(grep '^projects_path=' $config_path | awk -F '=' '{ print $2 }')"

assertname() {
    name=$(env ls --hyperlink=no)
    if [ "$(echo)" = "$name" ]; then
        echo "ERROR: No directory found. Likely due to invalid git clone. You might need to do \`cd -\` to go back. Exiting."; (return -1 || exit)
    fi
}

initfgit() {
    olpwd=$(pwd)
    tmpgc=$(mktemp -d)
    name=""

    if [ ! "$2" = "." ]; then
        echo "Doing git clone without checkout \(empty\) in $tmpgc:"
        cd $tmpgc && git clone -n --depth=1 --filter=tree:0 $1 || (return || exit)

        assertname || return
        echo;echo Doing git sparse-checkout in $name directory:

        # if directory exists, cd and do sparse-checkout
        cd $name && (git sparse-checkout set --no-cone $2; git checkout) || (return || exit)
        # if old dir exists, move directory and cd to non-empty dir
        cd - ; echo
    else
        cd $tmpgc && git clone --depth=1 $1
        assertname || return
    fi

    if [ -d "$projects_path/$name" ]; then # -d is directory
        newName="$name"Dup"$RANDOM" # Yes naming could be better. Also $RANDOM could also rarely collide.
        echo "NOTE: Existing directory/folder exists, renaming from \"$name\" to \"$newName\"."
        mv $name $newName
        name=$newName
    fi

    (mv $name $projects_path/$name) && echo Successfully saved in $projects_path/$name || echo Error: Failed to move project.
    # cd $projects_path/$name && (cd $2;zoxide add .) # if this is added, disable by default
    cd $projects_path/$name && cd $2
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
    echo "Example: fgit https://github.com/FrancisTR/Godot-Purified GodotGame"
    echo
    echo "If this program is not already in your path, you can symlink it. Here's an example:"
    echo "sudo ln -s \$HOME/path/to/fgit/fgit.sh /usr/bin/fgit"
    echo
    echo Other values:
    echo config_path=$config_path \(detected\)
    echo projects_path=$projects_path
    echo version=1.0.0 \(hardcoded\)
    echo
    # echo zoxide=$(command -v zoxide >/dev/null && echo "found" || echo "not found")
    if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
        echo;echo
        echo "  WARNING: This program is not being sourced while being ran which may lead to unintended behavior when running more than just the help menu.";echo
        echo "  Usage that sources this program: . fgit \$1 \$2"
        echo "  Alternatively, you may also add an alias to your .bashrc file by running this command (do NOT use single arrow if you rewrite it):"
        echo '  echo "alias fgit=\". fgit\"" >> ~/.bashrc';echo
    fi
fi
