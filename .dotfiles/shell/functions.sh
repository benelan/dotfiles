#!/usr/bin/env bash
# vim:filetype=sh foldmethod=marker:
# shellcheck disable=2016

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
        grep -v 'google' |
        perl -pe 's/\/url\?q=//; s/&amp//g; s/\%([[:xdigit:]]{2})/chr hex $1/ge'

    if [ -n "$TMUX" ] && supports _tmux-select; then
        _tmux-select
    fi
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## make one or more directories and cd into the last one      {{{

mcd() { mkdir -p -- "$@" && cd -- "$_" || return 1; }

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## shhhhhh                                                    {{{

shh() { nohup "$@" >/dev/null 2>&1 </dev/null & }

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
# use neovim as a manpager                                    {{{

vman() { nvim "+hide Man $*"; }

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## add surfraw bookmark                                       {{{

# see fob() later in the file for finding/opening a bookmark
# the following is my personal bookmark convention
# <name> <url> <:[tag1:tag2:tag...]:> [-g]
# name - used to open the bookmark, e.g. `sr codepen`
#        I've been doing no special chars for landing pages
#        and separating with "-" when it's more specific, e.g.
#        mf https://martinfowler.com/tags/
#        mf-flaccid https://martinfowler.com/bliki/FlaccidScrum.html
# url  - the URL to open, can also be a file URI
# tags - colon-separated list of tags, none is "::"
#        https://github.com/mickael-menu/zk/blob/main/docs/tags.md
# -g   - force surfraw to open the bookmark in a GUI browser
#        only works when using fob(), not surfraw directly
bm() { echo "$*" >>"$XDG_CONFIG_HOME/surfraw/bookmarks"; }

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## Show 256 TERM colors                                       {{{

colors() {
    local i=0

    while [ $i -lt 256 ]; do
        echo "$(printf "%03d" $i) $(
            tput setaf "$i"
            tput setab "$i"
        )$(printf %$((COLUMNS - 6))s | tr " " "=")$(tput op)"
        i=$((i + 1))
    done
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## displays detailed weather and forecast                     {{{

wttr() {
    local query="$*"

    if [ "$query" = "-s" ]; then
        query="?format=%l:+(%C)+%c++%t+\[%h,+%w\]"
    fi

    curl --silent --compressed --max-time 10 --url "https://wttr.in/$query"
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## check if an array contains an specific element             {{{

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
#   $ _array-contains-element apple "@{fruits[@]}" && echo 'contains apple'
#   contains apple
#
#   $ if _array-contains-element pear "${fruits[@]}"; then
#       echo "contains pear!"
#     fi
#   contains pear!
#
#
_array-contains-element() {
    local e element="${1?}"
    shift
    for e in "$@"; do
        [[ "$e" == "${element}" ]] && return 0
    done
    return 1
}

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
        pandoc -s -f gfm -t man "${@:--}" | man -l -
        # use groff on mac: . . . . . . . | groff -T utf8 -man | less
    }

    # Convert markdown to HTML
    md2html() {
        mkdir -p "$DOTFILES/cache/pandoc"
        ! [ -f "$DOTFILES/cache/pandoc/styles.css" ] &&
            curl -Lso "$DOTFILES/cache/pandoc/styles.css" \
                https://raw.githubusercontent.com/jez/pandoc-markdown-css-theme/master/public/css/theme.css
        ! [ -f "$DOTFILES/cache/pandoc/highlight.css" ] &&
            curl -Lso "$DOTFILES/cache/pandoc/highlight.css" \
                https://raw.githubusercontent.com/jez/pandoc-markdown-css-theme/master/public/css/skylighting-paper-theme.css
        ! [ -f "$DOTFILES/cache/pandoc/template.html" ] &&
            curl -Lso "$DOTFILES/cache/pandoc/template.html" \
                https://raw.githubusercontent.com/jez/pandoc-markdown-css-theme/master/template.html5

        pandoc \
            --katex \
            --from markdown+tex_math_single_backslash \
            --to html5+smart \
            --template="$DOTFILES/cache/pandoc/template.html" \
            --css="$DOTFILES/cache/pandoc/styles.css" \
            --css="$DOTFILES/cache/pandoc/highlight.css" \
            --toc \
            --wrap=none \
            --output="$DOTFILES/cache/pandoc/output.html" \
            "$1"

        o "$DOTFILES/cache/pandoc/output.html"
    }
