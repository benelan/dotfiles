#!/usr/bin/env bash
# shellcheck disable=2046
set -e

# This script installs the tools I use.
# Comment out functions at the bottom to skip sections.

FONTS_DIR="$HOME/.local/share/fonts"
BIN_DIR="$HOME/.local/bin"
DEPS_DIR="$HOME/.dotfiles/deps"
mkdir -p "$FONTS_DIR" "$BIN_DIR"

# Install The four common font weights
# https://github.com/ryanoasis/nerd-fonts
install_fonts_minimal() {
    # Iosevka
    curl -sSLo "$FONTS_DIR/IosevkaNerdFont-Bold.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Bold/IosevkaNerdFont-Bold.ttf
    curl -sSLo "$FONTS_DIR/IosevkaNerdFont-BoldItalic.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Bold-Italic/IosevkaNerdFont-BoldItalic.ttf
    curl -sSLo "$FONTS_DIR/IosevkaNerdFont-Regular.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Regular/IosevkaNerdFont-Regular.ttf
    curl -sSLo "$FONTS_DIR/IosevkaNerdFont-Italic.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Italic/IosevkaNerdFont-Italic.ttf

    # reload the font cache
    fc-cache -rf
}

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
    if [ -f "$DEPS_DIR/cargo" ]; then
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
    fi
}

# Install global Node packages
# https://www.npmjs.com
install_node_packages() {
    if [ -f "$DEPS_DIR/node" ]; then
        if ! is-supported volta && ! is-supported node; then
            install_volta # only works on x86_64 architectures for now
        fi
        npm install -g $(cat "$DEPS_DIR/node")
    fi
}

# Install Go CLI tools
# https://pkg.go.dev
install_golang_packages() {
    if [ -f "$DEPS_DIR/golang" ]; then
        if ! is-supported go; then
            install_golang
        fi
        while IFS="" read -r pkg || [ -n "$pkg" ]; do
            go install "$pkg"
        done <"$DEPS_DIR/golang"
        unset pkg
    fi
}

# Install Python CLI tools
# https://pypi.org/project/pipx
install_pip_packages() {
    if [ -f "$DEPS_DIR/pip" ]; then
        while IFS="" read -r pkg || [ -n "$pkg" ]; do
            pip3 install --user "$pkg"
        done <"$DEPS_DIR/pip"
        unset pkg
    fi
}

# Install helpful bash scripts for git workflows
# https://github.com/tj/git-extras
install_git_extras() {
    curl -sSL https://raw.githubusercontent.com/tj/git-extras/master/install.sh | sudo bash /dev/stdin
}

install_git_jump() {
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
        curl -sSLo ~/.dotfiles/bin/git-jump \
            https://raw.githubusercontent.com/git/git/master/contrib/git-jump/git-jump
    fi
    chmod +x "$BIN_DIR/git-jump"
}


install_fonts_minimal
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
