#!/usr/bin/env bash

# Utilities
#---------------------------------------------------------------------------------

function clip() {
    xclip -selection clipboard "$@"
}

function paste() {
    xclip -o -selection clipboard
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Readline library requires bash version 4 or later
# shellcheck disable=2128
if [ "$BASH_VERSINFO" -ge 4 ]; then
    # toggle sudo at the beginning of the current or the
    # previous command by hitting the ESC key twice
    function sudo-command-line() {
        [[ ${#READLINE_LINE} -eq 0 ]] && READLINE_LINE=$(fc -l -n -1 | xargs)
        if [[ $READLINE_LINE == sudo\ * ]]; then
            READLINE_LINE="${READLINE_LINE#sudo }"
        else
            READLINE_LINE="sudo $READLINE_LINE"
        fi
        READLINE_POINT=${#READLINE_LINE}
    }
    # Define shortcut keys: [Esc] [Esc]
    bind -x '"\e\e": sudo-command-line'
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# https://www.uninformativ.de/git/bin-pub/file/vipe.html
# Use $EDITOR to edit text inside a pipeline
# Write all data to a temporary file, edit that file, then print it
# again.
function vipe() {
    tmp=$(mktemp)
    trap 'rm -f "$tmp"' 0
    cat >"$tmp"
    ${EDITOR:-vim} "$tmp" </dev/tty >/dev/tty
    cat "$tmp"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# runs argument in background
function quiet() {
    nohup "$@" &>/dev/null </dev/null &
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Search history.
h() {
    #           ┌─ Enable colors for pipe.
    #           │  ("--color=auto" enables colors only
    #           │   if the output is in the terminal.)
    grep --color=always "$*" "$HISTFILE" |
        less --no-init --raw-control-chars
    #    │         └─ Display ANSI color escape sequences in raw form.
    #    └─ Don't clear the screen after quitting less.
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Search for text within the current directory.
function s() {
    grep --color=always "$*" \
        --exclude-dir=".git" \
        --exclude-dir="node_modules" \
        --ignore-case \
        --recursive \
        . |
        less --no-init --raw-control-chars
    #    │         └─ Display ANSI color escape sequences in raw form.
    #    └─ Don't clear the screen after quitting less.
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# open vim help pages from shell prompt
function :h { nvim +":h $1" +'wincmd o' +'nnoremap q :q!<CR>'; }

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
    function onmodify() {
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
    local ORIGSIZE GZIPSIZE RATIO SAVED
    ORIGSIZE=$(wc -c <"$1")
    GZIPSIZE=$(gzip -c "$1" | wc -c)
    RATIO=$(echo "$GZIPSIZE * 100/ $ORIGSIZE" | bc -l)
    SAVED=$(echo "($ORIGSIZE - $GZIPSIZE) * 100/ $ORIGSIZE" | bc -l)
    printf "orig: %d bytes\ngzip: %d bytes\nsave: %2.0f%% (%2.0f%%)\n" "$ORIGSIZE" "$GZIPSIZE" "$SAVED" "$RATIO"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# disk usage per directory, in Mac OS X and Linux
function usage() {
    case $OSTYPE in
        *'darwin'*)
            du -hd 1 "$@"
            ;;
        *'linux'*)
            du -h --max-depth=1 "$@"
            ;;
    esac
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create a data URL from a file
dataurl() {
    local MIMETYPE
    MIMETYPE=$(file --mime-type "$1" | cut -d ' ' -f2)
    if [[ $MIMETYPE == "text/*" ]]; then
        MIMETYPE="${MIMETYPE};charset=utf-8"
    fi
    echo "data:${MIMETYPE};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Recursively search parent directory for file
parent-find() {
    # param 1: name of file or directory to find
    # param 2: directory to start from (defaults to PWD)
    # example: $ parent-find .git

    local file="$1"
    local dir="${2:-$PWD}"
    test -e "$dir/$file" && echo "$dir" && return 0
    [ '/' = "$dir" ] && return 1
    parent-find "$file" "$(dirname "$dir")"
}

# removes duplicate lines from a file
function dedup-lines() {
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

# https://leahneukirchen.org/dotfiles/bin/goog
function goog() {
    Q=$*
    echo -e "$(curl -A Mozilla/4.0 -skLm 10 \
        http://www.google.com/search?nfpr=\&q="${Q// /+}" |
        grep -oP '\/url\?q=.+?&amp' | sed 's/\/url?q=//;s/&amp//;s/\%/\\x/g')"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function crt {
    openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout "$1.key" -out "$1.crt" \
        -subj "/CN=$1\/emailAddress=ben@$1/C=US/ST=California/L=San Francisco/O=Jamin, Inc."
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# add entry to ssh config
function add-ssh() {
    [[ $# -ne 3 ]] && echo "add_ssh host hostname user" && return 1
    [[ ! -d ~/.ssh ]] && mkdir -m 700 ~/.ssh
    [[ ! -e ~/.ssh/config ]] && touch ~/.ssh/config && chmod 600 ~/.ssh/config
    echo -en "\n\nHost $1\n  HostName $2\n  User $3\n  ServerAliveInterval 30\n  ServerAliveCountMax 120" >>~/.ssh/config
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# list hosts defined in ssh config
function sshlist() {
    awk '$1 ~ /Host$/ {for (i=2; i<=NF; i++) print $i}' ~/.ssh/config
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# add all ssh private keys to agent
function ssh-add-all() {
    grep -slR "PRIVATE" ~/.ssh | xargs ssh-add
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# display all ip addresses for this host
function ips() {
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
    git worktree add asdf "$(gbdefault)"
    cd asdf || return
    unset dir
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
    # $ gfco slot --cycle --exact --reverse --header='Checkout Branch' --height=10

    SEARCH_TERM="$1"
    if is-supported fzf; then
        PICK_BRANCH_CMD="fzf --cycle --exit-0 --select-1"
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
function gcof() {
    local SEARCH_TERM="${1:-"$USER"}"
    [ "$#" -gt 0 ] && shift
    gfco "$SEARCH_TERM" --reverse --header='Checkout Branch' --height=15 "$@"
}

# checkout master, pull, find and checkout branch, merge master/main
function gcofup() {
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
function gcoup() {
    git checkout "$(gbdefault)"
    git pull
    local branch_name
    branch_name="$(git config github.user)/$1"
    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        git checkout "$branch_name"
    else
        git checkout -b "$branch_name"
    fi
    git merge "$(gbdefault)"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# git-branch-prune
# locally removes branches already [squash) merged into the default branch
gbprune() {
    # shellcheck disable=1001,1083
    TARGET_BRANCH="$(gbdefault)" &&
        git fetch --prune --all &&
        git checkout -q "$TARGET_BRANCH" &&
        git for-each-ref refs/heads/ "--format=%(refname:short)" |
        grep -v -e main -e master -e develop -e dev |
            while read -r branch; do mergeBase=$(git merge-base "$TARGET_BRANCH" "$branch") &&
                [[ "$(git cherry "$TARGET_BRANCH" "$(git commit-tree "$(git rev-parse "$branch"\^{tree})" -p "$mergeBase" -m _)")" == "-"* ]] &&
                git branch -D "$branch"; done
    unset TARGET_BRANCH mergeBase branch
}

# Arrays
#---------------------------------------------------------------------------------

# This function searches an array for an exact match against the term passed
# as the first argument to the function. This function exits as soon as
# a match is found.
#
# Returns:
#   0 when a match is found, otherwise 1.
#
# Examples:
#   $ declare -a fruits=(apple orange pear mandarin)
#
#   $ array-contains-element apple "@{fruits[@]}" && echo 'contains apple'
#   contains apple
#
#   $ if array-contains-element pear "${fruits[@]}"; then
#       echo "contains pear!"
#     fi
#   contains pear!
#
#
function array-contains-element() {
    local e element="${1?}"
    shift
    for e in "$@"; do
        [[ "$e" == "${element}" ]] && return 0
    done
    return 1
}

# Dedupe an array (without embedded newlines).
function array-dedup() {
    printf '%s\n' "$@" | sort -u
}

# Cheatsheets
# -----------------------------------------------------------------------------
# https://github.com/chubin/cheat.sh
# $ cht :help

# cheatsheet
cht() {
    curl "https://cheat.sh/$1"
}

# cheatsheet: javascript
chtjs() {
    local query="$*"
    curl "https://cheat.sh/javascript/${query// /+}"
}

# cheatsheet: typescript
chtts() {
    local query="$*"
    curl "https://cheat.sh/typescript/${query// /+}"
}

# search commandlinefu.com
cmdfu() {
    local query="$*"
    curl -sL "https://www.commandlinefu.com/commands/matching/${query// /-}/$(
        echo -n "$query" | base64
    )/plaintext" | tail -n +2
}

# display one random command from commandlinefu.com
rcmdfu() {
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

# Show 256 TERM colors
colors() {
    local Y
    Y="$(printf %$((COLUMNS - 6))s)"
    for i in {0..256}; do
        o=00$i
        echo -e "${o:${#o}-3:3}" "$(
            tput setaf "$i"
            tput setab "$i"
        )""${Y// /=}""$(tput op)"
    done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

vcd() {
    cd "$(command vifm --choose-dir - "$@")" || return 1
}

# make one or more directories and cd into the last one
function mcd() {
    mkdir -p -- "$@" && cd -- "${!#}" || return 1
}
