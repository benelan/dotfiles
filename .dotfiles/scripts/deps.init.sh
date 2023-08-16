#!/usr/bin/env bash
# shellcheck disable=2046
set -e

if [ -z "$DOTFILES" ]; then
    printf "DOTFILES environment variable not set, exiting\n"
    exit 1
fi

# This script installs the tools I use.
# Comment out functions at the bottom to skip sections.

BIN_DIR="$HOME/.local/bin"
DEPS_DIR="$DOTFILES/deps"
mkdir -p "$BIN_DIR"

# Install the Rust language
# https://www.rust-lang.org/tools/install
install_rust() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    export PATH="${PATH}:${HOME}/.cargo/bin"
}

install_nim() {
    curl https://nim-lang.org/choosenim/init.sh -sSf | sh
    export PATH="${PATH}:${HOME}/.nimble/bin"
}

# Install the Go language
# https://go.dev/doc/install
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

# Install Volta for managing Node/NPM
# https://docs.volta.sh/guide/getting-started
install_volta() {
    curl https://get.volta.sh | bash -s -- --skip-setup
    export VOLTA_HOME=~/.volta
    export PATH="${PATH}:${VOLTA_HOME}/bin"
    volta install node@16
}

# Install Rust CLI tools
# https://crates.io
install_cargo_packages() {
    ! [ -f "$DEPS_DIR/cargo" ] && return
    if ! is-supported cargo || ! is-supported rustup; then
        install-rust
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

# Install global Node packages
# https://www.npmjs.com
install_node_packages() {
    ! [ -f "$DEPS_DIR/node" ] && return
    # NOTE: volta only works on x86_64 architectures for now
    ! is-supported volta && ! is-supported node && install_volta
    npm install -g $(cat "$DEPS_DIR/node")
}

# Install Go CLI tools
# https://pkg.go.dev
install_golang_packages() {
    ! [ -f "$DEPS_DIR/golang" ] && return
    ! is-supported go && install_golang
    while IFS="" read -r pkg || [ -n "$pkg" ]; do
        go install "$pkg"
    done <"$DEPS_DIR/golang"
    unset pkg
}

# Install Python CLI tools
# https://pypi.org/project/pipx
install_pip_packages() {
    ! [ -f "$DEPS_DIR/pip" ] && return
    while IFS="" read -r pkg || [ -n "$pkg" ]; do
        pip3 install --user "$pkg"
    done <"$DEPS_DIR/pip"
    unset pkg
}

# Install helpful bash scripts for git workflows
# https://github.com/tj/git-extras
install_git_extras() {
    curl -sSL https://raw.githubusercontent.com/tj/git-extras/master/install.sh |
        sudo bash /dev/stdin
}

install_git_jump() {
    is-supported git-jump && return

    # it may already be on in the filesystem
    if [ -f /usr/local/share/git-core/contrib/git-jump/git-jump ] &&
        [ -r /usr/local/share/git-core/contrib/git-jump/git-jump ]; then
        cp /usr/local/share/git-core/contrib/git-jump/git-jump "$BIN_DIR"

    # sometimes it gets put in doc for some reason
    elif [ -f /usr/share/doc/git/contrib/git-jump/git-jump ] &&
        [ -r /usr/share/doc/git/contrib/git-jum/git-jumpp ]; then
        cp /usr/share/doc/git/contrib/git-jump/git-jump "$BIN_DIR"

    # otherwise download it
    else
        curl -sSLo "$BIN_DIR/git-jump" \
            https://raw.githubusercontent.com/git/git/master/contrib/git-jump/git-jump
    fi
    chmod +x "$BIN_DIR/git-jump"
}

install_taskopen() {
    is-supported taskopen || ! is-supported task && return
    curl -sSLo "$BIN_DIR/taskopen" \
        https://raw.githubusercontent.com/jschlatow/taskopen/v1.2-devel/taskopen
    curl -sSLo "${XDG_DATA_HOME:-~/.local/share}/man/man1/taskopen.1" \
        https://raw.githubusercontent.com/jschlatow/taskopen/v1.2-devel/doc/man/taskopen.1
    curl -sSLo "${XDG_DATA_HOME:-~/.local/share}/man/man5/taskopen.5" \
        https://raw.githubusercontent.com/jschlatow/taskopen/v1.2-devel/doc/man/taskopenrc.5
}

install_git_jump
# install_git_extras

# install_rust
# install_nim
# install_golang
# install_volta

install_node_packages
install_pip_packages
install_cargo_packages
install_golang_packages
