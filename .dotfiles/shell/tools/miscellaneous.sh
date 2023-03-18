#!/usr/bin/env bash
# shellcheck disable=1090

# cargo - https://github.com/rust-lang/cargo
[ -r ~/.cargo/env ] && [ -f ~/.cargo/env ] && source ~/.cargo/env

# broot - https://github.com/Canop/broot
[[ "$(type -P broot)" ]] && source ~/.config/broot/launcher/bash/br

# thefuck - https://github.com/nvbn/thefuck
[[ "$(type -P thefuck)" ]] && eval "$(thefuck --alias)"

# navi - https://github.com/denisidoro/navi
[[ "$(type -P navi)" ]] && eval "$(navi widget bash)"

# https://github.com/dylanaraps/fff
ff() {
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")" || return
}
export FFF_FAV1=~/dev/work/calcite-components
export FFF_FAV2=~/dev/work/arcgis-esm-samples/
export FFF_FAV3=~/Documents/lists
export FFF_FAV4=/usr/share
export FFF_FAV5=/.dotfiles/shell/functions.bash
export FFF_FAV6=~/.dotfiles/shell/aliases/general.alias.sh
export FFF_FAV7=~/.bashrc
export FFF_FAV8=~/.vimrc
export FFF_FAV9=~/.config/nvim/init.lua

# nnn - https://github.com/jarun/nnn
export NNN_FCOLORS="0404040000000600010F0F02"
export NNN_PLUG='f:finder;o:fzopen;d:diffs;z:autojump'
