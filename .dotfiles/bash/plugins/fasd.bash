#!/usr/bin/env bash
# shellcheck disable=1090

# fasd - https://github.com/clvv/fasd
function fasd() {
    local fasd=~/.dotfiles/bash/lib/fasd.bash
    [ -r "$fasd" ] && [ -f "$fasd" ] && source "$fasd"
}

fasd_cache=~/.dotfiles/cache/fasd_startup
if [ ! -s "$fasd_cache" ]; then
    fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >|"$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache
