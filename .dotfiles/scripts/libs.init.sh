#!/usr/bin/env sh
set -e

sudo -v

LIB_PATH="$HOME/dev/lib"

sync_git_modules() {
    /usr/bin/git --git-dir="$HOME"/.git/ --work-tree="$HOME" submodule update --init --recursive --rebase
}

build_neovim() {
    NEOVIM_PATH="$LIB_PATH/neovim"
    if [ -d "$NEOVIM_PATH" ]; then
        cd "$NEOVIM_PATH" || exit 1
        git fetch --all
        git pull origin master
        git checkout nightly
        sudo make CMAKE_BUILD_TYPE=Release
        sudo make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.dotfiles/cache"
        sudo make install
    fi
}

build_fzf() {
    if [ -d "$FZF_PATH" ]; then
        FZF_PATH="$LIB_PATH/fzf"
        cd "$FZF_PATH" || exit 1
        git fetch --tags --all
        git checkout master
        git pull
        # latestTag="$(git describe --tags "$(git rev-list --tags --max-count=1)")"
        make
        make install
        chmod +x "$FZF_PATH/bin/fzf"
    fi
}

sync_git_modules
build_neovim
build_fzf

unset LIB_PATH FZF_PATH NEOVIM_PATH
