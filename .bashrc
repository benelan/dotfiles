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
# SHELL - ALIASES/FUNCTIONS
#---------------------------------------------------------------------------
# NOTE: don't skip to git alias file, it will break stuff
for aliases in ~/.dotfiles/shell/aliases/[!_]*; do
    [ -r "$aliases" ] && [ -f "$aliases" ] && source "$aliases"
done
unset aliases

[ -f ~/.dotfiles/shell/functions.sh ] && source ~/.dotfiles/shell/functions.sh
# shellcheck disable=2128
[ -n "$BASH_VERSINFO" ] || return   # Check version array exists (>=2.0)
((BASH_VERSINFO[0] >= 3)) || return # Check actual major version number

#---------------------------------------------------------------------------
# BASH - OPTIONS/PROMPT
#---------------------------------------------------------------------------
# local if for environment specific stuffs, it is gitignored
for stuffs in ~/.dotfiles/shell/{options,prompt,local}.sh; do
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
# shellcheck disable=2155
export GIT_MUX_BRANCH_PREFIX="$(git config --global github.user)/"
export GIT_MUX_PROJECTS="$HOME/dev/personal $HOME/dev/work"
export OG_TERM="$TERM"
# ensure tmux is running
[ -z "$TMUX" ] && git mux startup
