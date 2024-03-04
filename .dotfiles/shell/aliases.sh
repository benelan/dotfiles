#!/usr/bin/env sh

# General                                                               {{{
# --------------------------------------------------------------------- {|}

# rerun last command as sudo
alias plz='sudo $(fc -ln -1)'

# sudo with aliases
alias sudo='sudo '

alias mkd='mkdir -p'

# delete to trashcan if possible
if is-supported gio; then
    alias r='gio trash'
elif is-supported trash-put; then
    alias r='trash-put'
else
    alias r='rm -rf'
fi

alias x="tmux"

alias -- -="vifm ."

alias e='${EDITOR:-vim}'
alias se='sudo ${EDITOR:-vim}'

# minimum usable vim options
alias v="vim -u DEFAULTS --noplugin +'set rnu nu hid ar scs ic et ts=4 sw=4 | nnoremap Y y$'"

# Directory listing/traversal
_color=$(is-supported "ls --color" --color -G)
_time_style=$(is-supported "ls --time-style=long-iso" --time-style=long-iso)
_group_dirs=$(is-supported "ls --group-directories-first" --group-directories-first)

# shellcheck disable=2139
alias ls="ls $_color $_group_dirs"

# list all files/dirs, short format, sort by time
# shellcheck disable=2139
alias l="ls -Art $_color $_group_dirs"

# list all files/dirs, long format, sort by time
# shellcheck disable=2139
alias ll="ls -hogArt $_color $_time_style $_group_dirs"

# List directories, long format, sort by time
# shellcheck disable=2139
alias lsd="ls -radgoth */ $_color $_time_style"

# Lists hidden files, long format, sort by time
# shellcheck disable=2139
alias lsh="ls -radgoth .?* $_color $_time_style $_group_dirs"

unset _color _time_style _group_dirs

# Always enable colored `grep` output (`GREP_OPTIONS="--color=auto"` is deprecated)
alias grep='grep --color=auto'

# Colorizes diff output, if possible
is-supported colordiff && alias diff='colordiff'

# List declared aliases and functions
# shellcheck disable=2139
alias aliases="alias | awk '{gsub(\"(alias |=.*)\",\"\"); print $1};'"

# shellcheck disable=2139
alias functions="declare -f | awk '/^[a-z].* ()/{gsub(\" .*$\",\"\"); print $1};'"

# Show 256 TERM colors
# shellcheck disable=2154
alias colors='i=0 && while [ $i -lt 256 ]; do echo "$(printf "%03d" $i) $(tput setaf "$i"; tput setab "$i")$(printf %$((COLUMNS - 6))s | tr " " "=")$(tput op)" && i=$((i+1)); done'

# --------------------------------------------------------------------- }}}
# Navigation                                                            {{{
# --------------------------------------------------------------------- {|}

alias -- --="cd -"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

if is-supported fasd; then
    alias za='fasd -a'
    alias zs='fasd -si'
    alias zsd='fasd -sid'
    alias zsf='fasd -sif'
    alias zd='fasd -d'
    alias zf='fasd -f'
    alias ze='zf -e $EDITOR'
    alias zo='za -e xdg-open'
    alias z='_fasd_cd -d'
    alias zz='_fasd_cd -d -i'

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

# --------------------------------------------------------------------- }}}
# Time and weather                                                      {{{
# --------------------------------------------------------------------- {|}

# Gets local/UTC date and time in ISO-8601 format `YYYY-MM-DDThh:mm:ss`.
if is-supported date; then
    alias now='date +"%Y-%m-%dT%H:%M:%S"'
    alias unow='date -u +"%Y-%m-%dT%H:%M:%S"'
fi

# Displays detailed weather and forecast.
wttr() { curl --silent --compressed --max-time 10 --url "https://wttr.in/$*"; }
alias weather='wttr "?format=%l:+(%C)+%c++%t+\[%h,+%w\]"'

# --------------------------------------------------------------------- }}}
# Networking                                                            {{{
# --------------------------------------------------------------------- {|}

alias vpn="protonvpn-cli"

# Stop after sending count ECHO_REQUEST packets
alias ping='ping -c 5'

# Pings hostname(s) 30 times in quick succession
alias fping='ping -c 30 -i.2'

# resume by default
alias wget='wget -c'

# view HTTP traffic
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# display iptables rules
alias iptlist='sudo /sbin/iptables -n -v --line-numbers -L'

# searchable process list
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"

# get top processes eating memory
alias psmem='ps auxf | sort -nrk 4 | perl -e "print reverse <>"'

# get top processes eating cpu
alias pscpu='ps auxf | sort -nrk 3 | perl -e "print reverse <>"'

# -----------------------------------------------------------------------------
# Web Development
# -----------------------------------------------------------------------------

alias debug_chromium='chromium-browser --remote-debugging-port=9222 --user-data-dir=$DOTFILES/cache/remote-debug-profile'

