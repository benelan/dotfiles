#!/bin/sh

#-----------------------------#
# SHELL - PATHS               #
#-----------------------------#
[ -r ~/.dotfiles/sh/.paths ] && [ -f ~/.dotfiles/sh/.paths ] && . ~/.dotfiles/sh/.paths

#-----------------------------#
# SHELL - EXPORTS             #
#-----------------------------#
[ -r ~/.dotfiles/sh/.exports ] && [ -f ~/.dotfiles/sh/.exports ] && . ~/.dotfiles/sh/.exports

#-----------------------------#
# SHELL - ALIASES             #
#-----------------------------#
for file in ~/.dotfiles/sh/aliases/*; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;



# [ -n "$BASH_VERSION" ] && [ -r ~/.bashrc ] && [ -f ~/.bashrc ] && . ~/.bashrc
