#!/usr/bin/env sh

# General                                                               {{{
# --------------------------------------------------------------------- {|}

alias c='clear'
alias q='exit'

alias x="tmux"

# rerun last command as sudo
alias plz='sudo $(fc -ln -1)'
# Enable aliases to be sudo’ed
alias sudo='sudo '

alias mkd='mkdir -p'
alias rr='rm -rf'

# copy to clipboard from file
alias cbf="xclip -se c <"

alias -- -="vifm ."
alias e='${EDITOR:-vim}'
alias se='sudo e'
# minimum usable vim options
alias v="vim -u DEFAULTS +'set rnu nu hid ar et ts=4 sw=4 | nnoremap Y y$'"

# Directory listing/traversal
COLORS_SUPPORTED=$(is-supported "ls --color" --color -G)
TIMESTYLEISO_SUPPORTED=$(is-supported "ls --time-style=long-iso" --time-style=long-iso)
GROUPDIRSFIRST_SUPPORTED=$(is-supported "ls --group-directories-first" --group-directories-first)

# shellcheck disable=2139
alias ls="ls $COLORS_SUPPORTED"
# list all files/dirs, short format, sort by time
# shellcheck disable=2139
alias l="ls -Art $COLORS_SUPPORTED $GROUPDIRSFIRST_SUPPORTED"
# list all files/dirs, long format, sort by time
# shellcheck disable=2139
alias ll="ls -hogArt $COLORS_SUPPORTED $TIMESTYLEISO_SUPPORTED $GROUPDIRSFIRST_SUPPORTED"
# List directories, long format, sort by time
# shellcheck disable=2139
alias lsd="ls -radgoth */ $COLORS_SUPPORTED $TIMESTYLEISO_SUPPORTED"
# Lists hidden files, long format, sort by time
# shellcheck disable=2139
alias lsh="ls -radgoth .?* $COLORS_SUPPORTED $TIMESTYLEISO_SUPPORTED $GROUPDIRSFIRST_SUPPORTED"

# Always enable colored `grep` output (`GREP_OPTIONS="--color=auto"` is deprecated)
alias grep='grep --color=auto'

# Colorizes diff output,if possible
is-supported colordiff && alias diff='colordiff'

# Finds directories.
alias fdd='find . -type d -name'
# Finds files.
alias fdf='find . -type f -name'

# List declared aliases, functions, paths
# shellcheck disable=2139
alias aliases="alias | awk '{gsub(\"(alias |=.*)\",\"\"); print $1};'"
# shellcheck disable=2139
alias functions="declare -f | awk '/^[a-z].* ()/{gsub(\" .*$\",\"\"); print $1};'"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

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
if is-supported curl; then
    wttr() { curl --silent --compressed --max-time 10 --url "https://wttr.in/$*"; }
elif is-supported wget; then
    wttr() { wget -qO- --compression=auto --timeout=10 "https://wttr.in/$*"; }
fi
alias weather='wttr "?format=%l:+(%C)+%c++%t+\[%h,+%w\]"'

# --------------------------------------------------------------------- }}}
# Networking                                                            {{{
# --------------------------------------------------------------------- {|}

alias hosts='sudo $EDITOR /etc/hosts'

alias speedtest="wget -O /dev/null http://speed.transip.nl/100mb.bin"

alias vpn="protonvpn-cli"

# Stop after sending count ECHO_REQUEST packets
alias ping='ping -c 5'

# Pings hostname(s) 30 times in quick succession
alias fastping='ping -c 30 -i.2'

# resume by default
alias wget='wget -c'

# systemd shortcuts (Linux)
alias sctl='systemctl'

# view HTTP traffic
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# display iptables rules
alias ipt='sudo /sbin/iptables'
alias iptlist='sudo /sbin/iptables -n -v --line-numbers -L'

if is-supported ps; then
    # searchable process list
    alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
    # get top processes eating memory
    alias psmem='ps auxf | sort -nrk 4 | perl -e "print reverse <>"'
    # get top processes eating cpu
    alias pscpu='ps auxf | sort -nrk 3 | perl -e "print reverse <>"'
fi

# -----------------------------------------------------------------------------
# Web Development
# -----------------------------------------------------------------------------

alias chrome_debug="google-chrome --remote-debugging-port=9222 --user-data-dir=remote-debug-profile"

# node/npm
if is-supported npm; then
    alias ni="npm install"
    alias nu="npm uninstall"
    alias ns="npm start"
    alias nl="npm link"
    alias nt="npm test"
    alias nr="npm run"
    alias nrb="npm run build"

    alias ncu="npx npm-check-updates"
    alias npxplz='npx $(fc -ln -1)'

    if is-supported fzf; then
        is-supported jq &&
            alias fnr='npm run "$(jq -r ".scripts | keys[] " <package.json | sort | fzf)"'
    fi
