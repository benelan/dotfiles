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

#-----------------------------#
# SHELL - ALIASES             #
#-----------------------------#
for file in ~/.dotfiles/shell/aliases/*; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

[ -n "$BASH_VERSINFO" ] || return   # Check version array exists (>=2.0)
((BASH_VERSINFO[0] >= 3)) || return # Check actual major version number

#-----------------------------#
# BASH - FUNCTIONS/PROMPT     #
#-----------------------------#
for file in ~/.dotfiles/shell/{functions,options,prompt}.sh; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

#-----------------------------#
# BASH - PLUGINS              #
#-----------------------------#
for file in ~/.dotfiles/shell/plugins/*; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

#-----------------------------#
# MISC                        #
#-----------------------------#
cargo=~/.cargo/env
[ -r "$cargo" ] && [ -f "$cargo" ] && source "$cargo"
unset cargo


#-----------------------------#
# BASH - COMPLETIONS          #
#-----------------------------#

# completions go last because some require
# their tools/plugins to have already loaded
for file in ~/.dotfiles/shell/completions/*; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
