#!/usr/bin/env bash

eval "$(thefuck --alias)"


fasd_cache="$HOME/.dotfiles/cache/fasd"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
fi
. "$fasd_cache"
unset fasd_cache


function ff() {
  local fff=~/.dotfiles/bash/lib/fff.bash
  [ -r "$fff" ] && [ -f "$fff" ] && source "$fff"
}