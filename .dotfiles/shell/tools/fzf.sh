#!/usr/bin/env bash
# shellcheck disable=1090,2016

# Fuzzy search
# https://github.com/junegunn/fzf
is-supported fzf || return

# Auto-completion
# ---------------
[[ $- == *i* ]] &&
    source "$HOME/.dotfiles/vendor/fzf/shell/completion.bash" 2>/dev/null

# Key bindings
# ------------
[ -f "$HOME/.dotfiles/vendor/fzf/shell/key-bindings.bash" ] &&
    source "$HOME/.dotfiles/vendor/fzf/shell/key-bindings.bash"

# Settings
# --------
is-supported fd &&
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

# fzf default window options
FZF_DEFAULT_OPTS='--preview-window "right:57%" --cycle --exit-0 --select-1 '
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

# fzdf - cd into the directory of the selected file
fzdf() {
    file="$(
        fzf +m -q "$*" \
            --preview="${FZF_PREVIEW_CMD}" \
            --preview-window='right:hidden:wrap' \
            --bind=ctrl-v:toggle-preview \
            --bind=ctrl-x:toggle-sort \
            --header='(view:ctrl-v) (sort:ctrl-x)'
    )"
    cd "$(dirname "$file")" || return
    unset file
}

# fzz - selectable cd to frecency directory
fzz() {
    dir="$(
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
    cd "$dir" || return
    unset dir
}

# -----------------------------------------------------------------------------
# file
# -----------------------------------------------------------------------------

# Run a command with multiple files
# Usage: $ frm vlc
frm() {
    fzf -m -x | xargs -d'\n' -r "$@"
}

# Open the selected file in the default editor
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
feo() {
    IFS=$'\n' out=("$(fzf-tmux --query="$1" --expect=ctrl-o,ctrl-e)")
    key=$(head -1 <<<"$out")
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

# fasd & fzf change directory
# open best matched file using `fasd` if given argument
# filter output of `fasd` using `fzf` else
fze() {
    [ $# -gt 0 ] && fasd -f -e "${EDITOR:-vim}" "$*" && return
    file="$(fasd -Rfl "$1" | fzf -1 -0 --no-sort +m)" && "${EDITOR:-vim}" "${file}" || return 1
    unset file
}

# -----------------------------------------------------------------------------
# pid
# -----------------------------------------------------------------------------

fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi
    if [ "x$pid" != "x" ]; then
        echo "$pid" | xargs kill -"${1:-9}"
    fi
}

# -----------------------------------------------------------------------------
# git
# -----------------------------------------------------------------------------

# fgco - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fgcor() {
    local branches branch
    branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
        branch=$(echo "$branches" |
            fzf-tmux -d $((2 + $(wc -l <<<"$branches"))) +m) &&
        git checkout "$(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")"
}

# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
fgcop() {
    local tags branches target
    branches=$(
        git --no-pager branch --all \
            --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" |
            sed '/^$/d'
    ) || return
    tags=$(
        git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}'
    ) || return
    target=$(
        (
            echo "$branches"
            echo "$tags"
        ) |
            fzf --no-hscroll --no-multi -n 2 \
                --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'"
    ) || return
    git checkout "$(awk '{print $2}' <<<"$target")"
}

# fgcoc - checkout git commit
fgcoc() {
    local commits commit
    commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
        commit=$(echo "$commits" | fzf --tac +s +m -e) &&
        git checkout "$(echo "$commit" | sed "s/ .*//")"
}

# fgcs - get git commit sha
# example usage: git rebase -i `fcs`
fgcs() {
    local commits commit
    commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
        commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
        echo -n "$(echo "$commit" | sed "s/ .*//")"
}

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

# fgstash - easier way to deal with stashes
# type fstash to get a list of your stashes
# enter shows you the contents of the stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
fgstash() {
    local out q k sha
    while out=$(
        git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
            fzf --ansi --no-sort --query="$q" --print-query \
                --expect=ctrl-d,ctrl-b
    ); do
        mapfile -t out <<<"$out"
        q="${out[0]}"
        k="${out[1]}"
        sha="${out[-1]}"
        sha="${sha%% *}"
        [[ -z "$sha" ]] && continue
        if [[ "$k" == 'ctrl-d' ]]; then
            git diff "$sha"
        elif [[ "$k" == 'ctrl-b' ]]; then
            git stash branch "stash-$sha" "$sha"
            break
        else
            git stash show -p "$sha"
        fi
    done
}

# -----------------------------------------------------------------------------
# jq
# -----------------------------------------------------------------------------

if is-supported jq; then
    # run npm script
    fnr() {
        npm run "$(jq -r '.scripts | keys[] ' <package.json | sort | fzf)"
    }

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
