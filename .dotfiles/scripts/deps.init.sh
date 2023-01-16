#!/usr/bin/env bash

# This script installs the tools I use.
# Comment out functions at the bottom to skip sections.

FONTS_DIR="$HOME/.local/share/fonts"

# Install The four common font weights
# https://github.com/ryanoasis/nerd-fonts
function install_fonts_minimal() {
    mkdir -p "$FONTS_DIR"
    cd "$FONTS_DIR" || return
    # Iosevka
    curl -sSLo "Iosevka Bold Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Bold/complete/Iosevka%20Bold%20Nerd%20Font%20Complete.ttf
    curl -sSLo "Iosevka Bold Italic Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Bold-Italic/complete/Iosevka%20Bold%20Italic%20Nerd%20Font%20Complete.ttf
    curl -sSLo "Iosevka Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Regular/complete/Iosevka%20Nerd%20Font%20Complete.ttf
    curl -sSLo "Iosevka Italic Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Italic/complete/Iosevka%20Italic%20Nerd%20Font%20Complete.ttf
    # Jet Brains Mono
    curl -sSLo "JetBrainsMono Bold Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Bold/complete/JetBrains%20Mono%20Bold%20Nerd%20Font%20Complete.ttf
    curl -sSLo "JetBrainsMono Bold Italic Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/BoldItalic/complete/JetBrains%20Mono%20Bold%20Italic%20Nerd%20Font%20Complete.ttf
    curl -sSLo "JetBrainsMono Regular Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete.ttf
    curl -sSLo "JetBrainsMono Italic Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Italic/complete/JetBrains%20Mono%20Italic%20Nerd%20Font%20Complete.ttf
    # Sauce Code Pro
    curl -sSLo "SauceCodePro Bold Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Bold/complete/Sauce%20Code%20Pro%20Bold%20Nerd%20Font%20Complete.ttf
    curl -sSLo "SauceCodePro Bold Italic Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Bold-Italic/complete/Sauce%20Code%20Pro%20Bold%20Italic%20Nerd%20Font%20Complete.ttf
    curl -sSLo "SauceCodePro Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf
    curl -sSLo "SauceCodePro Italic Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Italic/complete/Sauce%20Code%20Pro%20Italic%20Nerd%20Font%20Complete.ttf
    # reload the font cache
    fc-cache -rf
}

# Install the full font families from zip files
function install_fonts_full() {
    mkdir -p "$FONTS_DIR"
    # Add any other zipped fonts to download and install
    # NerdFont glyphs are used by a lot of tools, e.g. Starship and NeoVim
    # Find more options here: https://www.nerdfonts.com/font-downloads
    local fonts=(
        https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/JetBrainsMono.zip
        https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Iosevka.zip
        https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/SourceCodePro.zip
    )
    mkdir -p "$FONTS_DIR"
    for f in "${fonts[@]}"; do
        curl -sS "$f" >"$FONTS_DIR/nerd.zip"
        unzip "$FONTS_DIR/nerd.zip"
        rm "$FONTS_DIR/nerd.zip"
    done
    unset f
    # reload the font cache
    fc-cache -rf
}

# Install the Rust language
# https://www.rust-lang.org/tools/install
function install_rust() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

# Install the Go language
# https://go.dev/doc/install
function install_golang() {
    # checksum will need to be updated when using a new go version
    checksum="c9c08f783325c4cf840a94333159cc937f05f75d36a8b307951d5bd959cf2ab8"
    outfile="go1.19.4.linux-amd64.tar.gz"
    curl -L "https://go.dev/dl/$outfile" -o "$outfile"
    if [ "$(shasum -a 256 "$outfile" | awk '{print $1}')" = "$checksum" ]; then
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf "$outfile"
        export PATH=$PATH:/usr/local/go/bin
    else
        printf "\nchecksum does not match, please install golang manually:\nhttps://go.dev/doc/install"
    fi
}

# Install Volta for managing Node/NPM
# https://docs.volta.sh/guide/getting-started
function install_volta() {
    if [[ ! "$(type -P volta)" ]]; then
        curl https://get.volta.sh | bash -s -- --skip-setup
        export VOLTA_HOME=~/.volta
        grep --silent "$VOLTA_HOME/bin" <<<"$PATH" || export PATH="$VOLTA_HOME/bin:$PATH"
        volta install node@16
    fi
}

# Install packages for Ubuntu/Debian
# https://manpages.ubuntu.com/manpages/jammy/man8/apt.8
function install_apt_packages() {
    # shellcheck disable=2046
    sudo apt install $(cat "$HOME/.dotfiles/deps/apt")
}
function install_apt_gui_packages() {
    # shellcheck disable=2046
    sudo apt install $(cat "$HOME/.dotfiles/deps/apt-gui")
}

# Install Rust CLI tools
# https://crates.io
function install_cargo_packages() {
    # shellcheck disable=2046
    cargo install --locked $(cat "$HOME/.dotfiles/deps/cargo")
}

# Install global Node packages
# https://www.npmjs.com
function install_node_packages() {
    if [ "$(type -P volta)" ]; then
        # shellcheck disable=2046
        volta install $(cat "$HOME/.dotfiles/deps/node")
    else
        # shellcheck disable=2046
        npm install -g $(cat "$HOME/.dotfiles/deps/node")
    fi
}

# Install Go CLI tools
# https://pkg.go.dev
function install_go_packages() {
    while IFS="" read -r pkg || [ -n "$pkg" ]; do
        go install "$pkg"
    done <"$HOME/.dotfiles/deps/golang"
    unset pkg
}

# Install Python CLI tools
# https://pypi.org/project/pipx
function install_pip_packages() {
    [ "$(type -P pipx)" ] && local pipx="pipx"
    while IFS="" read -r pkg || [ -n "$pkg" ]; do
        "${pipx:-"pip"}" install "$pkg"
    done <"$HOME/.dotfiles/deps/pip"
    unset pkg
}

# Install Starship prompt
# https://starship.rs/guide
function install_starship() {
    if [[ ! "$(type -P starship)" ]]; then
        sh <(curl -sS https://starship.rs/install.sh) --yes --bin-dir="$HOME/.local/bin" >/dev/null
    fi
}

# Install helpful bash scripts for git workflows
# https://github.com/tj/git-extras
function install_git_extras() {
    curl -sSL https://raw.githubusercontent.com/tj/git-extras/master/install.sh | sudo bash /dev/stdin
}

# install_fonts_full
install_fonts_minimal
install_apt_packages
install_apt_gui_packages
install_rust
install_golang # only works on x86_64 architectures for now
install_volta  # only works on x86_64 architectures for now
install_cargo_packages
install_go_packages
install_node_packages
install_pip_packages
install_starship
install_git_extras
