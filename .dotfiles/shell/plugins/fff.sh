#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# fff - https://github.com/dylanaraps/fff
# -----------------------------------------------------------------------------

ff() {
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")" || return
}

export FFF_FAV1=~/dev/work/calcite-components
export FFF_FAV2=~/dev/personal/dotfiles
export FFF_FAV3=~/Documents/lists
export FFF_FAV4=/usr/share
export FFF_FAV5=/.dotfiles/shell/functions.bash
export FFF_FAV6=~/.dotfiles/shell/aliases/general.alias.sh
export FFF_FAV7=~/.bashrc
export FFF_FAV8=~/.vimrc
export FFF_FAV9=~/.config/nvim/init.lua
