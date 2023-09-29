#!/usr/bin/env bash
# shellcheck disable=1090

# broot - https://github.com/Canop/broot                      {{{
is-supported broot && [ -f ~/.config/broot/launcher/bash/br ] &&
    . ~/.config/broot/launcher/bash/br

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# forgit - https://github.com/wfxr/forgit                     {{{
if is-supported git-forgit; then
    # Aliases
    [ -f ~/dev/lib/forgit/forgit.plugin.sh ] &&
        . ~/dev/lib/forgit/forgit.plugin.sh

    # Settings
    export FORGIT_COPY_CMD="cb"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# fzf - https://github.com/junegunn/fzf                       {{{
if is-supported fzf; then
    # Auto-completion
    [ -f ~/dev/lib/fzf/shell/key-bindings.bash ] &&
        . ~/dev/lib/fzf/shell/completion.bash
    # Key bindings
    [ -f ~E/dev/lib/fzf/shell/key-bindings.bash ] &&
        . ~/dev/lib/fzf/shell/key-bindings.bash

    # Settings
    if is-supported fd; then
        # Use fd (https://github.com/sharkdp/fd) instead of the default find
        # command for listing path candidates.
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git --exclude node_modules'

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
    FZF_DEFAULT_OPTS='--preview-window "right:57%" --cycle --exit-0 --select-1 --reverse'
    # fzf default keybingings
    FZF_DEFAULT_OPTS+=' --bind "ctrl-f:preview-half-page-down,ctrl-b:preview-half-page-up,shift-up:preview-top,shift-down:preview-bottom,ctrl-u:half-page-up,ctrl-d:half-page-down"'
    # fzf colorscheme (gruvbox)
    FZF_DEFAULT_OPTS+=' --color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'

    export FZF_DEFAULT_OPTS
    export FZF_COMPLETION_TRIGGER='~~'
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
