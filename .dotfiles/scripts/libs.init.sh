#!/bin/sh
set -e

LIB_PATH="$HOME/dev/lib"
FZF_PATH="$LIB_PATH/fzf"
NEOVIM_PATH="$LIB_PATH/neovim"

/usr/bin/git --git-dir="$HOME"/.git/ --work-tree="$HOME" submodule update --init --recursive

if [ -d "$NEOVIM_PATH" ]; then
    cd "$NEOVIM_PATH" || exit 1
    git fetch --all
    git pull origin master
    git checkout nightly
    sudo make CMAKE_BUILD_TYPE=Release
    sudo make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.dotfiles/cache"
    sudo make install
fi

if [ -d "$FZF_PATH" ]; then
    cd "$FZF_PATH" || exit 1
    git fetch --tags --all
    git checkout master
    git pull
    # latestTag="$(git describe --tags "$(git rev-list --tags --max-count=1)")"
    make
    make install
    chmod +x "$FZF_PATH/bin/fzf"
fi

unset LIB_PATH FZF_PATH NEOVIM_PATH
