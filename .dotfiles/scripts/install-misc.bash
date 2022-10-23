#!/usr/bin/env bash
FONTS_DIR="$HOME/.local/share/fonts"
DOTFILES="$HOME/.dotfiles"

# Install Alacritty if it isn't already installed, and all of the preqs are installed
if [[ ! "$(type -P alacritty)" && ("$(type -P python)" && "$(type -P cargo)" && "$(type -P cmake)" && "$(type -P pkg-config)" && "$(type -P libfreetype6-dev)" && "$(type -P libxcb-xfixes0-dev)" && "$(type -P libxkbcommon)") ]]; then
  echo "Installing Alacritty"

  cd "$DOTFILES"/vendor/alacritty || return
  cargo build --release
  # Add Terminfo if necessary
  if [[ ! "$(infocmp alacritty)" ]]; then sudo tic -xe alacritty,alacritty-direct extra/alacritty.info; fi
  # Add Desktop Entry
  sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database
else
  echo "Unable to install Alacritty from source. Make sure all of the required dependencies are installed, or choose a different installation method."
  echo "https://github.com/alacritty/alacritty/blob/master/INSTALL.md#install-the-rust-compiler-with-rustup"
fi

# Install volta if necessary
if [[ ! "$VOLTA_HOME" ]]; then
  echo "Installing Volta to manage node/yarn/tsc"
  curl https://get.volta.sh | bash -s -- --skip-setup
  export VOLTA_HOME=~/.volta
  grep --silent "$VOLTA_HOME/bin" <<<"$PATH" || export PATH="$VOLTA_HOME/bin:$PATH"
  volta install node
  volta install yarn
  volta install tsc
fi

# Install LunarVim if necessary and able
# https://www.lunarvim.org/docs/installation
if [[ ! "$(type -P lvim)" && ("$(type -P pip)" && "$(type -P cargo)" && "$(type -P make)" && "$(type -P node)" && "$(type -P npm)" && "$(type -P nvim)") ]]; then
  echo "Installing LunarVim"
  bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) --install-dependencies --yes
else
  echo "Unable to install LunarVim. Make sure all of the required dependencies are installed."
  echo "https://www.lunarvim.org/docs/installation#prerequisites"
fi

# Install Starship if necessary
if [[ ! "$(type -P starship)" ]]; then
  echo "Installing Starship"
  sh <(curl -sS https://starship.rs/install.sh) --yes --bin-dir="$HOME/.bin" >/dev/null
fi



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
    curl -sS "$f" > "$FONTS_DIR/file.zip"
    unzip "$FONTS_DIR/file.zip"
    rm "$FONTS_DIR/file.zip"
  done
                    
  # reload the font cache
  fc-cache -rf
fi

unset f
unset fonts


# https://github.com/dandavison/delta
if [[ "$(type -P cargo)" && ! "$(delta)" ]]; then
  echo "Installing delta for git diffs"
  cargo install git-delta
fi


# https://github.com/jesseduffield/lazygit
if [[ ! "$(type -P lazygit)" ]]; then
  echo "Installing lazygit"
  if [[ "$(type -P go)" ]]; then 
    go install github.com/jesseduffield/lazygit@latest
  else
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v*([^"]+)".*/\1/')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    sudo tar xf lazygit.tar.gz -C "$HOME/local/bin" lazygit
    unset LAZYGIT_VERSION
  fi
fi