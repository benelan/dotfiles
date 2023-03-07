#!/bin/sh
set -e

VENDOR_PATH="$HOME/.dotfiles/vendor"
FZF_PATH="$VENDOR_PATH/fzf"
NEOVIM_PATH="$VENDOR_PATH/neovim"

/usr/bin/git --git-dir="$HOME"/.git/ --work-tree="$HOME" submodule update --init --recursive
/usr/bin/git --git-dir="$HOME"/.git/ --work-tree="$HOME" pull --recurse-submodules

if [ -d "$FZF_PATH" ]; then
    cd "$FZF_PATH" || return
    git fetch --tags --all
    # latestTag="$(git describe --tags "$(git rev-list --tags --max-count=1)")"
    git checkout master
    make
    make install
    # chmod +x "$FZF_PATH/bin/*"
fi

if [ -d "$NEOVIM_PATH" ]; then
    cd "$NEOVIM_PATH" || return
    git checkout master
    git pull
    sudo make CMAKE_BUILD_TYPE=Release
    # sudo make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.dotfiles/cache"
    sudo make install
    # chmod +x "$NEOVIM_PATH/build/bin/nvim"
fi

unset VENDOR_PATH FZF_PATH NEOVIM_PATH
