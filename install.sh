#!/usr/bin/env bash
# Got this script from https://github.com/sontek/dotfiles/blob/master/install.sh
# I have modified it to suite myself
#
function link_file {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

    if [ -e "${target}" ] && [ ! -L "${target}" ]; then
        mv $target $target.df.bak
    fi

    ln -sf ${source} ${target}
}

function unlink_file {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

    if [ -e "${target}.df.bak" ] && [ -L "${target}" ]; then
        unlink ${target}
        mv $target.df.bak $target
    fi
}

if [ "$1" = "vim" ]; then
    for i in _vim*
    do
       link_file $i
    done
elif [ "$1" = "restore" ]; then
    for i in _*
    do
        unlink_file $i
    done
    exit
else
    for i in _*
    do
        link_file $i
    done
fi

# Make sure I have a tmp directory for vim
mkdir -p ~/.vim/tmp/

git submodule update --init --recursive
git submodule foreach --recursive git pull origin master
#EOF
