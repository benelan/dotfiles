#!/usr/bin/env bash


# Fuzzy search
# https://github.com/junegunn/fzf

[ -r ~/.dotfiles/vendor/fzf/bin/fzf ] && pathprepend ~/.dotfiles/vendor/fzf/bin PATH

# Auto-completion
# ---------------
[[ $- == *i* ]] && source ~/.dotfiles/vendor/fzf/shell/completion.bash 2> /dev/null

# Key bindings
# ------------
[ -r ~/.dotfiles/vendor/fzf/shell/key-bindings.bash ] && source ~/.dotfiles/vendor/fzf/shell/key-bindings.bash


# No need to continue if the command is not present
_command_exists fzf || return

if [ -z ${FZF_DEFAULT_COMMAND+x}  ] && _command_exists fd ; then
  export FZF_DEFAULT_COMMAND='fd --type f'
fi

# Open the selected file in the default editor
fe() {
  local IFS=$'\n'
  local files
  files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && "${EDITOR:-vim}" "${files[@]}"
}

# cd to the selected directory
fcd() {
  local dir
  dir="$(find "${1:-.}" -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m)" &&
  cd "$dir" || return
}