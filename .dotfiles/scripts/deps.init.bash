#!/usr/bin/env bash

# This script installs the distro-agnostic tools I use
# The script uses Cargo and Go to install binaries
# If on Ubuntu/Debian, I recommend running deps-apt.init.bash first

FONTS_DIR="$HOME/.local/share/fonts"

# add any other zipped fonts to download and install
# NerdFonts are required for Starship and LunarVim
# Find more options here: https://www.nerdfonts.com/font-downloads
fonts=(
    https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Iosevka.zip
    https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/SourceCodePro.zip
)

if [[ $(find "$FONTS_DIR" -iname '*Nerd Font*' | wc -l) -lt 5 ]]; then
    echo "Installing fonts"
    mkdir -p "$FONTS_DIR"
    for f in "${fonts[@]}"; do
        curl -sS "$f" >"$FONTS_DIR/file.zip"
        unzip "$FONTS_DIR/file.zip"
        rm "$FONTS_DIR/file.zip"
    done
    # reload the font cache
    fc-cache -rf
fi

unset f
unset fonts

if [[ ! "$(type -P cargo)" ]]; then
    echo "-> Installing Cargo packages"

    # https://github.com/BurntSushi/ripgrep
    [[ ! "$(type -P rg)" ]] && cargo install ripgrep && echo "--> Installed ripgrep"

    # https://github.com/sharkdp/fd
    [[ ! "$(type -P fd)" && "$(type -P make)" ]] && cargo install fd-find && echo "--> Installed fd-find"

    # https://github.com/sharkdp/bat
    ! [[ "$(type -P bat)" || "$(type -P batcat)" ]] && cargo install --locked bat && echo "--> Installed bat"

    # https://github.com/dandavison/delta
    [[ ! "$(type -P delta)" ]] && cargo install git-delta && echo "--> Installed git-delta"

    # https://github.com/anordal/shellharden
    [[ ! "$(type -P shellharden)" ]] && cargo install shellharden && echo "--> Installed shellharden"

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

if [[ "$(type -P go)" ]]; then
    echo "-> Installing Go packages"
    # https://github.com/jesseduffield/lazygit
    [[ ! "$(type -P lazygit)" ]] && go install github.com/jesseduffield/lazygit@latest && echo "--> Installed LazyGit"

    # https://github.com/rhysd/actionlint
    [[ ! "$(type -P actionlint)" ]] && go install github.com/rhysd/actionlint/cmd/actionlint@latest && echo "--> Installed ActionLint"

    https://github.com/mvdan/sh
    [[ ! "$(type -P shfmt)" ]] && go install mvdan.cc/sh/v3/cmd/shfmt@latest && echo "--> Installed shfmt"
else
    echo "-> Unable to install Go packages. Install Golang and try again:"
    echo "-> https://go.dev/doc/install"
fi

# Install volta if necessary
if [[ ! "$VOLTA_HOME" ]]; then
    curl https://get.volta.sh | bash -s -- --skip-setup
    export VOLTA_HOME=~/.volta
    grep --silent "$VOLTA_HOME/bin" <<<"$PATH" || export PATH="$VOLTA_HOME/bin:$PATH"
    volta install node yarn
    echo "--> Install Volta to manage node/npm/yarn"
    volta install neovim prettier eslint stylelint pm2 build-sizes typescript
    echo "--> Installed global npm packages"
fi

# Install Starship if necessary
if [[ ! "$(type -P starship)" ]]; then
    sh <(curl -sS https://starship.rs/install.sh) --yes --bin-dir="$HOME/.bin" >/dev/null
    echo "--> Installed Starship"
fi

# use lazygit binary if go isn't installed
if [[ ! "$(type -P go)" && ! "$(type -P lazygit)" ]]; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v*([^"]+)".*/\1/')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    sudo tar xf lazygit.tar.gz -C "$HOME/local/bin" lazygit
    unset LAZYGIT_VERSION
    echo "--> Installed LazyGit"
fi
