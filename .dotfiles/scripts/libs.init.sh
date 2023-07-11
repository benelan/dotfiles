#!/usr/bin/env sh
set -e
sudo -v

LIB_PATH="$HOME/dev/lib"

update_modules() {
    /usr/bin/git --git-dir="$HOME"/.git/ --work-tree="$HOME" \
        submodule update --init --recursive --rebase "$@"
}

build_neovim() {
    NEOVIM_PATH="$LIB_PATH/neovim"
    if [ -d "$NEOVIM_PATH" ]; then
        cd "$NEOVIM_PATH" || exit 1
        git fetch --all
        git reset --hard origin/master
        # git checkout nightly
        sudo make CMAKE_BUILD_TYPE=Release
        sudo make install
    fi
}

build_fzf() {
    FZF_PATH="$LIB_PATH/fzf"
    if [ -d "$FZF_PATH" ]; then
        cd "$FZF_PATH" || exit 1
        git fetch --tags --all
        git reset --hard origin/master
        # git checkout "$(git describe --tags "$(git rev-list --tags --max-count=1)")"
        make
        make install
        chmod +x "$FZF_PATH/bin/fzf"
    fi
}

build_taskopen() {
    TASKOPEN_PATH="$LIB_PATH/taskopen"
    if [ -d "$TASKOPEN_PATH" ] && is-supported task && is-supported nim; then
        cd "$TASKOPEN_PATH" || exit 1
        git fetch --all
        git reset --hard origin/master
        make PREFIX=/usr
        sudo make PREFIX=/usr install
    fi
}

update_vim_plugins() {
    cd && update_modules .vim && vim +"helptags ALL" +"quit"
}

# update_modules
update_vim_plugins
build_neovim
build_fzf
build_taskopen

unset LIB_PATH FZF_PATH NEOVIM_PATH TASKOPEN_PATH
