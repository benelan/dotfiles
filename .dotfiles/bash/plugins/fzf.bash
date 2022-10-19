#!/usr/bin/env bash


# Fuzzy search
# https://github.com/junegunn/fzf

if [ -r "$HOME/.fzf.bash" ] ; then
  source "$HOME/.fzf.bash"
elif [ -r "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ] ; then
  source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash
fi

# No need to continue if the command is not present
_command_exists fzf || return

if [ -z ${FZF_DEFAULT_COMMAND+x}  ] && _command_exists fd ; then
  export FZF_DEFAULT_COMMAND='fd --type f'
fi

fe() {
  about "Open the selected file in the default editor"
  group "fzf"
  param "1: Search term"
  example "fe foo"

  local IFS=$'\n'
  local files
  files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && "${EDITOR:-vim}" "${files[@]}"
}

fcd() {
  about "cd to the selected directory"
  group "fzf"
  param "1: Directory to browse, or . if omitted"
  example "fcd aliases"

  local dir
  dir="$(find "${1:-.}" -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m)" &&
  cd "$dir" || return
}
