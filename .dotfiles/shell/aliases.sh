#!/usr/bin/env sh
# shellcheck disable=2139
# vim:filetype=sh foldmethod=marker:

# General {{{1
# rerun last command as sudo
alias plz='sudo $(fc -ln -1)'

# sudo with aliases
alias sudo='sudo '

# delete to trashcan if possible
if supports gio; then
    alias r='gio trash'
elif supports trash-put; then
    alias r='trash-put'
else
    alias r='rm -rf'
fi

alias x="tmux"
alias f="vifm ."

alias e='${EDITOR:-vim}'
alias se='sudo ${EDITOR:-vim}'

# minimum usable vim options
alias vmin="vim --noplugin -u DEFAULTS +'set rnu nu hid ar ai si scs ic et ts=4 sw=4 | nnoremap Y y$'"
alias v="vim --noplugin -u $HOME/.vim/standalone.vimrc"

# list all files/dirs, short format, sort by time
alias l="ls -Art --color --group-directories-first"

alias ls="ls --color --group-directories-first"

# list all files/dirs, long format, sort by time
alias ll="ls -hogArt --color --time-style=long-iso --group-directories-first"

# List directories, long format, sort by time
alias lsd="ls -radgoth */ --color --time-style=long-iso"

# Lists hidden files, long format, sort by time
alias lsh="ls -radgoth .?* --color --time-style=long-iso --group-directories-first"

# Always enable colored grep/diff/tree
supports colordiff && alias diff='colordiff'
alias grep='grep --color=auto'
alias tree='tree -C'

# Show 256 TERM colors
# shellcheck disable=2154
alias colors='i=0 && while [ $i -lt 256 ]; do echo "$(printf "%03d" $i) $(tput setaf "$i"; tput setab "$i")$(printf %$((COLUMNS - 6))s | tr " " "=")$(tput op)" && i=$((i+1)); done'

# Navigation {{{1
alias -- -="cd -"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

