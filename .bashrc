#!/usr/bin/env bash
# shellcheck disable=1090
# ~/.bashrc: executed by bash(1) for non-login shells.

# Make sure the shell is interactive                                    {{{
# --------------------------------------------------------------------- {|}

case $- in
    *i*) ;;
    *) return ;;
esac

# Don't do anything if restricted. Testing whether $- contains 'r' doesn't
# work, because Bash doesn't set that flag until after .bashrc has evaluated.
! shopt -q restricted_shell 2>/dev/null || return

# --------------------------------------------------------------------- }}}
# Source shell aliases and functions                                    {{{
# --------------------------------------------------------------------- {|}

[ -r ~/.dotfiles/shell/aliases.sh ] && . ~/.dotfiles/shell/aliases.sh
[ -r ~/.dotfiles/shell/functions.sh ] && . ~/.dotfiles/shell/functions.sh

# shellcheck disable=2128
[ -n "$BASH_VERSINFO" ] || return   # Check version array exists (>=2.0)
((BASH_VERSINFO[0] >= 3)) || return # Check actual major version number

# --------------------------------------------------------------------- }}}
# Source bash options, prompt, and local settings                       {{{
# --------------------------------------------------------------------- {|}

# Add any environment-specific stuff to local.sh (it's gitignored).
# The source order for the following scripts matters!
for file in ~/.dotfiles/shell/{options,prompt,local}.sh; do
    [ -r "$file" ] && . "$file"
done
unset file

# --------------------------------------------------------------------- }}}
# Source tool shell integrations                                        {{{
# --------------------------------------------------------------------- {|}

is-supported broot && [ -f ~/.config/broot/launcher/bash/br ] &&
    . ~/.config/broot/launcher/bash/br

if is-supported fzf; then
    [ -f ~/dev/lib/fzf/shell/completion.bash ] &&
        . ~/dev/lib/fzf/shell/completion.bash
    [ -f ~/dev/lib/fzf/shell/key-bindings.bash ] &&
        . ~/dev/lib/fzf/shell/key-bindings.bash
fi

# --------------------------------------------------------------------- }}}
# Source bash completions                                               {{{
# --------------------------------------------------------------------- {|}

# The completions are sourced alphabetically so a number
# from 1-9 can be prepended to filenames to ensure an order.
# Prepend 0_ to file names to skip them.

# Completions go last because some require their tools/plugins
# to have already loaded
# shellcheck disable=1001
for file in ~/.dotfiles/shell/completions/[!\0]*.sh; do
    [ -r "$file" ] && . "$file"
done
unset file

# --------------------------------------------------------------------- }}}
# Attach to tmux                                                        {{{
# --------------------------------------------------------------------- {|}

# ensure tmux is running
[ -z "$TMUX" ] && is-supported git-mux && git-mux project "$PWD"

# --------------------------------------------------------------------- }}}
