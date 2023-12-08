#!/usr/bin/env bash

# Utilities                                                             {{{
# --------------------------------------------------------------------- {|}

## search history                                             {{{

hist() {
    grep --color=always "$*" "$HISTFILE" |
        less --no-init --raw-control-chars --quiet
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}

## search for text within the current directory               {{{

s() {
    grep --color=always "$*" --ignore-case --recursive \
        --exclude-dir=".git" --exclude-dir="node_modules" . |
        less --no-init --raw-control-chars --quiet
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}

## google from the command line                               {{{

# https://leahneukirchen.org/dotfiles/bin/goog
goog() {
    curl -A Mozilla/4.0 -skLm 10 \
        "http://www.google.com/search?nfpr=\&q=$(echo "$*" | tr ' ' '+')" |
        grep -oP '\/url\?q=.+?&amp' |
        sed 's/\/url?q=//;s/&amp//;s/\%/\\x/g'
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## use $EDITOR to edit text inside a pipeline                 {{{

# Write all data to a temporary file, edit that file, then
# print it again.
# https://www.uninformativ.de/git/bin-pub/file/vipe.html
vipe() {
    tmp=$(mktemp)
    trap 'rm -f "$tmp"' 0
    cat >"$tmp"
    ${EDITOR:-vim} "$tmp" </dev/tty >/dev/tty
    cat "$tmp"
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## jump to search pattern in man page(s)                      {{{

## Example: jump to the examples heading in two git man pages
## mans ^examples git-log git-checkout
mans() {
    if [ -z "$2" ]; then
        man "$1"
    else
        man_pager="less -p \"$1\""
        shift
        man --pager="$man_pager" "$@"
    fi
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## use vifm to cd                                             {{{

vcd() { cd "$(command vifm --choose-dir - "$@")" || return 1; }

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## make one or more directories and cd into the last one      {{{

mcd() { mkdir -p -- "$1" && cd "$_" || return 1; }

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## add surfraw bookmark                                       {{{

# see fob() later in the file for finding/opening a bookmark
# the following is my personal bookmark convention
# <name> <url> <:[tag1:tag2:tag...]:> [-g]
# name - used to open the bookmark, e.g. `sr codepen`
#        I've been doing no special chars for landing pages
#        and separating with "-" when it's more specific, e.g.
#        mf https://martinfowler.com/tags/
#        mf-flacid https://martinfowler.com/bliki/FlaccidScrum.html
# url  - the URL to open, can also be a file URI
# tags - colon-separated list of tags, none is "::"
#        https://github.com/mickael-menu/zk/blob/main/docs/tags.md
# -g   - force surfraw to open the bookmark in a GUI browser
#        only works when using fob(), not surfraw directly
bm() { echo "$*" >>"$XDG_CONFIG_HOME/surfraw/bookmarks"; }

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}

# --------------------------------------------------------------------- }}}
# Filesystem                                                            {{{
# --------------------------------------------------------------------- {|}

## fff wrapper that changes to directory on exit              {{{

if is-supported fff; then
    ff() {
        fff "$@"
        cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")" || return
    }
fi

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## format JSON and sort fields                                {{{

# arg1: input file
# arg2: output file, defaults to input file
fmtjson() {
    jq '.' -sSM "$1" |
        jq 'reduce .[] as  $obj ({}; . * $obj)' -M >/tmp/fmt.json &&
        mv /tmp/fmt.json "${2:-"$1"}"

}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## pandoc functions for converting between text filetypes     {{{

if is-supported pandoc; then
    # Open a markdown file in the less pager
    mdless() {
        pandoc -s -f markdown -t man "$@" | man -l -
        # use groff on mac: . . . . . . . | groff -T utf8 -man | less
    }

    # Convert markdown to HTML
    md2html() {
        pandoc "$1.md" --output="$1.html" --standalone \
            --css="$DOTFILES/assets/pandoc.css" --from=gfm --to=html5
    }
fi

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## run a command when a target file is modified               {{{

# $ onmodify note.md md2html note
if is-supported inotifywait; then
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

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## get gzipped file size                                      {{{

gz() {
    ORIGSIZE=$(wc -c <"$1")
    GZIPSIZE=$(gzip -c "$1" | wc -c)
    RATIO=$(echo "$GZIPSIZE * 100/ $ORIGSIZE" | bc -l)
    SAVED=$(echo "($ORIGSIZE - $GZIPSIZE) * 100/ $ORIGSIZE" | bc -l)
    printf "orig: %d bytes\ngzip: %d bytes\nsave: %2.0f%% (%2.0f%%)\n" \
        "$ORIGSIZE" "$GZIPSIZE" "$SAVED" "$RATIO"
    unset ORIGSIZE GZIPSIZE RATIO SAVED
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## create a data URL from a file                              {{{

dataurl() {
    MIMETYPE=$(file --mime-type "$1" | cut -d ' ' -f2)
    if [ "$MIMETYPE" = "text/*" ]; then
        MIMETYPE="${MIMETYPE};charset=utf-8"
    fi
    echo "data:${MIMETYPE};base64,$(openssl base64 -in "$1" | tr -d '\n')"
    unset MIMETYPE
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
## recursively search parent directory for file               {{{

# param 1: name of file or directory to find
# param 2: directory to start from (defaults to PWD)
# example: $ parent-find .git
parent_find() {
    test -e "${2:-$PWD}/$1" && echo "${2:-$PWD}" && return 0
    [ '/' = "${2:-$PWD}" ] && return 1
    parent-find "$1" "$(dirname "${2:-$PWD}")"
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## remove duplicate lines from a file                         {{{

# param: file to dedup
# example: $ dedup-lines deps.txt > unique_deps.txt
dedup_lines() { awk '!visited[$0]++' "$@"; }

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}

# --------------------------------------------------------------------- }}}
# Networking                                                            {{{
# --------------------------------------------------------------------- {|}

## get the pid of the prccess listening on the provided port  {{{

wtfport() {
    line="$(lsof -i -P -n | grep LISTEN | grep ":$1")"
    pid=$(echo "$line" | awk '{print $2}')
    pid_name=$(echo "$line" | awk '{print $1}')

    # If there's nothing running, exit
    [ -z "$pid" ] && return 0

    # output the process name to stderr so it won't be piped along
    printf "%s" "$pid_name" >&2

    # print the process id. It can be piped, for example to pbcopy
    echo -e "$pid"
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## kill the process listening on the provided port            {{{

killport() { wtfport "$1" | xargs kill -9; }

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## find real from shortened url                               {{{

unshorten() { curl -sIL "$1" | sed -n 's/location: *//pi'; }

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## generate a certificate and key for local testing           {{{

crt() {
    openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout "$1.key" -out "$1.crt" \
        -subj "/CN=$1\/emailAddress=ben@$1/C=US/ST=California/L=San Francisco/O=Jamin, Inc."
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## add entry to ssh config                                    {{{

add_ssh() {
    [ $# -ne 3 ] && echo "add_ssh host hostname user" && return 1

    [ ! -d ~/.ssh ] && mkdir -m 700 ~/.ssh
    [ ! -e ~/.ssh/config ] && touch ~/.ssh/config && chmod 600 ~/.ssh/config

    printf "\n\n%s\n %s\n %s\n %s\n %s" \
        "Host $1" \
        "HostName $2" \
        "User $3" \
        "ServerAliveInterval 30" \
        "ServerAliveCountMax 120" \
        >>~/.ssh/config
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## list hosts defined in ssh config                           {{{

ssh_list() { awk '$1 ~ /Host$/ {for (i=2; i<=NF; i++) print $i}' ~/.ssh/config; }

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## add all ssh private keys to agent                          {{{

ssh_add_all() { grep -slR "PRIVATE" ~/.ssh | xargs ssh-add; }

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## display all ip addresses for this host                     {{{

ips() {
    printf "%s\n" "Router IP (Gateway): $(
        netstat -rn | awk 'FNR == 3 {print $2}' ||
            route -n | awk 'FNR == 3 {print $2}' ||
            ip route | awk '/via/ {print $3}'
    )"

    printf "%s\n" "Local IP (Private IP): $(
        ip addr | awk '/global/ {print $2}' | cut -d'/' -f1 | head -n1 ||
            ifconfig | awk '/inet/ {print $2}' | head -n1
    )"

    printf "%s\n" "External IP (Public IP): $(
        dig +short myip.opendns.com @resolver1.opendns.com ||
            curl -s ifconfig.co ||
            curl -s checkip.amazonaws.com ||
            curl -s ipinfo.io/ip ||
            curl -s icanhazip.com ||
            curl -s smart-ip.net/myip ||
            (curl -s pasteip.me/api/cli/ && echo) ||
            curl -s http://checkip.dyndns.org | grep -o '[[:digit:].]\+'
    )"
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}

# --------------------------------------------------------------------- }}}
# Git                                                                   {{{
# --------------------------------------------------------------------- {|}

## checkout a branch based on fuzzy search term               {{{

# If installed, use a fuzzy finder (fzf) to pick when there are multiple matches.
# Otherwise, checkout the most recently committed branch that matches the query
# git (find|fuzzy) checkout
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
        # Choose the first branch if fzf isn't installed
        # The branches are sorted by commit date,
        # so this is usually what I want
        PICK_BRANCH_CMD="head -n 1"
        # ignore fzf options if provided
        shift $#
    fi

    # remote and local branches sorted by commit date
    git for-each-ref refs/remotes refs/heads --sort=-committerdate --format='%(refname:short)' |
        # filter by search term, remove 'origin/' prefix from branch names, and dedupe
        awk '/'"$SEARCH_TERM"'/{gsub("^origin/(HEAD)?","")};!x[$0]++' |
        # pick -> checkout branch
        $PICK_BRANCH_CMD "$@" | xargs git checkout

    unset PICK_BRANCH_CMD SEARCH_TERM
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## delete squash merged branches                              {{{

# from https://github.com/not-an-aardvark/git-delete-squashed
gbprune() {
    TARGET_BRANCH="${1:-$(g bdefault)}" &&
        git checkout -q "$TARGET_BRANCH" &&
        git for-each-ref refs/heads/ "--format=%(refname:short)" |
        while read -r branch; do mergeBase=$(git merge-base "$TARGET_BRANCH" "$branch") &&
            [[ $(
                # shellcheck disable=2046,1083,1001
                git cherry "$TARGET_BRANCH" $(git commit-tree $(
                    git rev-parse "$branch"\^{tree}
                ) -p "$mergeBase" -m _)
            ) == "-"* ]] &&
            git branch -D "$branch"; done

}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}

# --------------------------------------------------------------------- }}}
# Arrays                                                                {{{
# --------------------------------------------------------------------- {|}

## searches an array for an exact match against arg1          {{{

# exits as soon as a match is found
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

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## dedupe an array (without embedded newlines)                {{{

array_dedup() {
    printf '%s\n' "$@" | sort -u
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}

# --------------------------------------------------------------------- }}}
# Cheatsheets                                                           {{{
# --------------------------------------------------------------------- {|}

## search https://github.com/chubin/cheat.sh                  {{{

# $ cht :help
cht() { curl "https://cheat.sh/$1"; }
chtjs() { curl "https://cheat.sh/javascript/""$(echo "$*" | tr ' ' '+')"; }
chtts() { curl "https://cheat.sh/typescript/""$(echo "$*" | tr ' ' '+')"; }

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}

# --------------------------------------------------------------------- }}}
# FZF                                                                   {{{
# --------------------------------------------------------------------- {|}

# functions from fzf's wiki --> https://github.com/junegunn/fzf/wiki/Examples

if is-supported fzf; then
    # fzf --preview command for file and directory
    if type bat >/dev/null 2>&1; then
        # shellcheck disable=2016
        FZF_PREVIEW_CMD='bat --color=always --plain --line-range :$FZF_PREVIEW_LINES {}'
    elif type pygmentize >/dev/null 2>&1; then
        # shellcheck disable=2016
        FZF_PREVIEW_CMD='head -n $FZF_PREVIEW_LINES {} | pygmentize -g'
    else
        # shellcheck disable=2016
        FZF_PREVIEW_CMD='head -n $FZF_PREVIEW_LINES {}'
    fi

    fob() {
        bookmark="$(awk NF "$XDG_CONFIG_HOME/surfraw/bookmarks" | fzf -e)"
        bookmark_name="$(awk '{print $1;}' <<<"$bookmark")"
        bookmark_gui_flag="$(awk '{print $4;}' <<<"$bookmark")"

        if [ -z "$bookmark_name" ]; then
            surfraw "$bookmark_name" "$bookmark_gui_flag"
        fi
        unset bookmark bookmark_name bookmark_gui_flag
    }

    ## cd into the directory of the selected file             {{{

    fcd() {
        cd "$(
            fzf --no-multi --query="$*" --select-1 --exit-0 \
                --preview="${FZF_PREVIEW_CMD}" \
                --preview-window='right:hidden:wrap' \
                --bind=ctrl-v:toggle-preview \
                --bind=ctrl-x:toggle-sort \
                --header='(view:ctrl-v) (sort:ctrl-x)' |
                xargs dirname
        )" || return
    }

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## fasd fzf integration functions                         {{{

    if is-supported fasd; then
        # selectable cd to frecency directory using fasd
        fz() {
            # shellcheck disable=2016
            cd "$(
                fasd -dl |
                    fzf --tac --reverse --no-sort --no-multi --exit-0 --select-1 \
                        --tiebreak=index --query="$*" \
                        --preview='tree -C {} | head -n $FZF_PREVIEW_LINES' \
                        --preview-window='right:hidden:wrap' \
                        --bind=ctrl-v:toggle-preview \
                        --bind=ctrl-x:toggle-sort \
                        --header='(view:ctrl-v) (sort:ctrl-x)'
            )" || return 1
        }

        # open best matched file using fasd
        # filter output of fasd using fzf when no arg is provided
        fze() {
            [ $# -gt 0 ] && fasd -f -e "${EDITOR:-vim}" "$*" && return

            file="$(
                fasd -Rfl "$1" |
                    fzf --select-1 --exit-0 --no-sort --no-multi
            )" &&
                ${EDITOR:-vim} "${file}" || return 1

            unset file
        }
    fi

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## open the selected file in the default editor           {{{

    #   - CTRL-O to open with `open` command,
    #   - CTRL-E or Enter key to open with the $EDITOR
    feo() {
        fzf --exit-0 --no-select-1 --multi --query="$*" --preview="${FZF_PREVIEW_CMD}" \
            --bind="ctrl-o:execute(o {+} >/dev/null 2>&1)" \
            --bind="ctrl-e:execute(${EDITOR:-vim} {+})+abort" \
            --bind="enter:execute(${EDITOR:-vim} {+})+abort" \
            --bind=ctrl-v:toggle-preview \
            --bind=ctrl-x:toggle-sort \
            --header='(ctrl-e:edit) (ctrl-o:open) (ctrl-v:view) (ctrl-x:sort)'
    }

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## uses rg to find text in a file                         {{{

    fif() {
        if [ ! "$#" -gt 0 ]; then
            echo "Need a string to search for!"
            return 1
        fi
        rg --files-with-matches --no-messages "$*" |
            fzf --multi --no-select-1 --exit-0 --ansi \
                --bind=ctrl-v:toggle-preview \
                --bind=ctrl-x:toggle-sort \
                --bind "ctrl-o:execute(o {})" \
                --bind "ctrl-y:execute(echo {} | cb)" \
                --bind="enter:execute(${EDITOR:-vim} {+})+abort" \
                --header='(edit:ctrl-e) (open:ctrl-o) (copy:ctrl-y) (view:ctrl-v) (sort:ctrl-x)' \
                --preview="bat --color=always {} 2> /dev/null |
                    rg --colors 'match:bg:magenta' --colors 'match:fg:white' \
                       --ignore-case --context 10 --color always '$1' ||
                    rg --ignore-case --context 10 --pretty '$1' {}"
    }

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## Select multiple files to run a command on              {{{

    # e.g. $ fmr vlc
    fmr() { fzf -m -x | xargs -d'\n' -r "$@"; }

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## finds and kills a process pid                          {{{

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

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## fgshow - git commit browser                            {{{

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

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## find an emoji                                          {{{

    # usage: $ find_emoji | cb
    if is-supported jq; then
        function femoji() {
            emoji_cache="$DOTFILES/cache/emoji.json"
            if [ ! -r "$emoji_cache" ]; then
                curl -sSLo "$emoji_cache" \
                    https://raw.githubusercontent.com/b4b4r07/emoji-cli/master/dict/emoji.json
            fi

            jq <"$emoji_cache" -r '.[] | [
            .emoji, .description, "\(.aliases | @csv)", "\(.tags | @csv)"
            ] | @tsv
            ' | fzf --prompt 'Search emojis > ' | cut -f1
            unset emoji_cache
        }
    fi

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
fi

