#!/usr/bin/env bash
# shellcheck disable=2046
set -e

# This script installs the programming languages, packages, and scripts I use.
# Comment out functions at the bottom to skip sections.

BIN_DIR="$HOME/.local/bin"
MAN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/man"
DEPS_DIR="$DOTFILES/deps"
mkdir -p "$BIN_DIR" "$MAN_DIR/man1" "$MAN_DIR/man5"

# Install programming languages                                         {{{
# --------------------------------------------------------------------- {|}

## Rust - https://www.rust-lang.org/tools/install              {{{
install_rust() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    export PATH="${PATH}:${HOME}/.cargo/bin"
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
## Nim - https://nim-lang.org/install_unix.html                {{{
install_nim() {
    curl https://nim-lang.org/choosenim/init.sh -sSf | sh
    export PATH="${PATH}:${HOME}/.nimble/bin"
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
## Golang - https://go.dev/doc/install                         {{{
install_golang() {
    # checksum will need to be updated when using a new go version
    checksum="d7ec48cde0d3d2be2c69203bc3e0a44de8660b9c09a6e85c4732a3f7dc442612"
    outfile="go1.20.5.linux-amd64.tar.gz"
    curl -sSLo "$outfile" "https://go.dev/dl/$outfile"

    if [ "$(shasum -a 256 "$outfile" | awk '{print $1}')" = "$checksum" ]; then
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf "$outfile"
        rm "$outfile"
        export PATH="${PATH}:/usr/local/go/bin"
    else
        printf "\nchecksum does not match, please install golang manually:\nhttps://go.dev/doc/install"
    fi
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
## Node.js - https://docs.volta.sh/guide/getting-started       {{{
install_volta() {
    curl https://get.volta.sh | bash -s -- --skip-setup

    export VOLTA_HOME=~/.volta
    export PATH="${PATH}:${VOLTA_HOME}/bin"

    volta install node@16
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
## Lua - https://www.lua.org/download.html                     {{{
install_lua() {
    is-supported lua && return
    curl -R -O https://www.lua.org/ftp/lua-5.4.6.tar.gz

    tar -zxf lua-5.4.6.tar.gz
    cd lua-5.4.6

    make linux test
    sudo make install
}

### LuaJIT (compiler)              {{{
### https://luajit.org/download.html
install_luajit() {
    is-supported luajit && return

    if ! [ -d "$LIB/luajit" ]; then
        git clone https://luajit.org/git/luajit.git "$LIB/luajit"
    fi

    cd "$LIB/luajit"
    git pull

    sudo make
    sudo make install
}

###}}}
### Luarocks (Lua package manager) {{{
### https://luarocks.org#quick-start
install_luarocks() {
    is-supported luarocks && return

    wget https://luarocks.org/releases/luarocks-3.9.2.tar.gz
    tar zxpf luarocks-3.9.2.tar.gz
    cd luarocks-3.9.2

    ./configure --lua-version=5.4
    make
    sudo make install
}
###}}}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}

# --------------------------------------------------------------------- }}}
# Install programming language packages                                 {{{
# --------------------------------------------------------------------- {|}

## Rust CLI tools - https://crates.io                          {{{
install_cargo_packages() {
    ! [ -f "$DEPS_DIR/cargo" ] && return

    if ! is-supported cargo || ! is-supported rustup; then
        install_rust
    else
        rustup update
    fi

    cargo install $(cat "$DEPS_DIR/cargo")

    # link batcat to bat due to package name conflict
    ! is-supported bat && is-supported batcat &&
        ln -s "$(command -v batcat)" "$BIN_DIR/bat"

    # link fdfind to fd
    ! is-supported fd && is-supported fdfind &&
        ln -s "$(command -v fdfind)" "$BIN_DIR/fd"
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
## Golang CLI tools - https://pkg.go.dev                       {{{
install_golang_packages() {
    ! is-supported go && install_golang
    ! [ -f "$DEPS_DIR/golang" ] && return

    while IFS="" read -r pkg || [ -n "$pkg" ]; do
        go install "$pkg"
    done <"$DEPS_DIR/golang"
    unset pkg
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
## Python CLI tools - https://pypi.org/project/pipx/           {{{
install_pip_packages() {
    ! [ -f "$DEPS_DIR/pip" ] && return

    while IFS="" read -r pkg || [ -n "$pkg" ]; do
        pip3 install --user "$pkg"
    done <"$DEPS_DIR/pip"
    unset pkg
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
## Node.js packages - https://www.npmjs.com                    {{{
install_node_packages() {
    ! [ -f "$DEPS_DIR/node" ] && return

    # NOTE: volta only works on x86_64 architectures for now
    ! is-supported volta && ! is-supported node && install_volta
    npm install -g $(cat "$DEPS_DIR/node")
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}

# --------------------------------------------------------------------- }}}
# Scripts                                                               {{{
# --------------------------------------------------------------------- {|}

## taskopen - https://github.com/jschlatow/taskopen            {{{
install_taskopen() {
    is-supported taskopen || ! is-supported task && return

    curl -sSLo "$BIN_DIR/taskopen" \
        https://raw.githubusercontent.com/jschlatow/taskopen/v1.2-devel/taskopen

    curl -sSLo "$MAN_DIR/man1/taskopen.1" \
        https://raw.githubusercontent.com/jschlatow/taskopen/v1.2-devel/doc/man/taskopen.1

    curl -sSLo "$MAN_DIR/man5/taskopenrc.5" \
        https://raw.githubusercontent.com/jschlatow/taskopen/v1.2-devel/doc/man/taskopenrc.5

    chmod +x "$BIN_DIR/taskopen"
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
## fasd - https://github.com/clvv/fasd                         {{{
install_fasd() {
    is-supported fasd && return

    curl -sSLo "$BIN_DIR/fasd" \
        https://raw.githubusercontent.com/clvv/fasd/master/fasd

    curl -sSLo "$MAN_DIR/man1/fasd.1" \
        https://raw.githubusercontent.com/clvv/fasd/master/fasd.1

    sudo chmod +x "$BIN_DIR/fasd"
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
## fff - https://github.com/dylanaraps/fff                     {{{
install_fff() {
    is-supported fff && return

    curl -sSLo "$BIN_DIR/fff" \
        https://raw.githubusercontent.com/dylanaraps/fff/master/fff

    curl -sSLo "$MAN_DIR/man1/fff.1" \
        https://raw.githubusercontent.com/clvv/fff/master/fff.1

    sudo chmod +x "$BIN_DIR/fff"
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
## git-open - https://github.com/paulirish/git-open            {{{
install_git-open() {
    is-supported git-open && return

    curl -sSLo "$BIN_DIR/git-o" \
        https://raw.githubusercontent.com/paulirish/git-open/master/git-open

    sudo chmod +x "$BIN_DIR/git-o"
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
## git-jump - https://github.com/git/git/tree/master/contrib   {{{
install_git-jump() {
    is-supported git-jump && return

    # it may already be on in the filesystem
    loc1="/usr/local/share/git-core/contrib/git-jump/git-jump"

    # sometimes it gets put in doc for some reason
    loc2="/usr/share/doc/git/contrib/git-jump/git-jump"

    if [ -f "$loc1" ] && [ -r "$loc1" ]; then
        cp -p "$loc1" "$BIN_DIR"
    elif [ -f "$loc2" ] && [ -r "$loc2" ]; then
        cp -p "$loc2" "$BIN_DIR"
    else
        # otherwise download it
        curl -sSLo "$BIN_DIR/git-jump" \
            https://raw.githubusercontent.com/git/git/master/contrib/git-jump/git-jump
    fi

    sudo chmod +x "$BIN_DIR/git-jump"
    unset loc1 loc2
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
## git-extras - https://github.com/tj/git-extras               {{{
## Install helpful bash scripts for git workflows
install_git-extras() {
    curl -sSL https://raw.githubusercontent.com/tj/git-extras/master/install.sh |
        sudo bash /dev/stdin
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}

# --------------------------------------------------------------------- }}}

install_fasd
install_fff
install_taskopen
install_git-open
install_git-jump
# install_git-extras

# install_rust
# install_nim
# install_golang
# install_volta
# install_lua
# install_luajit
# install_luarocks

install_node_packages
install_pip_packages
install_cargo_packages
install_golang_packages
