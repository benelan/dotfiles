#!/usr/bin/env bash

# Utilities
#---------------------------------------------------------------------------------

# `open` with no arguments opens the current directory,
# otherwise opens the given location
function o() {
    os="$(os-detect)"
    case "$os" in
        windows_wsl) open_cmd="wslview" ;;
        osx) open_cmd="open" ;;
        linux*) open_cmd="xdg-open" ;;
        *) return ;;
    esac
    if [ $# -eq 0 ]; then
        "$open_cmd" .
    else
        "$open_cmd" "$@"
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mycolumn() (
    file="${1:--}"
    if [ "$file" = - ]; then
        file="$(mktemp)"
        cat >"${file}"
    fi
    awk '
  FNR == 1 { if (NR == FNR) next }
  NR == FNR {
    for (i = 1; i <= NF; i++) {
      l = length($i)
      if (w[i] < l)
        w[i] = l
    }
    next
  }
  {
    for (i = 1; i <= NF; i++)
      printf "%*s", w[i] + (i > 1 ? 1 : 0), $i
    print ""
  }
  ' "$file" "$file"
    if [ "$file" = - ]; then
        rm "$file"
    fi
)

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

# prevent duplicate directories in your PATH variable
# "pathmunge /path/to/dir" is equivalent to PATH=/path/to/dir:$PATH
# "pathmunge /path/to/dir after" is equivalent to PATH=$PATH:/path/to/dir
function pathmunge() {
    if [[ -d "${1:-}" && ! $PATH =~ (^|:)"${1}"($|:) ]]; then
        if [[ "${2:-before}" == "after" ]]; then
            export PATH="$PATH:${1}"
        else
            export PATH="${1}:$PATH"
        fi
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# get the human readable size of the directory
dudir() {
    du --max-depth="${1:-0}" -c |
        sort -r -n |
        awk '{split("K M G",v); s=1; while($1>1024){$1/=1024; s++} print int($1)v[s]"\t"$2}'
}

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

# back up file with timestamp
function backup-file() {
    # param filename
    local filename="${1?}" filetime
    filetime=$(date +%Y%m%d_%H%M%S)
    cp -a "${filename}" "${filename}_${filetime}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# move files to hidden folder in tmp, that gets cleared on each reboot
if ! is-supported del; then
    function del() {
        # param: file or folder to be deleted
        # example: del ./file.txt
        mkdir -p /tmp/.trash && mv "$@" /tmp/.trash
    }
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Lists drive mounts.
function mnt() {
    mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | grep -E ^/dev/ | sort
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

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# displays your ip address, as seen by the Internet
function myip() {
    list=("http://myip.dnsomatic.com/" "http://checkip.dyndns.com/" "http://checkip.dyndns.org/")
    for url in "${list[@]}"; do
        if res="$(curl -fs "${url}")"; then
            break
        fi
    done
    res="$(echo "$res" | grep -Eo '[0-9\.]+')"
    echo -e "Your public IP is: ${echo_bold_green-} $res ${echo_normal-}"
}

# Git
#---------------------------------------------------------------------------------

# git wip (work in progress)
# commit changes that will cleaned up later during rebase
gwip() {
    git add -A && git commit -qm "chore: WIP $(date -Iseconds)"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# git reset
# commit all changes for safety and reset
greset() {
    git add -A && git commit -qm "chore: RESET $(date -Iseconds)"
    git reset HEAD~1
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# git clone bare worktree
# clones a bare repo for use with git-worktree
# https://git-scm.com/docs/git-worktree
gclbwt() {
    dir="${2:-"$(basename "$1" .git)"}"
    mkdir "$dir"
    cd "$dir" || return
    git clone --bare "$1" .git
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch origin
    unset dir
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# git checkout branch (cleaned)
# Creates a new, up to date branch with all of the changes
# from the current branch, but without the messy commit history.
# Helpful when used with gwip and greset (above).
function gcob-cleaned() {
    current_branch="$(git rev-parse --abbrev-ref HEAD)"
    git stash
    git checkout "$(gbdefault)"
    git pull
    git checkout -b "$current_branch-cleaned"
    git merge --squash "$current_branch"
    git reset
    git stash pop
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
# $ gcomm 2807-slots
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
# removes all local branches which have been
# (squash) merged into the default branch
gbprune() {
    TARGET_BRANCH="$(gbdefault)"
    git fetch --prune --all
    git checkout -q "$TARGET_BRANCH"
    git for-each-ref refs/heads/ "--format=%(refname:short)" |
        grep -v -e main -e master -e develop -e dev | # don't remove these branches
        while read -r branch; do
            mergeBase=$(git merge-base "$TARGET_BRANCH" "$branch")
            [[ "$(git cherry "$TARGET_BRANCH" "$(
                git commit-tree "$(git rev-parse "$branch^{tree}")" -p "$mergeBase" -m _
            )")" == "-"* ]] && git branch -D "$branch"
        done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# git-extras-big-blobs
# human readably list the blobs by size, excluding HEAD
function gxbigblobs() {
    git rev-list --objects --all |
        git cat-file --batch-check="%(objecttype) %(objectname) %(objectsize) %(rest)" |
        sed -n "s/^blob //p" |
        sort --numeric-sort --key=2 |
        cut -c 1-12,41- |
        $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest |
        grep -vF --file=<(git ls-tree -r HEAD | awk "{print $3}")
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

# cheatsheet -> editor
chte() {
    local query="${*:2}"
    curl "https://cheat.sh/$1" | $EDITOR
}

# cheatsheet -> clipboard
chtc() {
    local query="${*:2}"
    curl "https://cheat.sh/$1/${query// /+}?QT" | cb
}

# cheatsheet: javascript
cjs() {
    local query="$*"
    curl "https://cheat.sh/javascript/${query// /+}"
}

# cheatsheet: javascript -> editor
cjse() {
    local query="$*"
    curl "https://cheat.sh/javascript/${query// /+}?T" | $EDITOR buf.js
}

# cheatsheet: javascript -> clipboard
cjsc() {
    local query="$*"
    curl "https://cheat.sh/javascript/${query// /+}?cQT" | cb
}

# cheatsheet: typescript
cts() {
    local query="$*"
    curl "https://cheat.sh/typescript/${query// /+}"
}

# cheatsheet: typescript -> editor
ctse() {
    local query="$*"
    curl "https://cheat.sh/typescript/${query// /+}?T" | $EDITOR buf.ts
}

# cheatsheet: typescript -> clipboard
ctsc() {
    local query="$*"
    curl "https://cheat.sh/typescript/${query// /+}?QT" | cb
}

# cheatsheet: shell
csh() {
    local query="$*"
    curl "https://cheat.sh/bash/${query// /+}"
}

# cheatsheet: shell -> editor
cshe() {
    local query="$*"
    curl "https://cheat.sh/bash/${query// /+}?T" | $EDITOR buf.bash
}

# cheatsheet: shell -> clipboard
cshc() {
    local query="$*"
    curl "https://cheat.sh/bash/${query// /+}?cQT" | cb
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

color-grid() {
    awk -v term_cols="${width:-$(tput cols || echo 80)}" -v term_lines="${1:-1}" 'BEGIN{
      s="/\\";
      total_cols=term_cols*term_lines;
      for (colnum = 0; colnum<total_cols; colnum++) {
          r = 255-(colnum*255/total_cols);
          g = (colnum*510/total_cols);
          b = (colnum*255/total_cols);
          if (g>255) g = 510-g;
          printf "\033[48;2;%d;%d;%dm", r,g,b;
          printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
          printf "%s\033[0m", substr(s,colnum%2+1,1);
          if (colnum%term_cols==term_cols) printf "\n";
      }
      printf "\n";
    }'
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# make one or more directories and cd into the last one
function mcd() {
    mkdir -p -- "$@" && cd -- "${!#}" || return
}

