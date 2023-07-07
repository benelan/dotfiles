#!/usr/bin/env bash
# shellcheck disable=1090

# cargo - https://github.com/rust-lang/cargo                  {{{
# [ -r ~/.cargo/env ] && [ -f ~/.cargo/env ] && source ~/.cargo/env

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}

# broot - https://github.com/Canop/broot                      {{{
is-supported broot && [ -f ~/.config/broot/launcher/bash/br ] &&
    source ~/.config/broot/launcher/bash/br

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}

# thefuck - https://github.com/nvbn/thefuck                   {{{
# is-supported thefuck && eval "$(thefuck --alias)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}

# navi - https://github.com/denisidoro/navi                   {{{
# is-supported navi && eval "$(navi widget bash)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}

# fzf - https://github.com/junegunn/fzf                       {{{
if is-supported fzf; then
    # Auto-completion
    [ -f ~/dev/lib/fzf/shell/key-bindings.bash ] &&
        source ~/dev/lib/fzf/shell/completion.bash
    # Key bindings
    [ -f ~E/dev/lib/fzf/shell/key-bindings.bash ] &&
        source ~/dev/lib/fzf/shell/key-bindings.bash

    # Settings
    # --------
    if is-supported fd; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

        # Use fd (https://github.com/sharkdp/fd) instead of the default find
        # command for listing path candidates.
        # - The first argument to the function ($1) is the base path to start traversal
        # - See the source code (completion.{bash,zsh}) for the details.
        _fzf_compgen_path() {
            fd --hidden --follow --exlude "node_modules" --exclude ".git" . "$1"
        }

        # Use fd to generate the list for directory completion
        _fzf_compgen_dir() {
            fd --type d --hidden --follow --exclude "node_modules" --exclude ".git" . "$1"
        }
    fi

    # fzf default window options
    FZF_DEFAULT_OPTS='--preview-window "right:57%" --cycle --exit-0 --select-1 --reverse '
    # fzf default keybingings
    FZF_DEFAULT_OPTS+=' --bind "ctrl-f:preview-page-down,ctrl-b:preview-page-up,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,shift-up:preview-top,shift-down:preview-bottom,alt-up:half-page-up,alt-down:half-page-down"'
    # fzf colorscheme (gruvbox)
    FZF_DEFAULT_OPTS+=' --color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'

    export FZF_DEFAULT_OPTS
    export FZF_COMPLETION_TRIGGER='~~'
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
