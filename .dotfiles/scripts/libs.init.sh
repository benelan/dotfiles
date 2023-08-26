#!/usr/bin/env sh
set -e
sudo -v

if [ -z "$LIB" ]; then
    printf "LIB environment variable not set, exiting\n"
    exit 1
fi

update_modules() {
    /usr/bin/git --git-dir="$HOME"/.git/ --work-tree="$HOME" \
        submodule update --init --recursive --rebase "$@"
}

build_neovim() {
    ! [ -d "$LIB/neovim" ] && return
    cd "$LIB/neovim" || return
    git fetch --all --tags --force
    git reset --hard origin/master
    git checkout nightly
    # git checkout stable
    sudo make CMAKE_BUILD_TYPE=Release
    sudo make install
}

build_fzf() {
    ! [ -d "$LIB/fzf" ] && return
    cd "$LIB/fzf" || return
    git fetch --all --tags --force
    git reset --hard origin/master
    git checkout "$(git describe --tags "$(git rev-list --tags --max-count=1)")"
    make
    make install
    chmod +x "$LIB/fzf/bin/fzf"
}

build_taskopen() {
    if [ -d "$LIB/taskopen" ] && is-supported task && is-supported nim; then
        cd "$LIB/taskopen" || return
        git fetch --tags --all --force
        git reset --hard origin/master
        make PREFIX=/~/.local
        sudo make PREFIX=~/.local install
    fi
}

update_vim_plugins() {
    cd && update_modules .vim
    vim +"$(
        find ~/.vim/pack/foo/opt \
            -maxdepth 1 -mindepth 1 -type d \
            -exec basename --multiple {} \; |
            perl -pe 's/^/packadd /' |
            tr '\n' '|'
    ) helptags ALL | quit"
}

update_neovim_plugins() {
    nvim --headless +"Lazy! sync" +qa
}

update_devdocs_sources() {
    sources="astro bash css docker dom gnu_make go html http javascript node npm react sass tailwindcss typescript vite vue-3"
    nvim --headless \
        +"DevdocsFetch" \
        +"DevdocsInstall $sources" \
        +"DevdocsUpdateAll" \
        +qa
}

# update_modules
build_neovim || true
update_vim_plugins || true
update_neovim_plugins || true
update_devdocs_sources || true
build_fzf || true
# build_taskopen
