#!/bin/sh

exists() {
    test -x "$(command -v "$1")"
}

EDITOR='ed'
exists lvim && EDITOR='lvim'        || {
exists vim && EDITOR='vim';       } || {
exists vi && EDITOR='vi';         } || {
exists nano && EDITOR='nano'; 
}
export EDITOR

LESS="-i -M -R -W -S"
LESSHISTFILE=-
# Highlight section titles in manual pages.
LESS_TERMCAP_md="\e[133m"
export LESS LESSHISTFILE LESS_TERMCAP_md

# Keep around 16K lines of history in memory
HISTSIZE=16384

PAGER=less
MANPAGER=$PAGER
export PAGER MANPAGER

# Enable persistent REPL history for `node`.
NODE_REPL_HISTORY=~/.node_history
# Allow 32³ entries the default is 1000.
NODE_REPL_HISTORY_SIZE='32768'
# Use sloppy mode by default, matching web browsers.
NODE_REPL_MODE='sloppy'
export NODE_REPL_HISTORY NODE_REPL_HISTORY_SIZE NODE_REPL_MODE

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
PYTHONIOENCODING='UTF-8'
export PYTHONIOENCODING

# Prefer US English and use UTF-8.
LANG='en_US.UTF-8'
LC_ALL='en_US.UTF-8'
export LANG LC_ALL


CLICOLOR=1
GREP_COLOR=31
NOSPLASH=1
NOWELCOME=1
export CLICOLOR GREP_COLOR NOSPLASH NOWELCOME

# If HOSTNAME isn't set by this shell, we'll do it
if [ -z "$HOSTNAME" ] ; then
    HOSTNAME=$(uname -n)
fi

# Don't warn me about new mail
unset -v MAILCHECK

# Tool settings
VOLTA_HOME=~/.volta
BAT_THEME="GruvboxDark"
STARSHIP_CONFIG=~/.config/starship/starship.toml
export VOLTA_HOME BAT_THEME STARSHIP_CONFIG