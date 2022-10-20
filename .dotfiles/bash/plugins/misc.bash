#!/usr/bin/env bash

function ff() {
  local fff=~/.dotfiles/bash/lib/fff.bash
  [ -r "$fff" ] && [ -f "$fff" ] && source "$fff"
}

function fasd() {
  local fasd=~/.dotfiles/bash/lib/fasd.bash
  [ -r "$fasd" ] && [ -f "$fasd" ] && source "$fasd"
}

fasd_cache=~/.dotfiles/cache/fasd
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
fi
. "$fasd_cache"
unset fasd_cache



[[ "$(command -v thefuck)" ]] && eval "$(thefuck --alias)"