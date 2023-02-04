#!/bin/sh

VENDOR_PATH="$HOME/.dotfiles/vendor"

/usr/bin/git --git-dir="$HOME"/.git/ --work-tree="$HOME" submodule update --init --recursive
/usr/bin/git --git-dir="$HOME"/.git/ --work-tree="$HOME" pull --recurse-submodules

if [ -d "$VENDOR_PATH/fzf" ]; then
    cd "$VENDOR_PATH/fzf" || return
    git fetch --tags --all
    latestTag="$(git describe --tags "$(git rev-list --tags --max-count=1)")"
    git checkout "$latestTag"
    sudo make install
fi

if [ -d "$VENDOR_PATH/neovim" ]; then
    cd "$VENDOR_PATH/neovim" || return
    git checkout master
    git pull
    make CMAKE_BUILD_TYPE=Release
    # make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.dotfiles/cache/neovim"
    sudo make install
    chmod +x "$VENDOR_PATH/neovim/build/bin/nvim"
fi
