#!/bin/sh
# shellcheck disable=1090

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login exists.

# SHELL - PATHS                                                         {{{
# --------------------------------------------------------------------- {|}

[ -r ~/.dotfiles/shell/paths.sh ] && . ~/.dotfiles/shell/paths.sh

# --------------------------------------------------------------------- }}}
# SHELL - EXPORTS                                                       {{{
# --------------------------------------------------------------------- {|}

[ -r ~/.dotfiles/shell/exports.sh ] && . ~/.dotfiles/shell/exports.sh

# --------------------------------------------------------------------- }}}
