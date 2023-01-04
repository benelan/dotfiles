#!/bin/sh

NEOVIM_REPO="$HOME/.dotfiles/vendor/neovim"
FZF_REPO="$HOME/.dotfiles/vendor/fzf"

dot submodule update --init --recursive
dot submodule foreach git pull

[[ -d "$FZF_REPO" ]] && "$FZF_REPO/install" \
    --bin --key-bindings --completion --no-update-rc

if [[ -d "$NEOVIM_REPO" ]]; then
    cd "$NEOVIM_REPO" || return
    make CMAKE_BUILD_TYPE=Release
    sudo make install
    chmod +x "$NEOVIM_REPO/build/bin/nvim"
fi
