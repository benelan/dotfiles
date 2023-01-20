#!/bin/sh
# shellcheck disable=1090

#-----------------------------#
# SHELL - PATHS               #
#-----------------------------#
[ -r ~/.dotfiles/shell/paths.sh ] && [ -f ~/.dotfiles/shell/paths.sh ] && . ~/.dotfiles/shell/paths.sh

#-----------------------------#
# SHELL - EXPORTS             #
#-----------------------------#
[ -r ~/.dotfiles/shell/exports.sh ] && [ -f ~/.dotfiles/shell/exports.sh ] && . ~/.dotfiles/shell/exports.sh
