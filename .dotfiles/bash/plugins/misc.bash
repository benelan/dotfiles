#!/usr/bin/env bash

# thefuck - https://github.com/nvbn/thefuck
[[ "$(type -P thefuck)" ]] && eval "$(thefuck --alias)"

# navi - https://github.com/denisidoro/navi
[[ "$(type -P navi)" ]] && eval "$(navi widget bash)"

# broot - https://github.com/Canop/broot
[[ "$(type -P br)" ]] && source ~/.config/broot/launcher/bash/br
