#!/bin/sh
# shellcheck disable=1090

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login exists.

[ -r ~/.dotfiles/shell/paths.sh ] && . ~/.dotfiles/shell/paths.sh
[ -r ~/.dotfiles/shell/exports.sh ] && . ~/.dotfiles/shell/exports.sh

# Add any environment-specific stuff to ~/.local.profile (it's gitignored).
[ -r ~/.profile.local ] && . ~/.profile.local