if supports fasd; then
    alias z='_fasd_cd -i -d'
    alias zd='_fasd_cd -d'
    alias ze='fasd -fe $EDITOR'
    alias zo='fasd -ae xdg-open'

    # function to execute built-in cd
    _fasd_cd() {
        if [ $# -le 1 ]; then
            fasd "$@"
        else
            _fasd_ret="$(fasd -e 'printf %s' "$@")"
            [ -n "$_fasd_ret" ] &&
                [ -d "$_fasd_ret" ] &&
                cd "$_fasd_ret" ||
                printf '%s\n' "$_fasd_ret"
            unset _fasd_ret
        fi
    }
fi

# Time and weather {{{1
# Gets local/UTC date and time in ISO-8601 format `YYYY-MM-DDThh:mm:ss`.
if supports date; then
    alias now='date +"%Y-%m-%dT%H:%M:%S"'
    alias unow='date -u +"%Y-%m-%dT%H:%M:%S"'
fi

# Displays detailed weather and forecast.
wttr() { curl --silent --compressed --max-time 10 --url "https://wttr.in/$*"; }
alias wthr='wttr "?format=%l:+(%C)+%c++%t+\[%h,+%w\]"'

# Network/System {{{1
alias vpn="nm-fzf vpn"
alias wifi="nm-fzf wifi"

# resume by default
alias wget='wget -c'

# searchable process list
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"

# get top processes eating memory
# shellcheck disable=2142
alias psmem='ps aux | sort -nrk 4 | awk '\''{a[NR]=$0}END{for(x=1;x<NR;x++){if(x==1)print a[NR];print a[x]}}'\'''

# get top processes eating cpu
# shellcheck disable=2142
alias pscpu='ps aux | sort -nrk 3 | awk '\''{a[NR]=$0}END{for(x=1;x<NR;x++){if(x==1)print a[NR];print a[x]}}'\'''

# Web Development {{{1
if supports chromium-browser; then
    alias debug_chromium='chromium-browser --remote-debugging-port=9222 --user-data-dir=$DOTFILES/cache/remote-debug-profile'
fi

# node/npm
if supports npm; then
    alias ni="npm install"
    alias nu="npm uninstall"
    alias ns="npm start"
    alias nl="npm link"
    alias nt="npm test"
    alias nr="npm run"
    alias nrb="npm run build"
    alias nib='rm -rf "$(npm prefix)/{node_modules,dist,build,package-lock.json}" && npm install && npm run build'

    alias ncu="npx npm-check-updates"
    alias npxplz='npx $(fc -ln -1)'

    # select an npm script to run from package.json using fzf
    supports fzf && supports jq &&
        alias fnr='npm run "$(jq -r ".scripts | keys[] " <package.json | sort | fzf)"'

    # Complete these steps before using the aliases for switching between NPM
    # accounts:
    # 1. Log into your personal account: `npm login`
    # 2. Change the name of the generated file: `mv ~/.npmrc ~/.personal.npmrc`
    # 3. Repeat steps 1 and 2 for your work account, but prepend ".work" instead
    #
    # You will not be logged into either account by default, and will need to
    # use the aliases below to switch between them. This adds an extra layer of
    # protection against accidentally publishing packages.

    # use work or personal npm account for a single command, e.g., `nw publish`
    alias nw='npm --userconfig=~/.work.npmrc'
    alias np='npm --userconfig=~/.personal.npmrc'

    # switch between work/personal npm accounts persisting for the current shell
    alias nW='export NPM_CONFIG_USERCONFIG=~/.work.npmrc && npm whoami'
    alias nP='export NPM_CONFIG_USERCONFIG=~/.personal.npmrc && npm whoami'
fi

# Linux {{{1
alias afk="loginctl lock-session"

if supports apt; then
    alias apti='sudo apt-get install'
    alias aptup='sudo apt-get update && sudo apt-get upgrade && sudo apt-get autoremove && sudo apt-get autoclean'
fi

if supports systemctl; then
    alias sc='systemctl'
    alias scu='systemctl --user'
    alias scdr='systemctl daemon-reload'
    alias scdru='systemctl --user daemon-reload'
fi

# Taskwarrior {{{1
if supports task; then
    alias t="task"
    alias ta="task add"

    supports taskopen && alias to="taskopen"
    supports tasksh && alias tsh="tasksh"
    supports taskwarrior-tui && alias tui="taskwarrior-tui"

    [ -d "$NOTES" ] && alias ts='(cd && git sync-changes "$NOTES" ".task/" "chore(task): sync")'
fi

# Git {{{1
alias g='git'
alias d='dot'

# toggle git env vars so I can use `git` instead of `dot`
alias tdot='[ "$GIT_WORK_TREE" = ~ ] && unset GIT_DIR GIT_WORK_TREE || export GIT_DIR=~/.git GIT_WORK_TREE=~'

# edit dotfiles with git plugins setup correctly. Search with Telescope if no args
alias edot="EDITOR=nvim dot edit +\"if !len(argv()) | execute 'Telescope git_files' | endif\""

# open Fugitive's status for the current or dotfiles repo
alias G='if [ "$(git rev-parse --is-inside-work-tree)" = "false" ]; then (cd && dot edit +G +only); else $EDITOR +G +only; fi'

# https://github.com/benelan/git-mux
alias gx="git-mux"
alias gxt="git-mux task"
alias gxp="git-mux project"

# Open my issues/prs in neovim - https://github.com/pwntester/octo.nvim
alias ghp='nvim +"Octo search is:open is:pr author:benelan sort:updated"'
alias ghi='nvim +"Octo issue list assignee=benelan state=OPEN"'

# Docker {{{1
if supports docker; then
    # display names of running containers
    alias dkls="docker container ls | awk 'NR > 1 {print \$NF}'"

    # delete all containers / images
    alias dkrm='docker rm $(docker ps -a -q) && docker rmi $(docker images -q)'

    # stats on images
    alias dkstat='docker stats $(docker ps -q)'

    # prune everything
    alias dkprune='docker system prune -a'

    # docker aliases for Calcite development {{{2
    if [ "$USE_WORK_STUFF" = "1" ]; then
        # I need to link these files to the current worktree
        alias cc_link_files='pushd "$(npm prefix)" >/dev/null && ln -f "$CALCITE/Dockerfile"; ln -f "$CALCITE/.marksman.toml"; ln -f "$CALCITE/calcite-components.projections.json" "./packages/calcite-components/.projections.json"; popd >/dev/null'

        alias cc_build_docker_image="docker build --tag calcite-components ."

        # Create containers to run tests and the the dev server at the same time
        # Use a bind mount so building/testing on file changes works correctly
        _cmd="docker run --init --interactive --rm --cap-add SYS_ADMIN --volume .:/app:z --user $(id -u):$(id -g)"

        alias cc_start_in_docker="$_cmd --publish 3333:3333 --name calcite-components_start calcite-components npm --workspace=@esri/calcite-components start"
        alias cc_test_in_docker="$_cmd --name calcite-components_test calcite-components npm --workspace=@esri/calcite-components run --workspace=@esri/calcite-components test:watch"
        alias cc_run_in_docker="$_cmd --name calcite-components_run calcite-components npm --workspace=@esri/calcite-components run"

        unset _cmd
    fi
    #}}}2
fi
