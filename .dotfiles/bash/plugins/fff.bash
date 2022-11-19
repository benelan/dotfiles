#!/usr/bin/env bash

# fff - https://github.com/dylanaraps/fff
export FFF_FAV1=~/dev/calcite/calcite-components
export FFF_FAV2=~/dev/dotfiles
export FFF_FAV3=~/Documents/lists
export FFF_FAV4=/usr/share
export FFF_FAV5=/.dotfiles/bash/functions.bash
export FFF_FAV6=~/.dotfiles/sh/aliases/general.alias.sh
export FFF_FAV7=~/.bashrc
export FFF_FAV8=~/.vimrc
export FFF_FAV9=~/.config/nvim/init.lua

f() {
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")" || return
}
