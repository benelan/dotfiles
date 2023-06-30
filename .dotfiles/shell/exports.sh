#!/usr/bin/env sh

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export DEV="$HOME/dev"
export WORK="$DEV/work"
export PERSONAL="$DEV/personal"
export NOTES="$DEV/notes"
export DOTFILES="$HOME/.dotfiles"

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

export EDITOR TERMINAL

export VISUAL=$EDITOR
export PAGER='less'
export MANPAGER=$PAGER

[ -n "$DISPLAY" ] && export BROWSER="firefox" || export BROWSER="w3m"

is-supported bat && export BAT_THEME="gruvbox-dark"
is-supported volta && export VOLTA_HOME="$HOME/.volta"
is-supported bun && export BUN_INSTALL="$HOME/.bun"
is-supported zk && export ZK_NOTEBOOK_DIR="$NOTES"
is-supported task && export TASKRC="$XDG_CONFIG_HOME/task/taskrc"
is-supported taskopen && export TASKOPENRC="$XDG_CONFIG_HOME/task/taskopenrc"

if is-supported go; then
    export GOROOT="/usr/local/go"
    export GOPATH="$HOME/go"
    export GOFLAGS='-buildvcs=false -trimpath'
fi

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

# fff - https://github.com/dylanaraps/fff
if is-supported fff; then
    export FFF_COL2=7
    export FFF_COL5=0
    export FFF_KEY_CLEAR="u"
    export FFF_KEY_RENAME="c"
    export FFF_KEY_BULK_RENAME="r"
    export FFF_KEY_BULK_RENAME_ALL="R"
    export FFF_TRASH="$XDG_DATA_HOME/Trash"
    export FFF_FAV1="$WORK/calcite-components"
    export FFF_FAV2="$WORK/calcite-components.wiki"
    export FFF_FAV3="$WORK/calcite-samples"
    export FFF_FAV4="$WORK/arcgis-esm-samples/"
    export FFF_FAV5="$DOTFILES/scripts"
    export FFF_FAV6="$DOTFILES/shell"
    export FFF_FAV7="$DOTFILES/bin"
    export FFF_FAV8="$HOME/.vim"
    export FFF_FAV9="$XDG_CONFIG_HOME/nvim"
fi
