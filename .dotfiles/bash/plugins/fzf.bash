#!/usr/bin/env bash
# shellcheck disable=1090

# Fuzzy search
# https://github.com/junegunn/fzf
is-supported fzf || return

# Auto-completion
# ---------------
[[ $- == *i* ]] &&
    source "$HOME/.dotfiles/vendor/fzf/shell/completion.bash" 2>/dev/null

# Key bindings
# ------------
[ -f "$HOME/.dotfiles/vendor/fzf/shell/key-bindings.bash" ] &&
    source "$HOME/.dotfiles/vendor/fzf/shell/key-bindings.bash"

# Settings
# --------
is-supported fd &&
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

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
