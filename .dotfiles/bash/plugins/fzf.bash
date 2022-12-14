#!/usr/bin/env bash

# Fuzzy search
# https://github.com/junegunn/fzf

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.dotfiles/vendor/fzf/shell/completion.bash" 2>/dev/null

# Key bindings
# ------------
[ -r "$HOME/.dotfiles/vendor/fzf/shell/key-bindings.bash" ] && source "$HOME/.dotfiles/vendor/fzf/shell/key-bindings.bash"

# No need to continue if the command is not present
is-supported fzf || return

if [ -z ${FZF_DEFAULT_COMMAND+x} ] && is-supported fd; then
    export FZF_DEFAULT_COMMAND='fd --type f'
fi

# Open the selected file in the default editor
fe() {
    local files
    while IFS='' read -r line; do
        files+=("$line")
    done < <(fzf-tmux --query="$1" --multi --select-1 --exit-0)
    # mapfile -t files < <(fzf-tmux --query="$1" --multi --select-1 --exit-0)
    # files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
    [[ -n "${files[0]}" ]] && "${EDITOR:-vim}" "${files[@]}"
}

# cd to the selected directory
fcd() {
    local dir
    dir="$(find "${1:-.}" -path '*/\.*' -prune \
        -o -type d -print 2>/dev/null | fzf +m)" &&
        cd "$dir" || return
}
