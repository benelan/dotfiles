#!/usr/bin/env bash
# shellcheck disable=1090,2016

# Fuzzy search
# https://github.com/junegunn/fzf
is-supported fzf || return

# Auto-completion
# ---------------
[[ $- == *i* ]] &&
    source "$HOME/dev/lib/fzf/shell/completion.bash" 2>/dev/null

# Key bindings
# ------------
[ -f "$HOME/dev/lib/fzf/shell/key-bindings.bash" ] &&
    source "$HOME/dev/lib/fzf/shell/key-bindings.bash"

# Settings
# --------
is-supported fd &&
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

# fzf default window options
FZF_DEFAULT_OPTS='--preview-window "right:57%" --cycle --exit-0 --select-1 --reverse '
# fzf default keybingings
FZF_DEFAULT_OPTS+=' --bind "ctrl-f:preview-page-down,ctrl-b:preview-page-up,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,shift-up:preview-top,shift-down:preview-bottom,alt-up:half-page-up,alt-down:half-page-down"'
# fzf colorscheme (gruvbox)
FZF_DEFAULT_OPTS+=' --color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'

export FZF_DEFAULT_OPTS
export FZF_COMPLETION_TRIGGER='--'

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

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Gets a gsetting value using fzf
fgsget() {
    gsettings list-schemas | fzf |
        while read -r _GS_SCHEMA; do
            gsettings list-keys "$_GS_SCHEMA" | fzf |
                while read -r _GS_KEY; do
                    echo "Schema: $_GS_SCHEMA"
                    echo "Key: $_GS_KEY"
                    echo "Value: $(gsettings get "$_GS_SCHEMA" "$_GS_KEY")"
                done
        done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

command -v setxkbmap >/dev/null 2>/dev/null &&
    # Remaps CapsLock with an option selected via fzf
    # Note this only works in X11
    function remap-capslock() {
        [[ -f /usr/share/X11/xkb/rules/base.lst ]] &&
            selected="$(
                grep -Eo "caps:\w*" /usr/share/X11/xkb/rules/base.lst |
                    fzf --reverse --header='Remap CapsLock' --height=15
            )"
        setxkbmap -option -option "${selected:-caps:ctrl_modifier}"
        unset selected
    }

###############################################################################
# Functions from fzf's wiki --> https://github.com/junegunn/fzf/wiki/Examples #
###############################################################################

#------------------------------------------------------------------------------
# directory
# -----------------------------------------------------------------------------

# fzf --preview command for file and directory
if type bat >/dev/null 2>&1; then
    FZF_PREVIEW_CMD='bat --color=always --plain --line-range :$FZF_PREVIEW_LINES {}'
elif type pygmentize >/dev/null 2>&1; then
    FZF_PREVIEW_CMD='head -n $FZF_PREVIEW_LINES {} | pygmentize -g'
else
    FZF_PREVIEW_CMD='head -n $FZF_PREVIEW_LINES {}'
fi

# selectable cd to frecency directory using fasd
fz() {
    cd "$(
        fasd -dl |
            fzf \
                --tac \
                --reverse \
                --no-sort \
                --no-multi \
                --tiebreak=index \
                --bind=ctrl-x:toggle-sort \
                --query "$*" \
                --preview='tree -C {} | head -n $FZF_PREVIEW_LINES' \
                --preview-window='right:hidden:wrap' \
                --bind=ctrl-v:toggle-preview \
                --bind=ctrl-x:toggle-sort \
                --header='(view:ctrl-v) (sort:ctrl-x)'
    )" || return
}

# cd into the directory of the selected file
fzdf() {
    cd "$(
        fzf +m -q "$*" \
            --preview="${FZF_PREVIEW_CMD}" \
            --preview-window='right:hidden:wrap' \
            --bind=ctrl-v:toggle-preview \
            --bind=ctrl-x:toggle-sort \
            --header='(view:ctrl-v) (sort:ctrl-x)' |
            xargs dirname
    )" || return
}

# -----------------------------------------------------------------------------
# file
# -----------------------------------------------------------------------------

# fasd & fzf
# open best matched file using `fasd` if given argument
# otherwise filter output of `fasd` using `fzf`
fze() {
    [ $# -gt 0 ] && fasd -f -e "${EDITOR:-vim}" "$*" && return
    file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && "${EDITOR:-vim}" "${file}" || return 1
    unset file
}

# Open the selected file in the default editor
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
feo() {
    IFS=$'\n' out=("$(fzf --query="$1" --expect=ctrl-o,ctrl-e)")
    # shellcheck disable=2128
    key=$(head -1 <<<"$out")
    # shellcheck disable=2128
    file=$(head -2 <<<"$out" | tail -1)
    if [ -n "$file" ]; then
        if [ "$key" = ctrl-o ]; then
            open "$file"
        else
            ${EDITOR:-vim} "$file"
        fi
    fi
}

fif() {
    if [ ! "$#" -gt 0 ]; then
        echo "Need a string to search for!"
        return 1
    fi
    rg --files-with-matches --no-messages "$1" |
        fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

# Run a command with multiple files
# Usage: $ frm vlc
frm() {
    fzf -m -x | xargs -d'\n' -r "$@"
}

# -----------------------------------------------------------------------------
# pid
# -----------------------------------------------------------------------------

fkill() {
    if [ "$UID" != "0" ]; then
        kill_pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        kill_pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi
    if [ "x$kill_pid" != "x" ]; then
        echo "$kill_pid" | xargs kill -"${1:-9}"
    fi
    unset kill_pid
}

# -----------------------------------------------------------------------------
# git
# -----------------------------------------------------------------------------

# fgshow - git commit browser
fgshow() {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
        fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
            --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# -----------------------------------------------------------------------------
# jq
# -----------------------------------------------------------------------------

if is-supported jq; then
    # find an emoji
    # usage: $ find_emoji | cb
    function femoji() {
        emoji_cache="${HOME}/.dotfiles/cache/emoji.json"

        if [ ! -r "$emoji_cache" ]; then
            curl -sSL https://raw.githubusercontent.com/b4b4r07/emoji-cli/master/dict/emoji.json -o "$emoji_cache"
        fi

        jq <"$emoji_cache" -r '.[] | [
        .emoji, .description, "\(.aliases | @csv)", "\(.tags | @csv)"
    ] | @tsv
' | fzf --prompt 'Search emojis > ' | cut -f1
    }
fi