fi

# --------------------------------------------------------------------- }}}
# Ubuntu/GNOME                                                          {{{
# --------------------------------------------------------------------- {|}

if is-supported apt; then
    alias apti='sudo apt install'
    alias aptup='sudo apt update && sudo apt upgrade && sudo apt autoremove'
fi

# Locks the session.
is-supported gnome-screensaver-command &&
    alias afk='gnome-screensaver-command --lock'

# --------------------------------------------------------------------- }}}
# Taskwarrior                                                           {{{
# --------------------------------------------------------------------- {|}

if is-supported task; then
    alias t="task"
    alias ta="task add"
    alias tcw="task context work"
    alias tch="task context home"
    alias tcn="task context none"

    if is-supported taskopen; then
        alias to="taskopen"
        alias toa='$XDG_DATA_HOME/taskopen/scripts/users/artur-shaik/attach_vifm'
    fi

    is-supported taskwarrior-tui && alias tui="taskwarrior-tui"
    is-supported tasksh && alias tsh="tasksh"

    # shellcheck disable=2154
    [ -d "$NOTES" ] && alias ts='git -C "$NOTES" add .task &&
      git -C "$NOTES" commit -m "chore(task): sync" || true &&
      git -C "$NOTES" pull || true &&
      git -C "$NOTES" push'
fi

# --------------------------------------------------------------------- }}}
# Git                                                                   {{{
# --------------------------------------------------------------------- {|}

alias g='git'
alias x="git-mux"
alias xt="git-mux task"
alias xp="git-mux project"
alias xs="git-mux project ~"

# --------------------------------------------------------------------- }}}
# Dotfiles                                                              {{{
# --------------------------------------------------------------------- {|}

# setup the alias for managing dotfiles
# It behaves like git, and can be called from any directory, e.g.
# $ dot add .nuxtrc && dot commit -m "chore: add nuxtrc" && dot push
# The whole home directory excluding the dotfiles is untracked.
# Prevent `dot clean` so everything isn't deleted.
# Most of the important stuff is gitignored anyway.
dot() {
    if [ "$1" = "clean" ]; then
        echo "Don't delete your home directory, dumbass"
    else
        /usr/bin/git --git-dir="$HOME"/.git/ --work-tree="$HOME" "$@"
    fi
}

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
alias G="edit_dotfiles +G +'wincmd o'"

# --------------------------------------------------------------------- }}}
# GitHub                                                                {{{
# --------------------------------------------------------------------- {|}

# https://cli.github.com/
# Open Octo with my issues/prs
alias ghp='nvim +"Octo search is:open is:pr author:benelan sort:updated"'
alias ghi='nvim +"Octo issue list assignee=benelan state=OPEN<CR>"'

# --------------------------------------------------------------------- }}}
# Docker                                                                {{{
# --------------------------------------------------------------------- {|}

if is-supported docker; then
    ## general docker aliases                                 {{{
    # display names of running containers
    alias dkrls="docker container ls | awk 'NR > 1 {print \$NF}'"
    # delete all containers / images
    alias dkrR='docker rm $(docker ps -a -q) && docker rmi $(docker images -q)'
    # stats on images
    alias dkrstats='docker stats $(docker ps -q)'
    # list images installed
    alias dkrimg='docker images'
    # prune everything
    alias dkrprune='docker system prune -a'

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}

    ## work docker aliases for calcite-components             {{{
    if [ "$USE_WORK_STUFF" = "1" ]; then
        # workaround to run e2e tests on ubuntu due to a Stencil bug
        # https://github.com/ionic-team/stencil/issues/3853
        # Uses a bind mount so works for local development
        cc_docker_cmd="docker run --init --interactive --rm --cap-add SYS_ADMIN --volume .:/app:z --user $(id -u):$(id -g)"

        # shellcheck disable=2139
        alias cc_start_in_docker="$cc_docker_cmd --publish 3333:3333 --name calcite-components-start calcite-components npm --workspace=@esri/calcite-components start"

        # shellcheck disable=2139
        alias cc_test_in_docker="$cc_docker_cmd --name calcite-components_test calcite-components npm --workspace=@esri/calcite-components run test -- -- --watch"

        # shellcheck disable=2139
        alias cc_run_in_docker="$cc_docker_cmd --name calcite-components_run calcite-components npm --workspace=@esri/calcite-components run"

        alias cc_build_docker_image="docker build --tag calcite-components ."

        # I need to link the Dockerfile to the current git worktree
        alias cc_link_dockerfile='ln -f $WORK/calcite-design-system/Dockerfile'

        unset cc_docker_cmd
    fi

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
fi

# --------------------------------------------------------------------- }}}
