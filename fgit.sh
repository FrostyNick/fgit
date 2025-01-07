#!/usr/bin/env bash

# options (this will probably be moved in a future update)
projects_path="$HOME/p"

assertname() {
    name=$(ls --hyperlink=no)
    if [ "$(echo)" = "$name" ]; then
        echo "No directory found. Likely due to invalid git clone. Exiting."; (return -1 || exit)
    fi
}

initfgit() {
    olpwd=$(pwd)
    tmpgc=$(mktemp -d)
    name=""

    if [ ! "$2" = "." ]; then
        echo Doing empty git clone in $tmpgc:
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
        echo "Existing directory/folder exists, renaming from \"$name\" to \"$newName\"."
        mv $name $newName
        name=$newName
    fi

    (mv $name $projects_path/$name) && echo Successfully saved in $projects_path/$name || echo Error: Failed to move project.
    cd $projects_path/$name && cd $2
    rmdir $tmpgc
    OLDPWD=$olpwd
    echo;echo test oldpwd frfr nocaptua;echo
}


if [ $2 ]; then
[[ "${BASH_SOURCE[0]}" != "${0}" ]] || (echo;echo "WARNING: This is not sourced which may lead to unintended behavior. If this is not intentional, type Ctrl + C and try again. Run fgit without arguments for more info. Otherwise press enter.";read)
    initfgit $1 $2
else
    if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
        echo "WARNING: This program is not being sourced while being ran which may lead to unintended behavior when running more than just the help menu.";echo
        echo "Usage that sources this program: . fgit \$1 \$2"
        echo "Alternatively, you may also add an alias to your .bashrc file adding this: alias fgit=\". fgit\"";echo
    fi
    echo "Usage: fgit \$1 \$2"
    echo "Git cloning to the next level."
    echo "  \$1      git repo" # could be flag in future
    echo "  \$2      directory/folder to make repo with sparse checkout or '.' for regular clone" # --filter=blob:none
    # echo "  \$name   comes from directory created after clone"
    echo
    echo "Also note that in order for your cwd to be changed as expected, this script should be sourced (the . at the beginning in below example).";
    echo
    echo "Example: . fgit https://github.com/FrancisTR/Purified GodotGame"
    echo
    echo "If this program is not already in your path, you can symlink it. Here's an example:"
    echo "sudo ln -s \$HOME/p/fgit/fgit.sh /usr/bin/fgit"
fi
