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

# Install the full font families from zip files
install_fonts_full() {
    # Add any other zipped fonts to download and install
    # NerdFont glyphs are used by a lot of tools, e.g. Starship and NeoVim
    # Find more options here: https://www.nerdfonts.com/font-downloads
    font_families=(
        https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.1/JetBrainsMono.zip
        https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.1/Iosevka.zip
        https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.1/SourceCodePro.zip
    )
    for f in "${font_families[@]}"; do
        curl -sS "$f" >"$FONTS_DIR/font.zip"
        unzip "$FONTS_DIR/font.zip"
        rm "$FONTS_DIR/font.zip"
    done
    # reload the font cache
    fc-cache -rf
    unset f font_families
}

install_gnome_theme() {
    if [[ "$(os-detect)" =~ "linux_pop" ]]; then
        cd ~/dev/lib
        # download gruvbox gnome theme and icons
        git clone --depth=1 https://github.com/SylEleuth/gruvbox-plus-icon-pack.git
        git clone --depth=1 https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme.git
        curl -sSLO https://limitland.gitlab.io/flatbedcursors/FlatbedCursors-0.5.2.tar.bz2
        extract FlatbedCursors-0.5.2.tar.bz2

        # move icons and themes to the proper locations
        mkdir -p ~/.icons/FlatbedCursors-Orange/ ~/.icons/Gruvbox-Plus-Dark ~/.themes/Gruvbox-Dark-BL
        cp -r ~/dev/lib/gruvbox-plus-icon-pack/Gruvbox-Plus-Dark/* ~/.icons/Gruvbox-Plus-Dark
        cp -r ~/dev/lib/Gruvbox-GTK-Theme/themes/Gruvbox-Dark-BL/* ~/.themes/Gruvbox-Dark-BL
        cp -r FlatbedCursors-Orange/* ~/.icons/FlatbedCursors-Orange/

        # remove the repos because they are yuuge
        rm -rf gruvbox-plus-icon-pack Gruvbox-GTK-Theme FlatbedCursors*
    fi
}

# Install the Rust language
# https://www.rust-lang.org/tools/install
install_rust() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    pathappend "$HOME/.cargo/bin"
}

# Install the Go language
# https://go.dev/doc/install
install_golang() {
    # checksum will need to be updated when using a new go version
    checksum="c9c08f783325c4cf840a94333159cc937f05f75d36a8b307951d5bd959cf2ab8"
    outfile="go1.19.4.linux-amd64.tar.gz"
    curl -L "https://go.dev/dl/$outfile" -o "$outfile"
    if [ "$(shasum -a 256 "$outfile" | awk '{print $1}')" = "$checksum" ]; then
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf "$outfile"
        rm "$outfile"
        pathappend /usr/local/go/bin
    else
        printf "\nchecksum does not match, please install golang manually:\nhttps://go.dev/doc/install"
    fi
}

# Install Volta for managing Node/NPM
# https://docs.volta.sh/guide/getting-started
install_volta() {
    curl https://get.volta.sh | bash -s -- --skip-setup
    export VOLTA_HOME=~/.volta
    pathappend "$VOLTA_HOME/bin"
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
        if is-supported volta; then
            volta install $(cat "$DEPS_DIR/node")
        else
            if ! is-supported node; then
                install_volta # only works on x86_64 architectures for now
            fi
            npm install -g $(cat "$DEPS_DIR/node")
        fi
    fi
}

# Install Go CLI tools
# https://pkg.go.dev
install_go_packages() {
    if [ -f "$DEPS_DIR/golang" ]; then
        if ! is-supported go; then
            install_go
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
        is-supported pipx && pipx="pipx install"

        while IFS="" read -r pkg || [ -n "$pkg" ]; do
            ${pipx:-pip install --user} "$pkg"
        done <"$DEPS_DIR/pip"

        if [ -z "$pipx" ]; then
            pipx upgrade-all
        fi
        unset pkg pipx
    fi
}

# Install Starship prompt
# https://starship.rs/guide
install_starship() {
    if ! is-supported starship; then
        sh <(curl -sS https://starship.rs/install.sh) --yes --bin-dir="$BIN_DIR" >/dev/null
    fi
}

# Install helpful bash scripts for git workflows
# https://github.com/tj/git-extras
install_git_extras() {
    curl -sSL https://raw.githubusercontent.com/tj/git-extras/master/install.sh | sudo bash /dev/stdin
}

# install_git_extras
# install_fonts_full
install_fonts_minimal
install_gnome_theme
install_starship
install_node_packages
install_cargo_packages
# install_go_packages
# install_pip_packages
