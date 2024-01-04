#!/usr/bin/env sh

# directories                                                 {{{

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export DEV="$HOME/dev"
export LIB="$DEV/lib"
export WORK="$DEV/work"
export PERSONAL="$DEV/personal"
export NOTES="$DEV/notes"
export DOTFILES="$HOME/.dotfiles"
export CALCITE="$WORK/calcite-design-system"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# system settings                                             {{{

export LESS="-diwMJRQ --incsearch --mouse --no-histdups --use-color"
export LESSHISTFILE=-

export HISTSIZE=42069

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr
export PYTHONIOENCODING="UTF-8"

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

EDITOR="nano"
if is-supported nvim; then
    EDITOR="nvim"
elif is-supported vim; then
    EDITOR="vim"
elif is-supported vi; then
    EDITOR="vi"
fi

TERMINAL="x-terminal-emulator"
# is-supported wezterm && TERMINAL="wezterm"

TERM_BROWSER="sensible-browser"
if is-supported w3m; then
    TERM_BROWSER="w3m"
elif is-supported lynx; then
    TERM_BROWSER="lynx"
elif is-supported links2; then
    TERM_BROWSER="links2"
elif is-supported www-browser; then
    TERM_BROWSER="www-browser"
fi

BROWSER="sensible-browser"
if is-supported brave-browser; then
    BROWSER="brave-browser"
elif is-supported vivaldi; then
    BROWSER="vivaldi"
elif is-supported chromium-browser; then
    BROWSER="chromium-browser"
elif is-supported google-chrome; then
    BROWSER="google-chrome"
elif is-supported firefox; then
    BROWSER="firefox"
elif is-supported gnome-www-browser; then
    HOME_BROWSER="gnome-www-browser"
fi

HOME_BROWSER=$BROWSER
if is-supported firefox && [ $BROWSER != "firefox" ]; then
    HOME_BROWSER="firefox"
elif is-supported vivaldi && [ $BROWSER != "vivaldi" ]; then
    HOME_BROWSER="vivaldi"
elif is-supported chromium-browser && [ $BROWSER != "chromium-browser" ]; then
    HOME_BROWSER="chromium-browser"
elif is-supported google-chrome && [ $BROWSER != "google-chrome" ]; then
    HOME_BROWSER="google-chrome"
fi

ALT_BROWSER=$HOME_BROWSER
if is-supported vivaldi &&
    [ $HOME_BROWSER != "vivaldi" ] && [ $BROWSER != "vivaldi" ]; then
    ALT_BROWSER="vivaldi"
elif is-supported chromium-browser &&
    [ $HOME_BROWSER != "chromium-browser" ] && [ $BROWSER != "chromium-browser" ]; then
    ALT_BROWSER="chromium-browser"
elif is-supported google-chrome &&
    [ $HOME_BROWSER != "google-chrome" ] && [ $BROWSER != "google-chrome" ]; then
    ALT_BROWSER="google-chrome"
fi

export EDITOR TERMINAL BROWSER TERM_BROWSER ALT_BROWSER HOME_BROWSER
export VISUAL=$EDITOR
export PAGER="less"
export MANPAGER=$PAGER

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# golang                                                      {{{

if is-supported go; then
    export GOROOT="/usr/local/go"
    export GOPATH="$HOME/go"
    export GOFLAGS="-buildvcs=false -trimpath"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# javascript                                                  {{{

is-supported volta && export VOLTA_HOME="$HOME/.volta"
is-supported bun && export BUN_INSTALL="$HOME/.bun"

if is-supported node; then
    # Enable persistent REPL history for `node`.
    export NODE_REPL_HISTORY="$HOME/.node_history"

    # Allow 32³ entries the default is 1000.
    export NODE_REPL_HISTORY_SIZE="32768"

    # Use sloppy mode by default, matching web browsers.
    export NODE_REPL_MODE="sloppy"

    # increase allocated memory
    export NODE_OPTIONS="--max-old-space-size=8192"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# misc tools                                                  {{{

# https://github.com/clvv/fasd#tweaks
is-supported fasd && export _FASD_DATA="$DOTFILES/cache/fasd"

# https://github.com/wfxr/forgit
is-supported git-forgit && export FORGIT_COPY_CMD="cb"

# https://github.com/sharkdp/bat#highlighting-theme
is-supported bat && export BAT_THEME="gruvbox-dark"

# https://github.com/mickael-menu/zk/blob/main/docs/notebook.md
is-supported zk && export ZK_NOTEBOOK_DIR="$NOTES"

# https://taskwarrior.org/docs/configuration
is-supported task && export TASKRC="$XDG_CONFIG_HOME/task/taskrc"

# https://github.com/jschlatow/taskopen
is-supported taskopen && export TASKOPENRC="$XDG_CONFIG_HOME/task/taskopenrc"

# https://github.com/charmbracelet/glamour
is-supported glow || is-supported gh && export GLAMOUR_STYLE="dark"

# https://github.com/dylanaraps/fff
if is-supported fff; then
    export FFF_COL2=7
    export FFF_COL5=0

    # use the OS trashcan
    export FFF_TRASH="$XDG_DATA_HOME/Trash/files"

    # common work projects
    export FFF_FAV1="$WORK/calcite-design-system"
    export FFF_FAV2="$WORK/calcite-design-system.wiki"
    export FFF_FAV3="$WORK/arcgis-esm-samples/"

    # the usual suspects
    export FFF_FAV4="$XDG_CONFIG_HOME/nvim"
    export FFF_FAV5="$LIB"
    export FFF_FAV6="$WORK"
    export FFF_FAV7="$PERSONAL"
    export FFF_FAV8="$DOTFILES"
    export FFF_FAV9="$NOTES"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# my tools                                                    {{{

is-supported matpat && export MATPAT_OPEN_CMD="$BROWSER"

# https://github.com/benelan/git-mux
if is-supported git-mux; then
    # shellcheck disable=2155
    export GIT_MUX_BRANCH_PREFIX="$(git config --global github.user || echo "benelan")"

    # shell commands or an executable on PATH to run after a new worktree is created
    export GIT_MUX_NEW_WORKTREE_CMD="_git-mux-new-worktree"
    export GIT_MUX_NEW_SESSION_CMD='git fetch --all --prune 2>/dev/null'

    export GIT_MUX_PROJECT_PARENTS="$PERSONAL $WORK $LIB"
    export GIT_MUX_PROJECTS="$NOTES $DOTFILES $XDG_CONFIG_HOME/nvim $HOME/.vim"
fi

if [ -n "$(
    find "$XDG_DATA_HOME/fonts" \
        -type f \
        -name "*Nerd*Font*.ttf" \
        -readable -print -quit 2>/dev/null
)" ]; then
    export USE_DEVICONS=1
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
