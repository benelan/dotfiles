#!/usr/bin/env sh

export DEV="$HOME/dev"
export WORK="$DEV/work"
export PERSONAL="$DEV/personal"
export NOTES="$HOME/notes"
export DOTFILES="$HOME/.dotfiles"

export LESS="-diwMJRQ"
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
is-supported wezterm && TERMINAL='wezterm'

export EDITOR TERMINAL

export VISUAL=$EDITOR
export PAGER='less'
export MANPAGER=$PAGER

is-supported w3m && export BROWSER='w3m'
is-supported volta && export VOLTA_HOME=~/.volta
is-supported bun && export BUN_INSTALL="$HOME/.bun"
is-supported bat && export BAT_THEME="gruvbox-dark"
is-supported zk && export ZK_NOTEBOOK_DIR="$NOTES"

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
    export FFF_TRASH=~/.local/share/Trash
    export FFF_FAV1=~/dev/work/calcite-components
    export FFF_FAV2=~/dev/work/calcite-components.wiki
    export FFF_FAV3=~/dev/work/calcite-samples
    export FFF_FAV4=~/dev/work/arcgis-esm-samples/
    export FFF_FAV5=~/.dotfiles/scripts
    export FFF_FAV6=~/.dotfiles/shell
    export FFF_FAV7=~/.dotfiles/bin
    export FFF_FAV8=~/.vim
    export FFF_FAV9=~/.config/nvim
fi