fi

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## run a command when a target file is modified               {{{

# $ onmodify note.md md2html note
if supports inotifywait; then
    onchange() {
        local target notify_cmd="echo"

        target=${1:-.}
        shift
        printf "Watching %s for changes...\n" "$target"

        supports notify-send && notify_cmd="notify-send"

        while inotifywait -qqre modify,close_write,moved_to,move_self \
            --exclude '.git|node_modules|dist' "$target"; do
            bash -c "${*:-$notify_cmd 'changes detected' $target}"
            sleep 1
        done
    }
fi

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## get gzipped file size                                      {{{

gz() {
    local orig gzip ratio saved

    orig=$(wc -c <"$1")
    gzip=$(gzip -c "$1" | wc -c)
    ratio=$(echo "$gzip * 100/ $orig" | bc -l)
    saved=$(echo "($orig - $gzip) * 100/ $orig" | bc -l)

    printf "orig: %d bytes\ngzip: %d bytes\nsave: %2.0f%% (%2.0f%%)\n" \
        "$orig" "$gzip" "$saved" "$ratio"
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## create a data URL from a file                              {{{

dataurl() {
    local mimetype

    mimetype=$(file --mime-type "$1" | cut -d ' ' -f2)
    if [ "$mimetype" = "text/*" ]; then
        mimetype="${mimetype};charset=utf-8"
    fi

    echo "data:${mimetype};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
## recursively search parent directory for file               {{{

# param 1: name of file or directory to find
# param 2: directory to start from (defaults to PWD)
# example: $ pfind .git
pfind() {
    test -e "${2:-$PWD}/$1" && echo "${2:-$PWD}" && return 0
    [ '/' = "${2:-$PWD}" ] && return 1
    pfind "$1" "$(dirname "${2:-$PWD}")"
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}

# --------------------------------------------------------------------- }}}
# Networking                                                            {{{
# --------------------------------------------------------------------- {|}

## get the pid of the prccess listening on the provided port  {{{

wtfport() {
    local line pid pid_name

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
## searchable process list                                    {{{

# shellcheck disable=2009
psg() { ps aux | grep -v grep | grep -i -e VSZ -e "$*"; }

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## get top processes eating memory                            {{{

psmem() {
    ps aux |
        sort -nrk 4 |
        awk '{a[NR]=$0}END{for(x=1;x<NR;x++){if(x==1)print a[NR];print a[x]}}' |
        tac
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## get top processes eating cpu                               {{{

pscpu() {
    ps aux |
        sort -nrk 3 |
        awk '{a[NR]=$0}END{for(x=1;x<NR;x++){if(x==1)print a[NR];print a[x]}}' |
        tac
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

## toggle git env vars so I can use `git` instead of `dot`    {{{
tdot() {
    if [ "$GIT_WORK_TREE" = ~ ]; then
        unset GIT_DIR GIT_WORK_TREE
    else
        export GIT_DIR=~/.git GIT_WORK_TREE=~
    fi
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## edit dotfiles with git plugins setup correctly             {{{

# searches with Telescope if no args are provided
edot() {
    EDITOR=nvim dot edit +"if !len(argv()) | execute 'Telescope git_files' | endif"
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## open Fugitive's status for the current or dotfiles repo    {{{

G() {
    if [ "$(git rev-parse --is-inside-work-tree)" = "false" ]; then
        (cd && dot edit +G +only)
    else
        $EDITOR +G +only
    fi
}

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
## delete squash merged branches                              {{{

# from https://github.com/not-an-aardvark/git-delete-squashed
gbprune() {
    local TARGET_BRANCH branch mergeBase

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

    if supports bat; then
        FZF_PREVIEW_CMD='bat --color=always --plain --line-range :$FZF_PREVIEW_LINES {}'
    elif supports pygmentize; then
        FZF_PREVIEW_CMD='head -n $FZF_PREVIEW_LINES {} | pygmentize -g'
    else
        FZF_PREVIEW_CMD='head -n $FZF_PREVIEW_LINES {}'
    fi

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## setup completion to use fd instead of find             {{{

    if supports fd; then
        # - The first argument to the function ($1) is the base path to start traversal
        _fzf_compgen_path() {
            fd --no-ignore-parent --hidden --follow --exclude "node_modules" --exclude ".git" . "$1"
        }

        # Use fd to generate the list for directory completion
        _fzf_compgen_dir() {
            fd --no-ignore-parent --hidden --follow --exclude "node_modules" --exclude ".git" --type d . "$1"
        }
    fi

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## open bookmark with surfraw                             {{{

    fbm() {
        local bookmark bookmark_name bookmark_gui_flag

        bookmark="$(awk NF "$XDG_CONFIG_HOME/surfraw/bookmarks" | fzf -e)"
        bookmark_name="$(awk '{print $1;}' <<<"$bookmark")"
        bookmark_gui_flag="$(awk '{print $4;}' <<<"$bookmark")"

        if [ -z "$bookmark_name" ]; then
            surfraw "$bookmark_name" "$bookmark_gui_flag"
        fi
    }

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## cd into the directory of the selected file             {{{

    fcd() {
        cd "$(
            FZF_DEFAULT_COMMAND='fd --type d --follow --hidden --no-ignore-parent --exclude .git --exclude node_modules' \
                fzf --no-multi --query="$*" --select-1 \
                --preview="tree -taFCI .git/ -I node_modules/ -I dist/ --gitignore --filesfirst --nolinks {}" \
                --preview-window='right:hidden:wrap' \
                --bind=ctrl-v:toggle-preview \
                --bind=ctrl-x:toggle-sort \
                --header='(view:ctrl-v) (sort:ctrl-x)'
        )" || return 1
    }

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## fasd fzf integration functions                         {{{

    if supports fasd; then
        # selectable cd to frecency directory using fasd
        fz() {
            cd "$(
                fasd -dl |
                    fzf --tac --reverse --no-sort --no-multi \
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

            local file

            file="$(
                fasd -Rfl "$1" |
                    fzf --select-1 --no-sort --no-multi
            )" &&
                ${EDITOR:-vim} "${file}" || return 1
        }
    fi

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## open the selected file in the default editor           {{{

    #   - CTRL-O to open with `open` command,
    #   - CTRL-E or Enter key to open with the $EDITOR
    feo() {
        FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --no-ignore-parent --exclude .git --exclude node_modules' \
            fzf --no-select-1 --multi --query="$*" \
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
        if [ -z "$1" ]; then
            echo "Error: missing a search query"
            return 1
        fi

        rg --files-with-matches --no-messages "$*" |
            fzf --multi --no-select-1 --ansi \
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
        local pids

        if [ "$UID" != "0" ]; then
            pids="$(ps -f -u "$UID" | sed 1d | fzf -m --select-nth 2)"
        else
            pids="$(ps -ef | sed 1d | fzf -m --select-nth 2)"
        fi

        if [ -n "$pids" ]; then
            echo "$pids" | xargs kill -"${1:-9}"
        fi
    }

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## find an emoji                                          {{{

    # usage: $ find_emoji | cb
    if supports jq; then
        function femoji() {
            local emojis="$DOTFILES/cache/emoji.json"

            if [ ! -r "$emojis" ]; then
                curl -sSLo "$emojis" \
                    https://raw.githubusercontent.com/b4b4r07/emoji-cli/master/dict/emoji.json
            fi

            jq <"$emojis" -r '.[] | [.emoji, .description, (.tags | @csv)] | @tsv' |
                fzf --prompt 'Search emojis > ' -d '\t' --no-hscroll --accept-nth 1
        }
    fi

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
fi

# --------------------------------------------------------------------- }}}
# Work                                                                  {{{
# --------------------------------------------------------------------- {|}

# select an npm script to run from package.json using fzf
if supports fzf && supports jq; then
    fnr() {
        local script
        script="$(jq -r ".scripts | keys[] " <package.json | sort | fzf)"
        [ -n "$script" ] && npm run "$script"
    }
fi

if [ "$WORK_MACHINE" = "1" ]; then
    # link some files to the current worktree                     {{{
    cc_link_files() {
        pushd "$(npm prefix)" >/dev/null
        ln -f "../.marksman.toml" ".marksman.toml"
        ln -f "$CALCITE/calcite-components.projections.json" \
            "./packages/calcite-components/.projections.json"
        popd >/dev/null
    }

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## GH cli functions specific to calcite design system         {{{

    if supports gh; then
        # toggle a label used to run CC visual snapshots on PRs
        cc_visual_snapshots() {
            [ "$(gh repo view --json name -q ".name")" = "calcite-design-system" ] &&
                gh pr edit "$1" \
                    --remove-label "pr ready for visual snapshots" \
                    --add-label "pr ready for visual snapshots"
        }

        # watch a PR check and prompt to rerun if it fails
        pr_check() {
            set -e
            local workflow branch run id conclusion choice

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

    # Make sure to build the calcite monorepo first, then run the script from
    # anywhere in the example app's directory.
    cc_install_pack() {
        local worktree example

        worktree="${1:-dev}"
        example=$(npm prefix)

        # clean test project
        npm uninstall @esri/calcite-components @esri/calcite-components-react
        rm -rf \
            "$example"/esri-calcite-components-*.tgz \
            "$example"/package-lock.json \
            "$example"/node_modules

        # pack calcite-components
        npm pack \
            --prefix "$CALCITE/$worktree" \
            --workspace "@esri/calcite-components" \
            --pack-destination "$example"

        supports jq &&
            # pack calcite-components-react if the test project has react as a dep
            [ "$(jq '.dependencies | has("react")' "$example/package.json")" = "true" ] &&
            npm pack \
                --prefix "$CALCITE/$worktree" \
                --workspace "@esri/calcite-components-react" \
                --pack-destination "$example"

        # install the local tarball(s)
        npm install "$example"/esri-calcite-components-*.tgz
    }

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## copy CC/CCR dists to a test app's node_modules             {{{

    # Make sure to build the calcite monorepo first, then run the script from
    # anywhere in the example app's directory.
    cc_install_copy() {
        local worktree example cc_path ccr_path

        worktree="${1:-dev}"
        example=$(npm prefix)

        cc_path="$example/node_modules/@esri/calcite_components/"
        ccr_path="$example/node_modules/@esri/calcite_components-react/"
        mkdir -p "$cc_path" "$ccr_path"

        # copy calcite-components dist
        cp -r "$CALCITE/$worktree/packages/calcite-components"/{dist,hydrate} "$cc_path"

        supports jq &&
            # copy calcite-components-react dist if the test app has react as a dep
            [ "$(jq '.dependencies | has("react")' "$example/package.json")" = "true" ] &&
            cp -r "$CALCITE/$worktree/packages/calcite-components-react/dist" "$ccr_path"
    }

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
    ## link CC/CCR packages to an example app                     {{{

    # Make sure to build the calcite monorepo first, then run the script from
    # anywhere in the example app's directory.
    cc_install_link() {
        local worktree example

        worktree="${1:-dev}"
        example=$(npm prefix)

        npm unlink @esri/calcite-components @esri/calcite-components-react

        (cd "$CALCITE/$worktree/packages/calcite-components" && npm link)
        (cd "$CALCITE/$worktree/packages/calcite-components-react" && npm link)

        npm link @esri/calcite-components "$(
            supports jq &&
                # only link calcite-components-react if the test app has react as a dep
                [ "$(jq '.dependencies | has("react")' "$example/package.json")" = "true" ] &&
                echo "@esri/calcite-components-react"
        )"
    }

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -}}}
fi
