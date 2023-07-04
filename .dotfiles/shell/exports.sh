#!/usr/bin/env sh

# directories                                                 {{{
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export DEV="$HOME/dev"
export WORK="$DEV/work"
export PERSONAL="$DEV/personal"
export NOTES="$DEV/notes"
export DOTFILES="$HOME/.dotfiles"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# system settings                                             {{{
export LESS="-diwMJRQ --incsearch --mouse --no-histdups --use-color"
export LESSHISTFILE=-

# Keep around 16K lines of history in memory
export HISTSIZE=16384

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr
export PYTHONIOENCODING='UTF-8'

export LANG=en_US.UTF-8
export LC_COLLATE=C

export CLICOLOR=1
export GREP_COLOR=31
export NOSPLASH=1
export NOWELCOME=1

if [ -z "$HOSTNAME" ]; then
    HOSTNAME="$(uname -n)"
    export HOSTNAME
fi

# Don't warn me about new mail
unset -v MAILCHECK

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# default applications                                        {{{
EDITOR='nano'
is-supported nvim && EDITOR='nvim' ||
    {
        is-supported vim && EDITOR='vim'
    } ||
    {
        is-supported vi && EDITOR='vi'
    }

TERMINAL="gnome-terminal"
# is-supported wezterm && TERMINAL='wezterm'

BROWSER='www-browser'
is-supported w3m && BROWSER='w3m' ||
    {
        is-supported links2 && BROWSER='links2'
    } ||
    {
        is-supported lynx && BROWSER='lynx'
    }

export EDITOR TERMINAL BROWSER
export VISUAL=$EDITOR
export PAGER='less'
export MANPAGER=$PAGER

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# define terminal colors                                      {{{
{
    if tput setaf 1 >/dev/null 2>&1; then
        RESET=$(tput sgr0)
        BOLD=$(tput bold)
        UNDERLINE=$(tput smul)
        # Gruvbox colors from: https://github.com/morhetz/gruvbox
        BLACK=$(tput setaf 235)
        BLUE=$(tput setaf 66)
        AQUA=$(tput setaf 72)
        GREEN=$(tput setaf 106)
        ORANGE=$(tput setaf 166)
        PURPLE=$(tput setaf 132)
        RED=$(tput setaf 124)
        WHITE=$(tput setaf 230)
        YELLOW=$(tput setaf 172)
    else
        RESET="\e[0m"
        BOLD='\e[1m'
        UNDERLINE='e[4m'
        BLACK="\e[1;30m"
        BLUE="\e[1;34m"
        AQUA="\e[1;36m"
        GREEN="\e[1;32m"
        ORANGE="\e[1;33m"
        PURPLE="\e[1;35m"
        RED="\e[1;31m"
        WHITE="\e[1;37m"
        YELLOW="\e[1;33m"
    fi
} >/dev/null 2>&1

export BOLD UNDERLINE RESET BLACK BLUE AQUA \
    GREEN ORANGE PURPLE RED WHITE YELLOW

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# golang                                                      {{{
if is-supported go; then
    export GOROOT="/usr/local/go"
    export GOPATH="$HOME/go"
    export GOFLAGS='-buildvcs=false -trimpath'
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# node                                                        {{{
is-supported volta && export VOLTA_HOME="$HOME/.volta"
is-supported bun && export BUN_INSTALL="$HOME/.bun"
if is-supported node; then
    # Enable persistent REPL history for `node`.
    export NODE_REPL_HISTORY=~/.node_history
    # Allow 32³ entries the default is 1000.
    export NODE_REPL_HISTORY_SIZE='32768'
    # Use sloppy mode by default, matching web browsers.
    export NODE_REPL_MODE='sloppy'
    # increase allocated memory
    export NODE_OPTIONS="--max-old-space-size=8192"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# misc tools                                                  {{{
is-supported bat && export BAT_THEME="gruvbox-dark"
is-supported zk && export ZK_NOTEBOOK_DIR="$NOTES"
is-supported task && export TASKRC="$XDG_CONFIG_HOME/task/taskrc"
is-supported taskopen && export TASKOPENRC="$XDG_CONFIG_HOME/task/taskopenrc"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# fff - https://github.com/dylanaraps/fff                     {{{
if is-supported fff; then
    export FFF_COL2=7
    export FFF_COL5=0
    export FFF_KEY_CLEAR="u"
    export FFF_KEY_RENAME="c"
    export FFF_KEY_BULK_RENAME="r"
    export FFF_KEY_BULK_RENAME_ALL="R"
    export FFF_TRASH="$XDG_DATA_HOME/Trash"
    export FFF_FAV1="$WORK/calcite-design-system"
    export FFF_FAV2="$WORK/calcite-design-system.wiki"
    export FFF_FAV3="$WORK/calcite-samples"
    export FFF_FAV4="$WORK/arcgis-esm-samples/"
    export FFF_FAV5="$DOTFILES/scripts"
    export FFF_FAV6="$DOTFILES/shell"
    export FFF_FAV7="$DOTFILES/bin"
    export FFF_FAV8="$HOME/.vim"
    export FFF_FAV9="$XDG_CONFIG_HOME/nvim"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
