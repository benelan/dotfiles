#!/usr/bin/env bash
# shellcheck disable=1090

# Make sure the shell is interactive
case $- in
    *i*) ;;
    *) return ;;
esac

# Don't do anything if restricted. Testing
# whether $- contains 'r' doesn't work, because Bash doesn't set that flag
# until after .bashrc has evaluated
! shopt -q restricted_shell 2>/dev/null || return

# Finally start sourcing startup scripts from ~/.dotfiles/shell
# You can append an underscore to file names to skip them
#---------------------------------------------------------------------------
# SHELL - ALIASES
#---------------------------------------------------------------------------
# NOTE: don't skip to git alias file, it will break stuff
for aliases in ~/.dotfiles/shell/aliases/[!_]*; do
    [ -r "$aliases" ] && [ -f "$aliases" ] && source "$aliases"
done
unset aliases

# shellcheck disable=2128
[ -n "$BASH_VERSINFO" ] || return   # Check version array exists (>=2.0)
((BASH_VERSINFO[0] >= 3)) || return # Check actual major version number

#---------------------------------------------------------------------------
# BASH - FUNCTIONS/OPTIONS/PROMPT
#---------------------------------------------------------------------------
# local if for environment specific stuffs, it is gitignored
for stuffs in ~/.dotfiles/shell/{functions,options,prompt,local}.sh; do
    [ -r "$stuffs" ] && [ -f "$stuffs" ] && source "$stuffs"
done
unset stuffs

[ "$(hostname)" = "jamin-work" ] || [ -z "$WORK" ] &&
    source ~/.dotfiles/shell/work.sh

#---------------------------------------------------------------------------
# BASH - TOOLS
#---------------------------------------------------------------------------
for things in ~/.dotfiles/shell/tools/[!_]*; do
    [ -r "$things" ] && [ -f "$things" ] && source "$things"
done
unset things

#---------------------------------------------------------------------------
# BASH - COMPLETIONS
#---------------------------------------------------------------------------
# completions go last because some require
# their tools/plugins to have already loaded
for completions in ~/.dotfiles/shell/completions/[!_]*; do
    [ -r "$completions" ] && [ -f "$completions" ] && source "$completions"
done
unset completions

#---------------------------------------------------------------------------
# TMUX - ATTACH
#---------------------------------------------------------------------------
# ensure tmux is running, `tat` is in .dotfiles/bin
# [ -z "$TMUX" ] && export OG_TERM="$TERM" && tat
