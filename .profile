#!/bin/sh

#-----------------------------#
# SHELL - PATHS               #
#-----------------------------#
[ -r ~/.dotfiles/sh/paths.sh ] && [ -f ~/.dotfiles/sh/paths.sh ] && . ~/.dotfiles/sh/paths.sh

#-----------------------------#
# SHELL - EXPORTS             #
#-----------------------------#
[ -r ~/.dotfiles/sh/exports.sh ] && [ -f ~/.dotfiles/sh/exports.sh ] && . ~/.dotfiles/sh/exports.sh

#-----------------------------#
# SHELL - ALIASES             #
#-----------------------------#
for file in ~/.dotfiles/sh/aliases/*; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;
