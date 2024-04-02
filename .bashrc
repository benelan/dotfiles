#!/usr/bin/env bash
# shellcheck disable=1090
# ~/.bashrc: executed by bash(1) for non-login shells.

# Make sure the shell is interactive {{{1
case $- in
    *i*) ;;
    *) return ;;
esac

# Don't do anything if restricted. Testing whether $- contains 'r' doesn't
# work, because Bash doesn't set that flag until after .bashrc has evaluated.
! shopt -q restricted_shell 2>/dev/null || return

# Source shell aliases and functions {{{1
[ -r ~/.dotfiles/shell/aliases.sh ] && . ~/.dotfiles/shell/aliases.sh
[ -r ~/.dotfiles/shell/functions.sh ] && . ~/.dotfiles/shell/functions.sh

# shellcheck disable=2128
[ -n "$BASH_VERSINFO" ] || return   # Check version array exists (>=2.0)
((BASH_VERSINFO[0] >= 3)) || return # Check actual major version number

# Source bash options, prompt, completion, and local settings {{{1
# Add any environment-specific stuff to local.sh (it's gitignored).
# The source order matters!
for file in ~/.dotfiles/shell/{options,prompt,completion,local}.sh; do
    [ -r "$file" ] && . "$file"
done
unset file

# Setup miscellaneous tools and integrations {{{1
# setup broot shell integration so `cd` works
[ -r ~/.config/broot/launcher/bash/br ] && . ~/.config/broot/launcher/bash/br

# ensure tmux is running
[ -z "$TMUX" ] && supports git-mux && git-mux project "$PWD"
