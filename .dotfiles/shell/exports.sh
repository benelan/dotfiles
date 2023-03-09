#!/bin/sh

exists() {
    test -x "$(command -v "$1")"
}

TERMINAL="wezterm"
EDITOR='vi'
exists nvim && EDITOR='nvim' || {
    exists vim && EDITOR='vim'
} || {
    exists nano && EDITOR='nano'
}
export EDITOR TERMINAL

LESS="-i -M -R -w"
LESSHISTFILE=-
export LESS LESSHISTFILE

# Keep around 16K lines of history in memory
HISTSIZE=16384

VISUAL=$EDITOR
PAGER='less'
MANPAGER=$PAGER
BROWSER='w3m'
export PAGER MANPAGER VISUAL BROWSER

# Highlight section titles in manual pages.
LESS_TERMCAP_md=$'\e[01;32m'
LESS_TERMCAP_me=$'\e[0m'
LESS_TERMCAP_us=$'\e[04;33m'
LESS_TERMCAP_ue=$'\e[0m'

export LESS_TERMCAP_md LESS_TERMCAP_me \
    LESS_TERMCAP_us LESS_TERMCAP_ue

# Enable persistent REPL history for `node`.
NODE_REPL_HISTORY=~/.node_history
# Allow 32³ entries the default is 1000.
NODE_REPL_HISTORY_SIZE='32768'
# Use sloppy mode by default, matching web browsers.
NODE_REPL_MODE='sloppy'
# increase allocated memory
NODE_OPTIONS="--max-old-space-size=8192"
export NODE_REPL_HISTORY NODE_REPL_HISTORY_SIZE NODE_REPL_MODE NODE_OPTIONS

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
PYTHONIOENCODING='UTF-8'
export PYTHONIOENCODING

LANG=en_US.UTF-8
LC_COLLATE=C
export LANG LC_COLLATE

CLICOLOR=1
GREP_COLOR=31
NOSPLASH=1
NOWELCOME=1
export CLICOLOR GREP_COLOR NOSPLASH NOWELCOME

# If HOSTNAME isn't set by this shell, we'll do it
if [ -z "$HOSTNAME" ]; then
    HOSTNAME=$(uname -n)
fi

# Don't warn me about new mail
unset -v MAILCHECK

DOTFILES="$HOME/.dotfiles"
ZK_NOTEBOOK_DIR="$HOME/notes"
export DOTFILES ZK_NOTEBOOK_DIR

VOLTA_HOME=~/.volta
BUN_INSTALL="$HOME/.bun"
BAT_THEME="gruvbox-dark"
export VOLTA_HOME BAT_THEME BUN_INSTALL

NNN_FCOLORS="0404040000000600010F0F02"
NNN_PLUG='f:finder;o:fzopen;d:diffs;z:autojump'
export NNN_PLUG NNN_FCOLORS
