#!/usr/bin/env bash
# shellcheck disable=1090

# broot - https://github.com/Canop/broot
[[ "$(type -P broot)" ]] && source ~/.config/broot/launcher/bash/br

# navi - https://github.com/denisidoro/navi
[[ "$(type -P navi)" ]] && eval "$(navi widget bash)"

# thefuck - https://github.com/nvbn/thefuck
[[ "$(type -P thefuck)" ]] && eval "$(thefuck --alias)"

# cargo - https://github.com/rust-lang/cargo
[ -r ~/.cargo/env ] && [ -f ~/.cargo/env ] && source ~/.cargo/env

# nnn - https://github.com/jarun/nnn
export NNN_FCOLORS="0404040000000600010F0F02"
export NNN_PLUG='f:finder;o:fzopen;d:diffs;z:autojump'

# nvm - https://github.com/nvm-sh/nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