# --------------------------------------------------------------------- }}}
# Work                                                                  {{{
# --------------------------------------------------------------------- {|}

if [ "$USE_WORK_STUFF" = "1" ]; then
    ## toggle a label used to run CC visual snapshots on PRs      {{{

    if is-supported gh; then
        cc_visual_snapshots() {
            if [ "$(gh repo view --json name -q ".name")" = "calcite-design-system" ]; then
                gh pr edit --remove-label "pr ready for visual snapshots"
                gh pr edit --add-label "pr ready for visual snapshots"
            fi
        }

        pr_check() {
            set -e
            workflow="${1:-"e2e"}"
            branch="${2:-"$(git symbolic-ref --short HEAD)"}"

            run="$(
                gh run list \
                    --limit 1 \
                    --branch "$branch" \
                    --workflow "$workflow" \
                    --json 'databaseId,conclusion' \
                    --jq '.[].databaseId,.[].conclusion'
            )"

            id="$(echo "$run" | head -n1)"

            # conclusion is an empty string if the workflow is still running
            if [ "$(echo "$run" | wc -l)" = 1 ]; then
                echo "Waiting for \"$workflow\" workflow run to complete..."
                gh run watch "$id"
                conclusion="$(gh run view "$id" --json 'conclusion' --jq '.conclusion')"
            else
                conclusion="$(echo "$run" | tail -n1)"
            fi

            echo "\"$workflow\" workflow run conclusion: ${conclusion}"

            if [ "$conclusion" = "failure" ]; then
                echo "Displaying logs for the failed jobs..."
                gh run view "$id" --log-failed

                read -rp " Rerun \"$workflow\" workflow? [y/N]: " choice
                case "$choice" in
                    y* | Y*) gh run rerun "$id" ;;
                    *) return 1 ;;
                esac
            fi
        }
    fi

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## pack CC/CCR and install them in a test app                 {{{

    # Uses `npm pack` to install CC and CCR in an example app for testing.
    #
    # TODO: figure out why CC's types aren't included in the packed tarball.
    #       Use the `cc_install_copy` script instead for now.
    #
    # NOTE: make sure to build the calcite monorepo first, then run the
    #       script from anywhere in the example app's directory.
    cc_install_pack() {
        npm_root=$(npm prefix)
        worktree_root="${1:-main}"

        # clean test project
        npm uninstall @esri/calcite-components @esri/calcite-components-react
        rm -rf \
            "$npm_root"/esri-calcite-components-*.tgz \
            "$npm_root"/package-lock.json \
            "$npm_root"/node_modules

        # pack calcite-components
        npm pack \
            --prefix "$CALCITE/$worktree_root" \
            --workspace "packages/calcite-components" \
            --pack-destination "$npm_root"

        # pack calcite-components-react if the test project has react as a dependency
        if is-supported jq && [ "$(
            jq '.dependencies | has("react")' "$npm_root/package.json"
        )" = "true" ]; then
            npm pack \
                --prefix "$CALCITE/$worktree_root" \
                --workspace "packages/calcite-components-react" \
                --pack-destination "$npm_root"
        fi

        # install the local tarball(s)
        npm install "$npm_root"/esri-calcite-components-*.tgz
    }

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## copy CC/CCR dists to a test app's node_modules             {{{

    # NOTE: make sure to build the calcite monorepo first, then run the
    #       script from anywhere in the example app's directory.
    cc_install_copy() {
        calcite_worktree="${1:-main}"

        example_npm_root=$(npm prefix)
        example_cc_path="$example_npm_root/node_modules/@esri/calcite_components/"
        example_ccr_path="$example_npm_root/node_modules/@esri/calcite_components-react/"

        mkdir -p "$example_cc_path" "$example_ccr_path"

        # copy calcite-components dist
        cp "$CALCITE/$calcite_worktree/packages/calcite-components/dist" \
            "$example_cc_path"

        # copy calcite-components-react dist if the test aapp has react as a dependency
        if is-supported jq && [ "$(
            jq '.dependencies | has("react")' "$example_npm_root/package.json"
        )" = "true" ]; then
            cp "$CALCITE/$calcite_worktree/packages/calcite-components-react/dist" \
                "$example_ccr_path"
        fi
    }

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
fi

# --------------------------------------------------------------------- }}}
