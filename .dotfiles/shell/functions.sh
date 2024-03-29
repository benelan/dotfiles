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

    if [ -n "$TMUX" ] && supports _tmux-select; then
        _tmux-select
    fi
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
## use vifm to cd                                             {{{

vcd() { cd "$(command vifm --choose-dir - "$@")" || return 1; }

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## make one or more directories and cd into the last one      {{{

mcd() { mkdir -p -- "$@" && cd "$_" || return 1; }

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

if supports fff; then
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

if supports pandoc; then
    # Open a markdown file in the less pager
    mdp() {
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
if supports inotifywait; then
    onchange() {
        target=${1:-.}
        shift
        printf "Watching %s for changes...\n" "$target"

        notify_cmd="echo"
        supports notify-send && notify_cmd="notify-send"

        while inotifywait -qqre modify,close_write,moved_to,move_self \
            --exclude '.git|node_modules|dist' "$target"; do
            bash -c "${*:-$notify_cmd 'changes detected' $target}"
            echo
            sleep 1
        done
        unset target
    }
fi

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## get gzipped file size                                      {{{

gz() {
    orig=$(wc -c <"$1")
    gzip=$(gzip -c "$1" | wc -c)
    ratio=$(echo "$gzip * 100/ $orig" | bc -l)
    saved=$(echo "($orig - $gzip) * 100/ $orig" | bc -l)

    printf "orig: %d bytes\ngzip: %d bytes\nsave: %2.0f%% (%2.0f%%)\n" \
        "$orig" "$gzip" "$saved" "$ratio"
    unset orig gzip ratio saved
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## create a data URL from a file                              {{{

dataurl() {
    mimetype=$(file --mime-type "$1" | cut -d ' ' -f2)
    if [ "$mimetype" = "text/*" ]; then
        mimetype="${mimetype};charset=utf-8"
    fi

    echo "data:${mimetype};base64,$(openssl base64 -in "$1" | tr -d '\n')"
    unset mimetype
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
        -subj "/CN=$1\/emailAddress=${2:-ben}@$1/C=US/ST=Oregon/L=Portland/O=Jamin, Inc."
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## list hosts defined in ssh config                           {{{

ssh-list() {
    [ -r ~/.ssh/config ] &&
        awk '$1 ~ /Host$/ {for (i=2; i<=NF; i++) print $i}' ~/.ssh/config
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## add all ssh private keys to agent                          {{{

ssh-add-all() { grep -slR "PRIVATE" ~/.ssh | xargs ssh-add; }

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
## search https://github.com/chubin/cheat.sh                  {{{

# $ cht :help
cht() {
    curl -L "cht.sh/$(
        IFS=/
        echo "$*"
    )"
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}

# --------------------------------------------------------------------- }}}
# Git                                                                   {{{
# --------------------------------------------------------------------- {|}

## checkout a branch based on fuzzy search term               {{{

# If installed, use fuzzy finder (fzf) to pick when there are multiple matches.
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
    if supports fzf; then
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
    git for-each-ref refs/remotes refs/heads \
        --sort=-committerdate \
        --format='%(refname:short)' |
        # filter by search term, remove 'origin/' prefix from refs, and dedupe
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
        while read -r branch; do mergeBase=$(
            git merge-base "$TARGET_BRANCH" "$branch"
        ) &&
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
# FZF                                                                   {{{
# --------------------------------------------------------------------- {|}

# https://github.com/junegunn/fzf/wiki/Examples
if supports fzf; then
    ## setup the preview command for files and directories    {{{

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

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## setup completion to use fd instead of find             {{{

    if supports fd; then
        # - The first argument to the function ($1) is the base path to start traversal
        # - See the source code (completion.{bash,zsh}) for the details.
        _fzf_compgen_path() {
            fd --hidden --follow --exclude "node_modules" --exclude ".git" . "$1"
        }

        # Use fd to generate the list for directory completion
        _fzf_compgen_dir() {
            fd --type d --hidden --follow --exclude "node_modules" --exclude ".git" . "$1"
        }
    fi

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## open bookmark with surfraw                             {{{

    fob() {
        bookmark="$(awk NF "$XDG_CONFIG_HOME/surfraw/bookmarks" | fzf -e)"
        bookmark_name="$(awk '{print $1;}' <<<"$bookmark")"
        bookmark_gui_flag="$(awk '{print $4;}' <<<"$bookmark")"

        if [ -z "$bookmark_name" ]; then
            surfraw "$bookmark_name" "$bookmark_gui_flag"
        fi
        unset bookmark bookmark_name bookmark_gui_flag
    }

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
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

    if supports fasd; then
        # selectable cd to frecency directory using fasd
        fz() {
            # shellcheck disable=2016
            cd "$(
                fasd -dl |
                    fzf --tac --reverse --no-sort --no-multi --exit-0 \
                        --select-1 --tiebreak=index --query="$*" \
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
        fzf --exit-0 --no-select-1 --multi --query="$*" \
            --preview="${FZF_PREVIEW_CMD}" \
            --header='(ctrl-e:edit) (ctrl-o:open) (ctrl-v:view) (ctrl-x:sort)' \
            --bind="ctrl-o:execute(o {+} >/dev/null 2>&1)" \
            --bind="ctrl-e:execute(${EDITOR:-vim} {+})+abort" \
            --bind="enter:execute(${EDITOR:-vim} {+})+abort" \
            --bind=ctrl-v:toggle-preview \
            --bind=ctrl-x:toggle-sort
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
    ## find an emoji                                          {{{

    # usage: $ find_emoji | cb
    if supports jq; then
        function femoji() {
            emojis="$DOTFILES/cache/emoji.json"
            if [ ! -r "$emojis" ]; then
                curl -sSLo "$emojis" \
                    https://raw.githubusercontent.com/b4b4r07/emoji-cli/master/dict/emoji.json
            fi

            jq <"$emojis" -r '.[] | [
                .emoji, .description, "\(.aliases | @csv)", "\(.tags | @csv)"
            ] | @tsv
            ' | fzf --no-hscroll --prompt 'Search emojis > ' | cut -f1
            unset emojis
        }
    fi

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
fi

# --------------------------------------------------------------------- }}}
# Work                                                                  {{{
# --------------------------------------------------------------------- {|}

if [ "$USE_WORK_STUFF" = "1" ]; then
    ## toggle a label used to run CC visual snapshots on PRs      {{{

    if supports gh; then
        cc_visual_snapshots() {
            if [ "$(
                gh repo view --json name -q ".name"
            )" = "calcite-design-system" ]; then
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
                conclusion="$(
                    gh run view "$id" --json 'conclusion' --jq '.conclusion'
                )"
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

        # pack calcite-components-react if the test project has react as a dep
        if supports jq && [ "$(
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

    # NOTE: make sure to build the calcite monorepo first, then run the script
    # from anywhere in the example app's directory.
    cc_install_copy() {
        calcite_worktree="${1:-main}"

        example_npm_root=$(npm prefix)
        example_cc_path="$example_npm_root/node_modules/@esri/calcite_components/"
        example_ccr_path="$example_npm_root/node_modules/@esri/calcite_components-react/"

        mkdir -p "$example_cc_path" "$example_ccr_path"

        # copy calcite-components dist
        cp "$CALCITE/$calcite_worktree/packages/calcite-components/dist" \
            "$example_cc_path"

        # copy calcite-components-react dist if the test app has react as a dep
        if supports jq && [ "$(
            jq '.dependencies | has("react")' "$example_npm_root/package.json"
        )" = "true" ]; then
            cp "$CALCITE/$calcite_worktree/packages/calcite-components-react/dist" \
                "$example_ccr_path"
        fi
    }

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
fi

# --------------------------------------------------------------------- }}}
