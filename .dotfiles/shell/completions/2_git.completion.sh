#!/usr/bin/env bash

if [ -f /usr/share/bash-completion/completions/git ] && [ -r /usr/share/bash-completion/completions/git ]; then
    source /usr/share/bash-completion/completions/git
elif [ -f /etc/bash_completion.d/git ] && [ -r /etc/bash_completion.d/git ]; then
    source /etc/bash_completion.d/git
elif [ -f ~/.dotfiles/cache/git-completion.bash ] && [ -r ~/.dotfiles/cache/git-completion.bash ]; then
    source ~/.dotfiles/cache/git-completion.bash
else
    curl -sSLo ~/.dotfiles/cache/git-completion.bash \
        https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
    source ~/.dotfiles/cache/git-completion.bash
fi

# Git Alias Completion
# -----------------------------------------------------------------------------

# enable git completion for "g" and "dot" aliases
__git_complete g git
__git_complete dot git