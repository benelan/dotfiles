#!/bin/sh
# shellcheck disable=3003

TERMINAL="gnome-terminal"
is-supported wezterm && TERMINAL='wezterm'

EDITOR='nano'
is-supported nvim && EDITOR='nvim' ||
    {
        is-supported vim && EDITOR='vim'
    } ||
    {
        is-supported vi && EDITOR='vi'
    }
export EDITOR TERMINAL

LESS="-i -M -J -R -Q -w"
LESSHISTFILE=-
export LESS LESSHISTFILE

# Keep around 16K lines of history in memory
HISTSIZE=16384

VISUAL=$EDITOR
PAGER='less'
MANPAGER=$PAGER
BROWSER='w3m'
export PAGER MANPAGER VISUAL BROWSER

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

if [ -z "$HOSTNAME" ]; then
    HOSTNAME=$(uname -n)
fi

# Don't warn me about new mail
unset -v MAILCHECK

DEV="$HOME/dev"
WORK="$DEV/work"
PERSONAL="$DEV/personal"
NOTES="$HOME/notes"
DOTFILES="$HOME/.dotfiles"
export DOTFILES DEV WORK PERSONAL NOTES

VOLTA_HOME=~/.volta
BUN_INSTALL="$HOME/.bun"
BAT_THEME="gruvbox-dark"
ZK_NOTEBOOK_DIR="$NOTES"
export VOLTA_HOME BAT_THEME BUN_INSTALL ZK_NOTEBOOK_DIR
