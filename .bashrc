#!/usr/bin/env bash
# shellcheck disable=1090

# ~/.bashrc: executed by bash(1) for non-login shells.
# See /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

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

# Then start sourcing startup scripts from ~/.dotfiles/shell

# SHELL- ALIASES/FUNCTIONS                                              {{{
# --------------------------------------------------------------------- {|}

[ -r ~/.dotfiles/shell/aliases.sh ] && . ~/.dotfiles/shell/aliases.sh
[ -r ~/.dotfiles/shell/functions.sh ] && . ~/.dotfiles/shell/functions.sh

# shellcheck disable=2128
[ -n "$BASH_VERSINFO" ] || return   # Check version array exists (>=2.0)
((BASH_VERSINFO[0] >= 3)) || return # Check actual major version number

# --------------------------------------------------------------------- }}}
# BASH - OPTIONS/PROMPT                                                 {{{
# --------------------------------------------------------------------- {|}

# Add any environment-specific stuff to local.sh (it's gitignored).
# The source order matters!
for stuffs in ~/.dotfiles/shell/{options,prompt,tools,local}.sh; do
    [ -r "$stuffs" ] && . "$stuffs"
done
unset stuffs

# --------------------------------------------------------------------- }}}
# BASH - COMPLETIONS                                                    {{{
# --------------------------------------------------------------------- {|}

# The completions are sourced alphabetically so a number
# from 1-9 can be prepended to filenames to ensure an order.
# Prepend 0_ to file names to skip them.

# Completions go last because some require their tools/plugins
# to have already loaded
# shellcheck disable=1001
for completions in ~/.dotfiles/shell/completions/[!\0]*.sh; do
    [ -r "$completions" ] && . "$completions"
done
unset completions

# --------------------------------------------------------------------- }}}
# TMUX - ATTACH                                                         {{{
# --------------------------------------------------------------------- {|}

# ensure tmux is running
[ -z "$TMUX" ] && is-supported git-mux && git-mux project "$PWD"

# --------------------------------------------------------------------- }}}