# node/npm
if is-supported npm; then
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
    is-supported fzf && is-supported jq &&
        alias fnr='npm run "$(jq -r ".scripts | keys[] " <package.json | sort | fzf)"'

    # Complete these steps before using the aliases for switching between NPM accounts:
    # 1. Log into your personal account: `npm login`
    # 2. Append "-personal" to the generated file: `mv ~/.npmrc ~/.npmrc-personal`
    # 3. Repeat steps 1 and 2 for your work account, but append "-work" instead

    # You will not be logged into either account by default, and will need to use
    # the aliases below to switch between them. This adds an extra layer of security
    # against accidentally publishing packages.

    # use work or personal npm account for a single command, e.g., `nw publish`
    alias nw='npm --userconfig=~/.npmrc-work'
    alias np='npm --userconfig=~/.npmrc-personal'

    # switch between work/personal npm accounts persisting for the current shell
    alias nW='export NPM_CONFIG_USERCONFIG=~/.npmrc-work && npm whoami'
    alias nP='export NPM_CONFIG_USERCONFIG=~/.npmrc-personal && npm whoami'
fi

# --------------------------------------------------------------------- }}}
# Ubuntu/GNOME                                                          {{{
# --------------------------------------------------------------------- {|}

if is-supported apt; then
    alias apti='sudo apt install'
    alias aptup='sudo apt update && sudo apt upgrade && sudo apt autoremove && sudo apt autoclean && sudo apt autopurge'
fi

# Locks the session.
is-supported gnome-screensaver-command && alias afk='gnome-screensaver-command --lock'

# --------------------------------------------------------------------- }}}
# Taskwarrior                                                           {{{
# --------------------------------------------------------------------- {|}

if is-supported task; then
    alias t="task"
    alias ta="task add"

    is-supported taskopen && alias to="taskopen"
    is-supported tasksh && alias tsh="tasksh"
    is-supported taskwarrior-tui && alias tui="taskwarrior-tui"

    # shellcheck disable=2154
    [ -d "$NOTES" ] && alias ts='git sync-changes "$NOTES" ".task/" "chore(task): sync"'
fi

# --------------------------------------------------------------------- }}}
# Git                                                                   {{{
# --------------------------------------------------------------------- {|}

alias g='git'

# https://github.com/benelan/git-mux
alias gx="git-mux"
alias gxt="git-mux task"
alias gxp="git-mux project"
alias gxs='git-mux project $PWD'

# --------------------------------------------------------------------- }}}
# Dotfiles                                                              {{{
# --------------------------------------------------------------------- {|}

alias d='dot'

# creates env vars so git plugins work with the bare dotfiles repo
edit_dotfiles() {
    # shellcheck disable=2016
    "$EDITOR" "$@" \
        --cmd "if len(argv()) > 0 | cd %:h | endif" \
        --cmd 'let $GIT_WORK_TREE = expand("~")' \
        --cmd 'let $GIT_DIR = expand("~/.git")'
}

alias edot="edit_dotfiles +\"if !len(argv()) | execute 'Telescope git_files' | endif\""
alias G="edit_dotfiles +G +only"

# --------------------------------------------------------------------- }}}
# GitHub                                                                {{{
# --------------------------------------------------------------------- {|}

# https://cli.github.com/
# Open Octo with my issues/prs
alias ghp='nvim +"Octo search is:open is:pr author:benelan sort:updated"'
alias ghi='nvim +"Octo issue list assignee=benelan state=OPEN"'

# --------------------------------------------------------------------- }}}
# Docker                                                                {{{
# --------------------------------------------------------------------- {|}

if is-supported docker; then
    ## general docker aliases                                 {{{

    # display names of running containers
    alias dkls="docker container ls | awk 'NR > 1 {print \$NF}'"

    # delete all containers / images
    alias dkrm='docker rm $(docker ps -a -q) && docker rmi $(docker images -q)'

    # stats on images
    alias dkstat='docker stats $(docker ps -q)'

    # prune everything
    alias dkprune='docker system prune -a'

fi

# --------------------------------------------------------------------- }}}
# Work                                                                  {{{
# --------------------------------------------------------------------- {|}

if [ "$USE_WORK_STUFF" = "1" ]; then
    # I need to link these files to the current worktree
    alias cc_link_files='ln -f $CALCITE/Dockerfile && ln -f $CALCITE/.marksman.toml && ln -f $CALCITE/calcite-components.projections.json ./packages/calcite-components/.projections.json'

    alias cc_build_docker_image="docker build --tag calcite-components ."

    # Create containers to run tests and the the dev server at the same time
    # Use a bind mount so building/testing on file changes works correctly
    _cmd="docker run --init --interactive --rm --cap-add SYS_ADMIN --volume .:/app:z --user $(id -u):$(id -g)"

    # shellcheck disable=2139
    alias cc_start_in_docker="$_cmd --publish 3333:3333 --name calcite-components_start calcite-components npm --workspace=@esri/calcite-components start"

    # shellcheck disable=2139
    alias cc_test_in_docker="$_cmd --name calcite-components_test calcite-components npm --workspace=@esri/calcite-components run --workspace=@esri/calcite-components test:watch"

    # shellcheck disable=2139
    alias cc_run_in_docker="$_cmd --name calcite-components_run calcite-components npm --workspace=@esri/calcite-components run"

    unset _cmd
fi

# --------------------------------------------------------------------- }}}
