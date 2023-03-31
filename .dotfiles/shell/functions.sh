#!/usr/bin/env sh

# Utilities
#---------------------------------------------------------------------------------

# Search history.
hist() {
    grep --color=always "$*" "$HISTFILE" |
        less --no-init --raw-control-chars --quiet
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Search for text within the current directory.
s() {
    grep --color=always "$*" --ignore-case --recursive \
        --exclude-dir=".git" --exclude-dir="node_modules" . |
        less --no-init --raw-control-chars --quiet
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# https://leahneukirchen.org/dotfiles/bin/goog
goog() {
    curl -A Mozilla/4.0 -skLm 10 \
        "http://www.google.com/search?nfpr=\&q=$(echo "$*" | tr ' ' '+')" |
        grep -oP '\/url\?q=.+?&amp' |
        sed 's/\/url?q=//;s/&amp//;s/\%/\\x/g'
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# https://www.uninformativ.de/git/bin-pub/file/vipe.html
# Use $EDITOR to edit text inside a pipeline
# Write all data to a temporary file, edit that file, then print it
# again.
vipe() {
    tmp=$(mktemp)
    trap 'rm -f "$tmp"' 0
    cat >"$tmp"
    ${EDITOR:-vim} "$tmp" </dev/tty >/dev/tty
    cat "$tmp"
}

# Filesystem
#---------------------------------------------------------------------------------

# Format JSON and sort fields
# arg1: input file
# arg2: output file, defaults to input file
fmtjson() {
    jq '.' -sSM "$1" |
        jq 'reduce .[] as  $obj ({}; . * $obj)' -M >/tmp/fmt.json &&
        mv /tmp/fmt.json "${2:-"$1"}"

}

if is-supported pandoc; then
    mdless() {
        pandoc -s -f markdown -t man "$@" | man -l -
        # use groff on mac: . . . . . . . | groff -T utf8 -man | less
    }
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

md2html() {
    pandoc "$1.md" --output="$1.html" --standalone \
        --css="$HOME/.dotfiles/templates/pandoc.css" --from=gfm --to=html5
}

if is-supported inotifywait; then
    # runs a command when a target file is modified
    # $ onmodify note.md md2html note
    onmodify() {
        TARGET=${1:-.}
        shift
        echo "$TARGET" "$*"
        while inotifywait --exclude '.git' -qq -r -e modify,close_write,moved_to,move_self "$TARGET"; do
            sleep 0.2
            bash -c "$*"
            echo
        done
    }
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Get gzipped file size
gz() {
    ORIGSIZE=$(wc -c <"$1")
    GZIPSIZE=$(gzip -c "$1" | wc -c)
    RATIO=$(echo "$GZIPSIZE * 100/ $ORIGSIZE" | bc -l)
    SAVED=$(echo "($ORIGSIZE - $GZIPSIZE) * 100/ $ORIGSIZE" | bc -l)
    printf "orig: %d bytes\ngzip: %d bytes\nsave: %2.0f%% (%2.0f%%)\n" "$ORIGSIZE" "$GZIPSIZE" "$SAVED" "$RATIO"
    unset ORIGSIZE GZIPSIZE RATIO SAVED
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create a data URL from a file
dataurl() {
    MIMETYPE=$(file --mime-type "$1" | cut -d ' ' -f2)
    if [ "$MIMETYPE" = "text/*" ]; then
        MIMETYPE="${MIMETYPE};charset=utf-8"
    fi
    echo "data:${MIMETYPE};base64,$(openssl base64 -in "$1" | tr -d '\n')"
    unset MIMETYPE
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Recursively search parent directory for file
parent_find() {
    # param 1: name of file or directory to find
    # param 2: directory to start from (defaults to PWD)
    # example: $ parent-find .git

    test -e "${2:-$PWD}/$1" && echo "${2:-$PWD}" && return 0
    [ '/' = "${2:-$PWD}" ] && return 1
    parent-find "$1" "$(dirname "${2:-$PWD}")"
}

# removes duplicate lines from a file
dedup_lines() {
    # param: file to dedup
    # example: $ dedup-lines deps.txt > unique_deps.txt
    awk '!visited[$0]++' "$@"
}

# Networking
#---------------------------------------------------------------------------------

# Find real from shortened url
unshorten() {
    curl -sIL "$1" | sed -n 's/Location: *//p'
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

crt() {
    openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout "$1.key" -out "$1.crt" \
        -subj "/CN=$1\/emailAddress=ben@$1/C=US/ST=California/L=San Francisco/O=Jamin, Inc."
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# add entry to ssh config
add_ssh() {
    [ $# -ne 3 ] && echo "add_ssh host hostname user" && return 1
    [ ! -d ~/.ssh ] && mkdir -m 700 ~/.ssh
    [ ! -e ~/.ssh/config ] && touch ~/.ssh/config && chmod 600 ~/.ssh/config
    printf "%s" "\n\nHost $1\n  HostName $2\n  User $3\n  ServerAliveInterval 30\n  ServerAliveCountMax 120" >>~/.ssh/config
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# list hosts defined in ssh config
ssh_list() {
    awk '$1 ~ /Host$/ {for (i=2; i<=NF; i++) print $i}' ~/.ssh/config
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# add all ssh private keys to agent
ssh_add_all() {
    grep -slR "PRIVATE" ~/.ssh | xargs ssh-add
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# display all ip addresses for this host
ips() {
    if is-supported ifconfig; then
        ifconfig | awk '/inet /{ gsub(/addr:/, ""); print $2 }'
    elif is-supported ip; then
        ip addr | grep -oP 'inet \K[\d.]+'
    else
        echo "Install ifconfig or ip"
    fi
}

# Git
#---------------------------------------------------------------------------------

# git clone worktree
# Clones a bare repo for use with git-worktree and creates an
# initial worktree called asdf that tracks the default branch.
# https://git-scm.com/docs/git-worktree
gclw() {
    dir="${2:-"$(basename "$1" .git)"}"
    mkdir "$dir"
    cd "$dir" || return
    git clone --bare "$1" .git
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch origin
    default_git_branch="$(gbdefault)"
    git worktree add "$default_git_branch" "$default_git_branch"
    cd "$default_git_branch" || return
    unset dir default_git_branch
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# git (find|fuzzy) checkout
# Checkout a branch based on search term.
# If installed, use a fuzzy finder (fzf) to pick when there are multiple matches.
# Otherwise, checkout the most recently committed branch that matches the query
fgco() {
    # [arg1] search term
    # [arg2..n] options to pass fzf
    # [usage] to checkout "benelan/2807-fix-slot-doc":
    # $ gfco slot
    # [usage] same thing with additional fzf options, see `man fzf`
    # $ gfco slot --exact --reverse --header='Checkout Branch' --height=10

    SEARCH_TERM="$1"
    if is-supported fzf; then
        PICK_BRANCH_CMD="fzf"
        [ "$#" -gt 0 ] && shift
    else
        # Choose the first branch if fzf isn't isntalled
        # The branches are sorted by commit date,
        # so this is usually what I want
        PICK_BRANCH_CMD="head -n 1"
        # ignore fzf options if provided
        shift $#
    fi

    # remote and local branches sorted by commit date
    git for-each-ref refs/remotes refs/heads --sort='-committerdate' --format='%(refname:short)' |
        # search, remove 'origin/' prefix from branch names, remove empty line(s)
        awk '/'"$SEARCH_TERM"'/{gsub("^origin/(HEAD)?","");print}' | awk NF |
        # dedup -> pick -> checkout branch
        uniq | $PICK_BRANCH_CMD "$@" | xargs git checkout

    unset PICK_BRANCH_CMD SEARCH_TERM
}

# Adds some additional default fzf options
# and uses my username as the default search term
gcof() {
    SEARCH_TERM="${1:-"$USER"}"
    [ "$#" -gt 0 ] && shift
    gfco "$SEARCH_TERM" --reverse --header='Checkout Branch' --height=15 "$@"
    unset SEARCH_TERM
}

# checkout master, pull, find and checkout branch, merge master/main
gcofup() {
    git checkout "$(gbdefault)"
    git pull
    gcof "$@"
    git merge "$(gbdefault)"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# checks out a branch starting with my github username,
# or creates it if it doesn't exist.
# Syncs the checked out branch with the default branch
# [Usage] create/checkout branch benelan/2807-slots and sync with master:
# $ gcoup 2807-slots
gcoup() {
    git checkout "$(gbdefault)"
    git pull
    branch_name="$(git config github.user)/$1" || {
        is-supported id && branch_name="$(id -un)/$1"
    } || branch_name="$1"

    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        git checkout "$branch_name"
    else
        git checkout -b "$branch_name"
    fi
    git merge "$(gbdefault)"
    unset branch_name
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Arrays
#---------------------------------------------------------------------------------

# This searches an array for an exact match against the term passed
# as the first argument to the function. This exits as soon as
# a match is found.
#
# Returns:
#   0 when a match is found, otherwise 1.
#
# Examples:
#   $ declare -a fruits=(apple orange pear mandarin)
#
#   $ _array_contains_element apple "@{fruits[@]}" && echo 'contains apple'
#   contains apple
#
#   $ if _array_contains_element pear "${fruits[@]}"; then
#       echo "contains pear!"
#     fi
#   contains pear!
#
#
_array_contains_element() {
    element="${1?}"
    shift
    for e in "$@"; do
        [ "$e" = "${element}" ] && return 0
    done
    unset element e
    return 1
}

# Dedupe an array (without embedded newlines).
array_dedup() {
    printf '%s\n' "$@" | sort -u
}

# Cheatsheets
# -----------------------------------------------------------------------------
# https://github.com/chubin/cheat.sh
# $ cht :help

# cheatsheet
cht() { curl "https://cheat.sh/$1"; }
# cheatsheet: javascript
chtjs() { curl "https://cheat.sh/javascript/""$(echo "$*" | tr ' ' '+')"; }
# cheatsheet: typescript
chtts() { curl "https://cheat.sh/typescript/""$(echo "$*" | tr ' ' '+')"; }

# search commandlinefu.com
cmdfu() {
    query=$(echo "$*" | tr " " "-")
    curl -sL "https://www.commandlinefu.com/commands/matching/$query/$(
        echo "$query" | base64
    )/plaintext" | tail -n +2
}

# display one random command from commandlinefu.com
cmdfu_random() {
    curl -sL https://www.commandlinefu.com/commands/random/json |
        jq -r '.[0] | "\n" + "# " + .summary + "\n" + .command'

    # non-jq version with color
    # echo -e "$(
    #     curl -sL https://www.commandlinefu.com/commands/random/json |
    #         sed -re 's/.*,"command":"(.*)","summary":"([^"]+).*/\\x1b[1;32m\2\\n\\n\\x1b[1;33m\1\\x1b[0m/g'
    # )\n"
}

# Misc
#---------------------------------------------------------------------------------

vcd() {
    cd "$(command vifm --choose-dir - "$@")" || return 1
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# make one or more directories and cd into the last one
mcd() {
    mkdir -p -- "$@" && cd -- "${!#}" || return 1
}
