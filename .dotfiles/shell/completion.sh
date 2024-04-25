#!/usr/bin/env bash
# shellcheck disable=1090,1091

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [[ -z "${BASH_COMPLETION_VERSINFO-}" &&
    ("${BASH_VERSINFO[0]}" -gt 4 ||
    "${BASH_VERSINFO[0]}" -eq 4 && "${BASH_VERSINFO[1]}" -ge 2) ]]; then
    if [ -r /etc/profile.d/bash_completion.sh ]; then
        . /etc/profile.d/bash_completion.sh
    elif [ -r /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -r /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# source bash completion and key bindings for fzf
[ -r ~/dev/lib/fzf/shell/completion.bash ] && . ~/dev/lib/fzf/shell/completion.bash
[ -r ~/dev/lib/fzf/shell/key-bindings.bash ] && . ~/dev/lib/fzf/shell/key-bindings.bash

# Load git completion so it can be applied to aliases
if ! declare -F __git_complete >/dev/null 2>&1; then
    _completion_loader git >/dev/null 2>&1
fi

# enable git completion for "g", "d", and "dot", and aliases
__git_complete g git
__git_complete d git
__git_complete dot git

# branch completion for alias for `git-mux task` from https://github.com/benelan/git-mux
__git_complete gxt git_checkout
__git_complete git-mux git_checkout
