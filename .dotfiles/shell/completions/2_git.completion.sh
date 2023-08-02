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

# enable git completion for "g", "d", and "dot", and aliases
__git_complete g git
__git_complete d git
__git_complete dot git

# alias for `git-mux task` - https://github.com/benelan/git-mux
__git_complete gxt git_checkout
