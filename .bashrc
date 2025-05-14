#!/usr/bin/env bash
# vim: foldmethod=marker:
# shellcheck disable=1090,1091
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
[ -r "$DOTFILES/shell/aliases.sh" ] && . "$DOTFILES/shell/aliases.sh"
[ -r "$DOTFILES/shell/functions.sh" ] && . "$DOTFILES/shell/functions.sh"

# shellcheck disable=2128
[ -n "$BASH_VERSINFO" ] || return   # Check version array exists (>=2.0)
((BASH_VERSINFO[0] >= 3)) || return # Check actual major version number

# Source bash options, prompt, completion, and local settings {{{1
# The source order matters!
for file in "$DOTFILES"/shell/{options,prompt,completion}.sh; do
    [ -r "$file" ] && . "$file"
done

# Add any environment-specific stuff to ~/.local.bashrc (it's gitignored).
[ -r ~/.bashrc.local ] && . ~/.bashrc.local

# Setup miscellaneous tools and integrations {{{1
# broot shell integration so `cd` works
[ -r ~/.config/broot/launcher/bash/br ] && . ~/.config/broot/launcher/bash/br

# fzf bash completion and key bindings
[ -r ~/dev/lib/fzf/shell/completion.bash ] && . ~/dev/lib/fzf/shell/completion.bash
[ -r ~/dev/lib/fzf/shell/key-bindings.bash ] && . ~/dev/lib/fzf/shell/key-bindings.bash

# ensure tmux is running in graphical environments (excluding wezterm)
if [ -n "$DISPLAY" ] && [ -z "$SSH_CONNECTION" ] && [ -z "$TMUX" ] && {
    [ -z "$WEZTERM_PANE" ] || [ "$GIT_MUX_MULTIPLEXER" = "tmux" ]
} && supports git-mux; then
    git-mux project "$PWD"
fi
