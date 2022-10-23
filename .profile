#!/bin/sh

DOTFILES="$HOME"/.dotfiles
export DOTFILES

#-----------------------------#
# SHELL - PATHS               #
#-----------------------------#
[ -r "$DOTFILES"/sh/.paths ] && [ -f "$DOTFILES"/sh/.paths ] && . "$DOTFILES"/sh/.paths

#-----------------------------#
# SHELL - EXPORTS             #
#-----------------------------#
[ -r "$DOTFILES"/sh/.exports ] && [ -f "$DOTFILES"/sh/.exports ] && . "$DOTFILES"/sh/.exports

#-----------------------------#
# SHELL - ALIASES             #
#-----------------------------#
for file in "$DOTFILES"/sh/aliases/*; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;



# [ -n "$BASH_VERSION" ] && [ -r ~/.bashrc ] && [ -f ~/.bashrc ] && . ~/.bashrc
