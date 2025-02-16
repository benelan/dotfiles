#!/usr/bin/env sh
# vim:filetype=sh foldmethod=marker:

# directories {{{1
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export TMPDIR="/tmp"

export DEV="$HOME/dev"
export LIB="$DEV/lib"
export WORK="$DEV/work"
export PERSONAL="$DEV/personal"
export NOTES="$DEV/notes"
export DOTFILES="$HOME/.dotfiles"
export CALCITE="$WORK/calcite-design-system"

# system settings {{{1
export LESS="-diwMJR --incsearch --mouse --no-histdups --use-color"
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

# wayland {{{2
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    [ "$XDG_SESSION_DESKTOP" = "sway" ] && export XDG_CURRENT_DESKTOP=sway
    export ELECTRON_OZONE_PLATFORM_HINT=wayland
    export SDL_VIDEODRIVER=wayland
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export QT_ENABLE_HIGHDPI_SCALING=1
    export _JAVA_AWT_WM_NONREPARENTING=1
    export MOZ_ENABLE_WAYLAND=1
    export MOZ_USE_XINPUT2=1
    export MOZ_WEBRENDER=1
    export NO_AT_BRIDGE=1
    export GTK_USE_PORTAL=0 # https://github.com/swaywm/sway/issues/5732
fi

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

if supports wezterm; then
    export TERMINAL="wezterm"
elif supports kitty; then
    export TERMINAL="kitty"
elif supports x-terminal-emulator; then
    export TERMINAL="x-terminal-emulator" # $ sudo update-alternatives --config x-terminal-emulator
elif supports foot && [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export TERMINAL="foot"
fi

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
    export GOPATH="$HOME/.go"
    export GOFLAGS="-trimpath -buildvcs=false"
fi

# javascript {{{1
supports volta && export VOLTA_HOME="$HOME/.volta"
supports bun && export BUN_INSTALL="$HOME/.bun"

if supports node; then
    export NODE_OPTIONS="--max-old-space-size=8192 --no-deprecation"

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
supports glow || supports gh && export GLAMOUR_STYLE="dark"

#https://github.com/BurntSushi/ripgrep
supports rg && export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# https://github.com/junegunn/fzf
if supports fzf; then
    export FZF_COMPLETION_TRIGGER=',,'

    export FZF_CTRL_R_OPTS='
        --bind "ctrl-y:execute-silent(echo -n {2..} | cb)+abort"
        --header "(ctrl-y: copy)"'

    export FZF_CTRL_T_OPTS='
        --walker-skip .git,node_modules,target,dist,build
        --preview "bat -n --color=always {}"
        --bind "ctrl-/:change-preview-window(down|hidden|)"'

    export FZF_ALT_C_OPTS='
        --walker-skip .git,node_modules,target,dist,build
        --preview "tree -taFCI .git/ -I node_modules/ -I dist/ --gitignore --filesfirst --nolinks {}"'

    export FZF_DEFAULT_OPTS='
        --cycle --reverse --highlight-line --info=right
        --preview-window="right,wrap,border-thinblock,<75(down)"
        --bind "ctrl-v:toggle-preview,ctrl-x:toggle-sort,ctrl-h:toggle-hscroll"
        --bind "alt-up:preview-page-up,alt-down:preview-page-down,alt-shift-up:preview-top,alt-shift-down:preview-bottom"
        --bind "ctrl-f:preview-half-page-down,ctrl-b:preview-half-page-up,ctrl-u:half-page-up,ctrl-d:half-page-down"
        --color "fg:#ebdbb2,fg+:#ebdbb2,bg:#282828,bg+:#3c3836,preview-bg:#1d2021,hl:#d3869b:bold,hl+:#d3869b"
        --color "info:#83a598,prompt:#bdae93,query:#d3869b:bold,disabled:#b16286:bold"
        --color "spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#928374,label:#928374"
    '

    # alternative gruvbox colorscheme
    # --color "bg+:#3c3836,bg:#32302f,fg:#ebdbb2,fg+:#ebdbb2,hl+:#fb4934,hl:#928374,header:#928374"
    # --color "spinner:#fb4934,info:#8ec07c,pointer:#fb4934,marker:#fb4934,prompt:#fb4934"

    # Use fd (https://github.com/sharkdp/fd) instead of the default find
    # command for listing path candidates.
    supports fd &&
        export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --no-ignore-vcs --exclude .git --exclude node_modules'
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

# https://github.com/meiji163/gh-notify
export GH_NOTIFY_COMMENT_KEY="alt-c"
export GH_NOTIFY_VIEW_DIFF_KEY="alt-d"
export GH_NOTIFY_VIEW_PATCH_KEY="alt-D"
export GH_NOTIFY_TOGGLE_PREVIEW_KEY="alt-p"
export GH_NOTIFY_RESIZE_PREVIEW_KEY="alt-P"
export GH_NOTIFY_MARK_READ_KEY="alt-x"
export GH_NOTIFY_MARK_ALL_READ_KEY="alt-backspace"
export GH_NOTIFY_OPEN_BROWSER_KEY="ctrl-o"

# my tools {{{1
supports matpat && export MATPAT_OPEN_CMD="$BROWSER"
supports _tmux-select && export TMUX_SELECT_COPY_CMD="cb"

_gh_user="$(git config --global github.user || echo "benelan")"
_gh_icon="$XDG_DATA_HOME/icons/Gruvbox-Plus-Dark/apps/scalable/github.svg"

# https://github.com/benelan/gh-fzf/
export GH_FZF_BRANCH_PREFIX="$_gh_user/"
export GH_FZF_BRANCH_ADD_ISSUE_NUMBER="-"

[ -f "$_gh_icon" ] &&
    export GH_FZF_NOTIFY_ICON="$_gh_icon" &&
    export GH_ND_ICON="$_gh_icon"

# https://github.com/benelan/git-mux
if supports git-mux; then
    export GIT_MUX_LOGS="1"
    export GIT_MUX_LOG_LEVEL="WARN"
    export GIT_MUX_BRANCH_PREFIX="$_gh_user"

    export GIT_MUX_PROJECT_PARENTS="$PERSONAL $WORK $LIB"
    export GIT_MUX_PROJECTS="$NOTES $DOTFILES $XDG_CONFIG_HOME/nvim $HOME/.vim"

    # shell commands or an executable on PATH to run after a new worktree or session is created
    export GIT_MUX_NEW_SESSION_CMD='_git-mux-new-session; history -d -1 >/dev/null 2>&1; clear -x'
    export GIT_MUX_NEW_WORKTREE_CMD="_git-mux-new-worktree; history -d -1 >/dev/null 2>&1; clear -x"
fi

unset _gh_user _gh_icon

# https://github.com/benelan/nm-fzf
export NM_FZF_APPLET_AUTH=1

# nerd font icons {{{1
if [ -n "$(
    find "$XDG_DATA_HOME/fonts" \
        -type f \
        -name "*Nerd*Font*.ttf" \
        -readable -print -quit 2>/dev/null
)" ]; then
    export NERD_ICONS=1
fi
