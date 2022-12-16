#!/usr/bin/env bash
# shellcheck disable=1090

# fasd - https://github.com/clvv/fasd
fasd=~/.dotfiles/bash/lib/fasd.bash
[ ! -r "$fasd" ] || [ ! -f "$fasd" ] && return
source "$fasd"

fasd_cache=~/.dotfiles/cache/.fasd_startup
[ ! -s "$fasd_cache" ] && fasd --init \
    posix-alias bash-hook bash-ccomp bash-ccomp-install \
    >|"$fasd_cache"
source "$fasd_cache"

unset fasd fasd_cache

alias ze="f -e nvim"
alias zo="a -e xdg-open"
