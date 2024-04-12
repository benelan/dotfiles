#!/usr/bin/env sh
# vim:filetype=sh foldmethod=marker:

# directories {{{1
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

# system settings {{{1
export LESS="-diwMJRQ --incsearch --mouse --no-histdups --use-color"
export LESSHISTFILE=-

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

# default applications {{{1
EDITOR="nano"
if supports nvim; then
    EDITOR="nvim"
elif supports vim; then
    EDITOR="vim"
elif supports vi; then
    EDITOR="vi"
fi

export EDITOR
export VISUAL=$EDITOR
export PAGER="less"
export MANPAGER=$PAGER

supports x-terminal-emulator && export TERMINAL="x-terminal-emulator"
# supports wezterm && TERMINAL="wezterm"

TERM_BROWSER="sensible-browser"
if supports w3m; then
    TERM_BROWSER="w3m"
elif supports lynx; then
    TERM_BROWSER="lynx"
elif supports links2; then
    TERM_BROWSER="links2"
elif supports www-browser; then
    TERM_BROWSER="www-browser"
fi

BROWSER="sensible-browser"
if supports brave-browser; then
    BROWSER="brave-browser"
elif supports vivaldi; then
    BROWSER="vivaldi"
elif supports chromium-browser; then
    BROWSER="chromium-browser"
elif supports google-chrome; then
    BROWSER="google-chrome"
elif supports firefox; then
    BROWSER="firefox"
elif supports gnome-www-browser; then
    BROWSER="gnome-www-browser"
fi

HOME_BROWSER=$BROWSER
if supports firefox && [ $BROWSER != "firefox" ]; then
    HOME_BROWSER="firefox"
elif supports vivaldi && [ $BROWSER != "vivaldi" ]; then
    HOME_BROWSER="vivaldi"
elif supports chromium-browser && [ $BROWSER != "chromium-browser" ]; then
    HOME_BROWSER="chromium-browser"
elif supports google-chrome && [ $BROWSER != "google-chrome" ]; then
    HOME_BROWSER="google-chrome"
fi

ALT_BROWSER=$HOME_BROWSER
if supports vivaldi &&
    [ $HOME_BROWSER != "vivaldi" ] && [ $BROWSER != "vivaldi" ]; then
    ALT_BROWSER="vivaldi"
elif supports chromium-browser &&
    [ $HOME_BROWSER != "chromium-browser" ] && [ $BROWSER != "chromium-browser" ]; then
    ALT_BROWSER="chromium-browser"
elif supports google-chrome &&
    [ $HOME_BROWSER != "google-chrome" ] && [ $BROWSER != "google-chrome" ]; then
    ALT_BROWSER="google-chrome"
fi

export BROWSER TERM_BROWSER ALT_BROWSER HOME_BROWSER

# golang {{{1
if supports go; then
    export GOROOT="/usr/local/go"
    export GOPATH="$HOME/go"
    export GOFLAGS="-buildvcs=false -trimpath"
fi

# javascript {{{1
supports volta && export VOLTA_HOME="$HOME/.volta"
supports bun && export BUN_INSTALL="$HOME/.bun"

if supports node; then
    # Enable persistent REPL history for `node`.
    export NODE_REPL_HISTORY="$HOME/.node_history"

    # Allow 32³ entries the default is 1000.
    export NODE_REPL_HISTORY_SIZE="32768"

    # Use sloppy mode by default, matching web browsers.
    export NODE_REPL_MODE="sloppy"
fi

# misc tools {{{1
# https://github.com/clvv/fasd#tweaks
supports fasd && export _FASD_DATA="$DOTFILES/cache/fasd"

# https://github.com/wfxr/forgit
supports git-forgit && export FORGIT_COPY_CMD="cb"

# https://github.com/sharkdp/bat#highlighting-theme
supports bat && export BAT_THEME="gruvbox-dark"

# https://github.com/mickael-menu/zk/blob/main/docs/notebook.md
supports zk && export ZK_NOTEBOOK_DIR="$NOTES"

# https://taskwarrior.org/docs/configuration
supports task && export TASKRC="$XDG_CONFIG_HOME/task/taskrc"

# https://github.com/jschlatow/taskopen
supports taskopen && export TASKOPENRC="$XDG_CONFIG_HOME/task/taskopenrc"

# https://github.com/cdown/clipmenu
if supports clipmenu; then
    export CM_DIR="$XDG_STATE_HOME"
    export CM_HISTLENGTH="10"
    export CM_SELECTIONS="clipboard"
    export CM_IGNORE_WINDOW="^(seahorse|Item Properties.*|Proton Pass.*)$"

    if supports rofi; then
        export CM_LAUNCHER="rofi"
    elif supports fzf; then
        export CM_LAUNCHER="fzf"
    fi
fi

# https://github.com/charmbracelet/glamour
supports glow || is-supported gh && export GLAMOUR_STYLE="dark"

if supports fzf; then
    export FZF_COMPLETION_TRIGGER='~~'
    export FZF_DEFAULT_OPTS='--cycle --reverse --preview-window "right:50%"
    --bind "ctrl-f:preview-half-page-down,ctrl-b:preview-half-page-up,shift-up:preview-top,shift-down:preview-bottom,ctrl-u:half-page-up,ctrl-d:half-page-down,ctrl-v:toggle-preview,ctrl-x:toggle-sort,ctrl-h:toggle-header"
    --color "fg:#ebdbb2,fg+:#ebdbb2,bg:#282828,bg+:#3c3836,hl:#d3869b:bold,hl+:#d3869b,info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#928374,label:#83a598"'

    # alternative gruvbox colorscheme
    # --color "bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934"'

    # Use fd (https://github.com/sharkdp/fd) instead of the default find
    # command for listing path candidates.
    supports fd &&
        export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --exclude node_modules'
fi

# https://github.com/dylanaraps/fff
if supports fff; then
    export FFF_COL4=5
    export FFF_COL5=0

    # use the OS trashcan
    export FFF_TRASH="$XDG_DATA_HOME/Trash/files"

    export FFF_FAV1="$WORK/calcite-design-system"
    export FFF_FAV2="$WORK/arcgis-esm-samples"
    export FFF_FAV3="$PERSONAL/gh-fzf"
    export FFF_FAV4="$XDG_CONFIG_HOME/nvim"
    export FFF_FAV5="$LIB"
    export FFF_FAV6="$WORK"
    export FFF_FAV7="$PERSONAL"
    export FFF_FAV8="$DOTFILES"
    export FFF_FAV9="$NOTES"
fi

# my tools {{{1
supports matpat && export MATPAT_OPEN_CMD="$BROWSER"
supports _tmux-select && export TMUX_SELECT_COPY_CMD="cb"

# https://github.com/benelan/git-mux
if supports git-mux; then
    # shellcheck disable=2155
    export GIT_MUX_BRANCH_PREFIX="$(git config --global github.user || echo "benelan")"

    # shell commands or an executable on PATH to run after a new worktree or session is created
    export GIT_MUX_NEW_WORKTREE_CMD="_git-mux-new-worktree; history -d -1 >/dev/null 2>&1; clear -x"
    # shellcheck disable=2016
    export GIT_MUX_NEW_SESSION_CMD='[ -n "$TMUX" ] && tmux rename-window scratch; git fetch --all --prune 2>/dev/null; history -d -1 >/dev/null 2>&1; clear -x'

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
