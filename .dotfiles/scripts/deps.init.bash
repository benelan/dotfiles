#!/usr/bin/env bash

# This script installs the distro-agnostic tools I use
# The script uses Cargo and Go to build/install binaries
# If on Ubuntu/Debian, I recommend running deps-apt.init.bash first

FONTS_DIR="$HOME/.local/share/fonts"

# Installs The four common font weights
function install_fonts() {
    mkdir -p "$FONTS_DIR"
    cd "$FONTS_DIR" || return
    echo "Installing fonts"
    # Iosevka
    wget "Iosevka Bold Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Bold/complete/Iosevka%20Bold%20Nerd%20Font%20Complete.ttf
    wget "Iosevka Bold Italic Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Bold-Italic/complete/Iosevka%20Bold%20Italic%20Nerd%20Font%20Complete.ttf
    wget "Iosevka Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Regular/complete/Iosevka%20Nerd%20Font%20Complete.ttf
    wget "Iosevka Italic Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Italic/complete/Iosevka%20Italic%20Nerd%20Font%20Complete.ttf
    # Jet Brains Mono
    wget "JetBrainsMono Bold Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Bold/complete/JetBrains%20Mono%20Bold%20Nerd%20Font%20Complete.ttf
    wget "JetBrainsMono Bold Italic Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/BoldItalic/complete/JetBrains%20Mono%20Bold%20Italic%20Nerd%20Font%20Complete.ttf
    wget "JetBrainsMono Regular Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete.ttf
    wget "JetBrainsMono Italic Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Italic/complete/JetBrains%20Mono%20Italic%20Nerd%20Font%20Complete.ttf
    # Sauce Code Pro
    wget "SauceCodePro Bold Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Bold/complete/Sauce%20Code%20Pro%20Bold%20Nerd%20Font%20Complete.ttf
    wget "SauceCodePro Bold Italic Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Bold-Italic/complete/Sauce%20Code%20Pro%20Bold%20Italic%20Nerd%20Font%20Complete.ttf
    wget "SauceCodePro Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf
    wget "SauceCodePro Italic Nerd Font Complete.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Italic/complete/Sauce%20Code%20Pro%20Italic%20Nerd%20Font%20Complete.ttf
    # reload the font cache
    fc-cache -rf
}

# installs the full font family from zip files
function install_fonts_full_family() {
    mkdir -p "$FONTS_DIR"
    # add any other zipped fonts to download and install
    # NerdFont glyphs are used by Starship and NeoVim
    # Find more options here: https://www.nerdfonts.com/font-downloads
    fonts=(
        https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/JetBrainsMono.zip
        https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Iosevka.zip
        https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/SourceCodePro.zip
    )
    echo "Installing full font families"
    mkdir -p "$FONTS_DIR"
    for f in "${fonts[@]}"; do
        curl -sS "$f" >"$FONTS_DIR/nerd.zip"
        unzip "$FONTS_DIR/nerd.zip"
        rm "$FONTS_DIR/nerd.zip"
    done
    # reload the font cache
    fc-cache -rf
    unset f
    unset fonts
}

function install_cargo_packages() {
    if [[ ! "$(type -P cargo)" ]]; then
        echo "-> Installing Cargo packages"

        # https://github.com/BurntSushi/ripgrep
        [[ ! "$(type -P rg)" ]] &&
            cargo install ripgrep &&
            echo "--> Installed ripgrep"

        # https://github.com/sharkdp/fd
        [[ ! "$(type -P fd)" && "$(type -P make)" ]] &&
            cargo install fd-find &&
            [[ ! "$(type -P fd)" ]] &&
            ln -s "$(type -P fdfind)" ~/.local/bin/fd &&
            echo "--> Installed fd-find"

        # https://github.com/sharkdp/bat
        ! [[ "$(type -P bat)" || "$(type -P batcat)" ]] &&
            cargo install --locked bat &&
            [[ ! "$(type -P bat)" ]] &&
            ln -s "$(type -P batcat)" ~/.local/bin/bat &&
            echo "--> Installed bat"

        # https://github.com/dandavison/delta
        [[ ! "$(type -P delta)" ]] &&
            cargo install git-delta &&
            echo "--> Installed git-delta"

        # https://github.com/anordal/shellharden
        [[ ! "$(type -P shellharden)" ]] &&
            cargo install shellharden &&
            echo "--> Installed shellharden"

        # Install LunarVim if necessary and able
        # https://www.lunarvim.org/docs/installation
        # if [[ ! "$(type -P lvim)" && ("$(type -P pip)" && "$(type -P make)" && "$(type -P node)" && "$(type -P npm)" && "$(type -P nvim)") ]]; then
        #   bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) --install-dependencies --yes
        #   echo "--> Installed LunarVim"
        # else
        #   echo "--> Unable to install LunarVim. Make sure all of the required dependencies are installed."
        #   echo "--> https://www.lunarvim.org/docs/installation#prerequisites"
        # fi
    else
        echo "-> Unable to install Cargo packages. Install Rust and try again:"
        echo "-> https://www.rust-lang.org/tools/install"
    fi
}

function install_go_packages() {
    if [[ "$(type -P go)" ]]; then
        echo "-> Installing Go packages"

        # https://github.com/jesseduffield/lazygit
        [[ ! "$(type -P lazygit)" ]] &&
            go install github.com/jesseduffield/lazygit@latest &&
            echo "--> Installed LazyGit"

        # https://github.com/rhysd/actionlint
        [[ ! "$(type -P actionlint)" ]] &&
            go install github.com/rhysd/actionlint/cmd/actionlint@latest &&
            echo "--> Installed ActionLint"

        # https://github.com/mvdan/sh
        [[ ! "$(type -P shfmt)" ]] &&
            go install mvdan.cc/sh/v3/cmd/shfmt@latest &&
            echo "--> Installed shfmt"
    else
        # use lazygit binary if go isn't installed
        if [[ ! "$(type -P go)" && ! "$(type -P lazygit)" ]]; then
            LAZYGIT_VERSION=$(
                curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" |
                    grep '"tag_name":' |
                    sed -E 's/.*"v*([^"]+)".*/\1/'
            )
            curl -Lo lazygit.tar.gz \
                "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
            sudo tar xf lazygit.tar.gz -C "$HOME/local/bin" lazygit
            unset LAZYGIT_VERSION
            echo "--> Installed LazyGit"
        fi
        echo "-> Unable to install Go packages. Install Golang and try again:"
        echo "-> https://go.dev/doc/install"
    fi
}

# Install volta and global npm packages
function install_node_packages() {
    if [[ ! "$VOLTA_HOME" ]]; then
        curl https://get.volta.sh | bash -s -- --skip-setup
        export VOLTA_HOME=~/.volta
        grep --silent "$VOLTA_HOME/bin" <<<"$PATH" || export PATH="$VOLTA_HOME/bin:$PATH"
        volta install node@16
        echo "--> Install Volta to manage node/npm/yarn"
        volta install pm2 prettier eslint stylelint build-sizes \
            neovim typescript ts-node markdownlint markdownlint-cli
        echo "--> Installed global npm packages"
    fi
}

# Install Starship
function install_starship_prompt() {
    if [[ ! "$(type -P starship)" ]]; then
        sh <(curl -sS https://starship.rs/install.sh) --yes --bin-dir="$HOME/.local/bin" >/dev/null
        echo "--> Installed Starship"
    fi
}

install_fonts
install_cargo_packages
install_go_packages
install_starship_prompt
