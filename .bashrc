#!/usr/bin/env bash
# shellcheck disable=1090

# Make sure the shell is interactive                                    {{{
# --------------------------------------------------------------------- {|}

case $- in
    *i*) ;;
    *) return ;;
esac

# Don't do anything if restricted. Testing
# whether $- contains 'r' doesn't work, because Bash doesn't set that flag
# until after .bashrc has evaluated
! shopt -q restricted_shell 2>/dev/null || return

# --------------------------------------------------------------------- }}}

# Then start sourcing startup scripts from ~/.dotfiles/shell

# SHELL - ALIASES/FUNCTIONS                                             {{{
# --------------------------------------------------------------------- {|}

[ -f ~/.dotfiles/shell/aliases.sh ] && source ~/.dotfiles/shell/aliases.sh
[ -f ~/.dotfiles/shell/functions.sh ] && source ~/.dotfiles/shell/functions.sh

# shellcheck disable=2128
[ -n "$BASH_VERSINFO" ] || return   # Check version array exists (>=2.0)
((BASH_VERSINFO[0] >= 3)) || return # Check actual major version number

# --------------------------------------------------------------------- }}}
# BASH - OPTIONS/PROMPT                                                 {{{
# --------------------------------------------------------------------- {|}

# add any environment-specific stuff to local.sh (it's gitignored)
for stuffs in ~/.dotfiles/shell/{options,prompt,tools,local}.sh; do
    [ -r "$stuffs" ] && [ -f "$stuffs" ] && source "$stuffs"
done
unset stuffs

# --------------------------------------------------------------------- }}}
# BASH - COMPLETIONS                                                    {{{
# --------------------------------------------------------------------- {|}

# the completions are sourced alphabetically so a number
# from 1-9 can be appended to filenames to ensure an order.
# append 0_ to file names to skip them

# completions go last because some require
# their tools/plugins to have already loaded
# shellcheck disable=1001
for completions in ~/.dotfiles/shell/completions/[!\0]*.sh; do
    [ -r "$completions" ] && [ -f "$completions" ] && source "$completions"
done
unset completions

# --------------------------------------------------------------------- }}}
# TMUX - ATTACH                                                         {{{
# --------------------------------------------------------------------- {|}

# shellcheck disable=2155
export GIT_MUX_BRANCH_PREFIX="$(git config --global github.user)"
export GIT_MUX_PROJECT_PARENTS="$PERSONAL $WORK"
export OG_TERM="$TERM"
# ensure tmux is running
[ -z "$TMUX" ] && git mux project "$PWD"

# --------------------------------------------------------------------- }}}
