#!/usr/bin/env sh

# -----------------------------------------------------------------------------
# General
# -----------------------------------------------------------------------------

alias c='clear'
alias q='exit'

# rerun last command as sudo
alias plz='sudo $(fc -ln -1)'
# Enable aliases to be sudo’ed
alias sudo='sudo '

alias mkd='mkdir -p'
alias rr='rm -rf'

# copy to clipboard from file
alias cbf="xclip -se c <"

alias -- -="vifm || fff"
alias t="tmux"
alias e='${EDITOR:-vim}'
alias se='sudo e'

# Directory listing/traversal
COLORS_SUPPORTED=$(is-supported "ls --color" --color -G)
TIMESTYLEISO_SUPPORTED=$(is-supported "ls --time-style=long-iso" --time-style=long-iso)
GROUPDIRSFIRST_SUPPORTED=$(is-supported "ls --group-directories-first" --group-directories-first)

alias ls='ls $COLORS_SUPPORTED'
# list all files/dirs, short format, sort by time
alias l='ls -Art $COLORS_SUPPORTED $GROUPDIRSFIRST_SUPPORTED'
# list all files/dirs, long format, sort by time
alias ll='ls -hogArt $COLORS_SUPPORTED $TIMESTYLEISO_SUPPORTED $GROUPDIRSFIRST_SUPPORTED'
# List directories, long format, sort by time
alias lsd='ls -radgoth */ $COLORS_SUPPORTED $TIMESTYLEISO_SUPPORTED'
# Lists hidden files, long format, sort by time
alias lsh='ls -radgoth .?* $COLORS_SUPPORTED $TIMESTYLEISO_SUPPORTED $GROUPDIRSFIRST_SUPPORTED'

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
alias paths='echo -e ${PATH//:/\\n}'

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Show 256 TERM colors
# shellcheck disable=2154
alias colors='i=0 && while [ $i -lt 256 ]; do echo "$(printf "%03d" $i) $(tput setaf "$i"; tput setab "$i")$(printf %$((COLUMNS - 6))s | tr " " "=")$(tput op)" && i=$((i+1)); done'

# -----------------------------------------------------------------------------
# Navigation
# -----------------------------------------------------------------------------

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

# -----------------------------------------------------------------------------
# Time
# -----------------------------------------------------------------------------

# Gets local/UTC date and time in ISO-8601 format `YYYY-MM-DDThh:mm:ss`.
if is-supported date; then
    alias now='date +"%Y-%m-%dT%H:%M:%S"'
    alias unow='date -u +"%Y-%m-%dT%H:%M:%S"'
fi

# -----------------------------------------------------------------------------
# Weather
# -----------------------------------------------------------------------------

# Displays detailed weather and forecast.
if is-supported curl; then
    alias wttr="curl wttr.in"
    alias weather='curl --silent --compressed --max-time 10 --url "https://wttr.in/?format=%l:+(%C)+%c++%t+\[%h,+%w\]"'
    alias forecast='curl --silent --compressed --max-time 10 --url "https://wttr.in?F"'
elif is-supported wget; then
    alias weather='wget -qO- --compression=auto --timeout=10 "https://wttr.in/?format=%l:+(%C)+%c++%t+\[%h,+%w\]"'
    alias forecast='wget -qO- --compression=auto --timeout=10 "https://wttr.in?F"'
fi

# -----------------------------------------------------------------------------
# Networking
# -----------------------------------------------------------------------------

alias hosts='sudo $EDITOR /etc/hosts'

alias speedtest="wget -O /dev/null http://speed.transip.nl/100mb.bin"

alias vpn="protonvpn-cli"

# Stop after sending count ECHO_REQUEST packets
alias ping='ping -c 5'

# Pings hostname(s) 30 times in quick succession
alias fastping='ping -c 30 -i.2'

# resume by default
alias wget='wget -c'

# Output all matched Git SHAs
alias match-git-sha="grep -oE '\b[0-9a-f]{5,40}\b'"

# Output all matched Git SHA ranges (e.g., 123456..654321)
alias match-git-range="grep -oE '[0-9a-fA-F]+\.\.\.?[0-9a-fA-F]+'"

# Output all matched IP addresses
alias match-ip="grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'"

# Output all matched URIs
alias match-uri="grep -P -o '(?:https?://|ftp://|news://|mailto:|file://|\bwww\.)[a-zA-Z0-9\-\@;\/?:&=%\$_.+!*\x27,~#]*(\([a-zA-Z0-9\-\@;\/?:&=%\$_.+!*\x27,~#]*\)|[a-zA-Z0-9\-\@;\/?:&=%\$_+*~])+'"

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

# systemd shortcuts (Linux)
if is-supported systemctl; then
    alias sc='systemctl'
    alias sclt='systemctl list-units --type target --all'
fi

# Gets external IP address
if is-supported dig; then
    alias publicip='dig +short myip.opendns.com @resolver1.opendns.com'
elif is-supported curl; then
    alias publicip='curl --silent --compressed --max-time 5 --url "https://ipinfo.io/ip"'
elif is-supported wget; then
    alias publicip='wget -qO- --compression=auto --timeout=5 "https://ipinfo.io/ip"'
fi

# Sends HTTP requests
if is-supported lwp-request; then
    for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
        # shellcheck disable=2139
        alias $method="lwp-request -m '$method'"
    done
    unset method
fi

# -----------------------------------------------------------------------------
# Docker
# -----------------------------------------------------------------------------

if is-supported docker; then
    # display names of running containers
    alias dockls="docker container ls | awk 'NR > 1 {print \$NF}'"
    # delete every containers / images
    alias dockR='docker rm $(docker ps -a -q) && docker rmi $(docker images -q)'
    # stats on images
    alias dockstats='docker stats $(docker ps -q)'
    # list images installed
    alias dockimg='docker images'
    # prune everything
    alias dockprune='docker system prune -a'
fi

# -----------------------------------------------------------------------------
# Node/NPM
# -----------------------------------------------------------------------------

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
        is-supported npm-fuzzy && alias nfz="npm-fuzzy"
        is-supported jq &&
            alias fnr='npm run "$(jq -r ".scripts | keys[] " <package.json | sort | fzf)"'
    fi
fi

# -----------------------------------------------------------------------------
# Ubuntu/GNOME
# -----------------------------------------------------------------------------

if is-supported apt; then
    alias apti='sudo apt install'
    alias aptup='sudo apt update && sudo apt upgrade'
fi

# Locks the session.
is-supported gnome-screensaver-command &&
    alias afk='gnome-screensaver-command --lock'

# -----------------------------------------------------------------------------
# Git
# -----------------------------------------------------------------------------

alias g='git'

# deletes local branches already squash merged into the default branch
# shellcheck disable=2016,2034,2154
alias gbprune='TARGET_BRANCH="$(git bdefault)" && git fetch --prune --all && git checkout -q "$TARGET_BRANCH" && git for-each-ref refs/heads/ "--format=%(refname:short)" | grep -v -e main -e master -e develop -e dev | while read -r branch; do mergeBase=$(git merge-base "$TARGET_BRANCH" "$branch") && [[ "$(git cherry "$TARGET_BRANCH" "$(git commit-tree "$(git rev-parse "$branch"\^{tree})" -p "$mergeBase" -m _)")" == "-"* ]] && git branch -D "$branch"; done; unset TARGET_BRANCH mergeBase branch'

# add
######
alias ga='git add'
alias gall='git add --all'

# branch
#########
alias gb='git branch'
alias gbD='git branch --delete --force'
alias gbuoc='git branch -u origin/$(git symbolic-ref --short HEAD)'

# for-each-ref
###############
# https://stackoverflow.com/a/58623139/10362396
alias gbc="git for-each-ref --format='%(color:cyan)%(authordate:format:%m/%d/%Y %I:%M %p) \
  %(align:25,left)%(color:yellow)%(authorname)%(end) %(color:reset)%(refname:strip=3)' \
  --sort=authordate refs/remotes"

# commit
#########
alias gc='git commit --verbose'
alias gca='git commit --verbose --all'
alias gcm='git commit --verbose -m'
# Add uncommitted and unstaged changes to the last commit
alias gcamd='git commit --verbose --amend'
alias gcamdne='git commit --amend --no-edit'

# checkout
###########
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git checkout "$(git bdefault)"'

# clone
########
alias gcl='git clone'

# diff
#######
alias gdf='git diff'
alias gdfs='git diff --staged'
alias gdft='git difftool'
# edit the files changed locally
alias ge='$EDITOR $(git diff --name-only HEAD)'
# sync origin's default branch and edit the changed files
# shellcheck disable=2154
alias geom='default_branch=$(git bdefault); git fetch; git merge "origin/$default_branch"; $EDITOR $(git diff --name-only HEAD "origin/$default_branch"); unset default_branch'
# open Diffview.nvim
egdf() { nvim +"DiffviewOpen $*"; }

# fetch
########
alias gf='git fetch --all --prune'

# log
######
alias ggr='git log --graph --abbrev-commit --date=relative --pretty=format:'\''%C(bold)%C(blue)%h%Creset%C(auto)%d%Creset %s %C(yellow)<%an> %C(cyan)(%cr)%Creset'\'''
alias gll='git log --stat --pretty=format:'\''%C(blue)%h %Cgreen%an%Creset %C(yellow)%cd%Creset %C(auto)%d %s%+b%n%Creset'\'''
alias gg=' git log --graph'
# show branches with unpushed commits
# https://stackoverflow.com/questions/39220870/in-git-list-names-of-branches-with-unpushed-commits
alias glup='git log --branches --not --remotes --no-walk --decorate --oneline'
# show commits in current branch that aren't merged to the default branch
alias glum='git log "$(git bdefault)" ^HEAD'
# show new commits created by the last command, e.g. pull
alias gnew='git log HEAD@{1}..HEAD@{0}'

# files
########
# Show untracked files
alias glsut='git ls-files . --exclude-standard --others'
# Show unmerged (conflicted) files
alias glsum='git diff --name-only --diff-filter=U'

# merge
########
alias gm='git merge'
alias gmm='git merge "$(git bdefault)"'
alias gmom='git fetch && git merge "origin/$(git bdefault)"'
alias gmt='git mergetool'

# push
#######
alias gp='git push'
alias gpuoc='git push --set-upstream origin $(git symbolic-ref --short HEAD)'

# pull
#######
alias gpl='git pull'
alias gplum='git pull upstream "$(git bdefault)"'

# rebase
#########
alias grb='git rebase'
alias grbma='GIT_SEQUENCE_EDITOR=: git rebase "$(git bdefault)" -i --autosquash'
# Rebase with latest remote
alias gfrom='default_branch="(git bdefault)"; git fetch origin "$default_branch" && git rebase "origin/$default_branch" && git update-ref "refs/heads/$default_branch" "origin/$default_branch"; unset default_branch'

# reset
########
alias gr='git reset'
alias grs='git reset --soft'
alias grH='git reset --hard'
alias gpristine='git reset --hard && git clean -dfx'

# status
#########
alias gs='git status'

# stash
########
alias gst='git stash'
alias gstl='git stash list'
alias gstpo='git stash pop'
# 'stash push' introduced in git v2.13.2
alias gstpu='git stash push'

# submodules
#############
alias gsmu='git submodule update --init --recursive'

# tag
######
alias gt='git tag'
# outputs the tag following the provided commit sha
# useful for finding the first reproducible version
# for bugs after using git bisect to get the sha
# $ gtnext 84a29d4 # => v1.0.0-next.295~8 (8 commits before the tag)
alias gtnext='git name-rev --tags --name-only'

# worktree
##########
alias gw='git worktree'
alias gwa='git worktree add'
alias gwr='git worktree remove'
alias gwl='git worktree list'
alias gwp='git worktree prune'

alias groot='cd "$(git rev-parse --show-toplevel)"'
alias ghide='git update-index --assume-unchanged'
alias gunhide='git update-index --no-assume-unchanged'

# plugins
##########
alias gx="git mux"
alias glz="lazygit"
# delete multiple branches
alias fgbd="git branch | fzf --multi | xargs git branch -d"
# fgcoc - checkout git commit
alias fgcoc='git log --pretty=oneline --abbrev-commit --reverse | fzf --tac +s +m -e | sed "s/ .*//" | xargs git checkout'
# get git commit sha
alias fgcs='git log --color=always --pretty=oneline --abbrev-commit --reverse | fzf --tac +s +m -e --ansi --reverse | sed "s/ .*//"'

# -----------------------------------------------------------------------------
# Dotfiles
# -----------------------------------------------------------------------------

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

# creates env vars so git plugins
# work with the bare dotfiles repo
edit_dotfiles() {
    # shellcheck disable=2016
    "$EDITOR" "${@:-}" \
        --cmd "if len(argv()) > 0 | cd %:h | endif" \
        --cmd 'let $GIT_WORK_TREE = expand("~")' \
        --cmd 'let $GIT_DIR = expand("~/.git")'
}

eddf() { edit_dotfiles +"DiffviewOpen $*"; }
alias edot="edit_dotfiles +\"if !len(argv()) | execute 'Telescope git_files' | endif\""
alias envim="edit_dotfiles ~/.config/nvim/init.lua"
alias G="edit_dotfiles +G +'wincmd o'"

# add
######
alias da='dot add'
# doesn't add untracked files
alias dall='dot add --update'

# branch
#########
alias db='dot branch'

# commit
#########
alias dc='dot commit --verbose'
alias dcm='dot commit --verbose -m'
alias dcamd='dot commit --amend'
alias dcamdne='dot commit --amend --no-edit'

# checkout
###########
alias dco='dot checkout'
alias dcob='dot checkout -b'
alias dcom='dot checkout master'

# diff
#######
alias ddf='dot diff'
alias ddfs='dot diff --staged'
alias ddft='dot difftool'
alias de='$EDITOR $(dot diff --name-only)'

# log
######
alias dgg='dot log --graph --pretty=format:'\''%C(bold)%h%Creset%C(magenta)%d%Creset %s %C(yellow)<%an> %C(cyan)(%cr)%Creset'\'' --abbrev-commit --date=relative'
alias dgf='dot log --graph --date=short --pretty=format:'\''%C(auto)%h %Cgreen%an%Creset %Cblue%cd%Creset %C(auto)%d %s'\'''
alias dgup='dot log --branches --not --remotes --no-walk --decorate --oneline'

# merge
########
alias dm='dot merge'
alias dmm='dot merge "$(dbdefault)"'
alias dmt='dot mergetool'

# pull
#######
alias dpl='dot pull'

# push
#######
alias dp='dot push'
alias dpuoc='dot push --set-upstream origin $(dot symbolic-ref --short HEAD)'

# reset
########
alias dr='dot reset'
alias drH='dot reset --hard'

# stash
########
alias dst='dot stash'
alias dstl='dot stash list'
alias dstpo='dot stash pop'
alias dstpu='dot stash push'

# status
#########
alias ds='dot status'

# submodules
#############
alias dsmu='dot submodule update --init --recursive'

# update-index
##############
alias dhide='dot update-index --assume-unchanged'
alias dunhide='dot update-index --no-assume-unchanged'

# plugins
##########
# shellcheck disable=2139
alias lazydot="lazygit --git-dir='$HOME/.git' --work-tree='$HOME'"
alias dlz="lazydot"

# -----------------------------------------------------------------------------
# GitHub
# -----------------------------------------------------------------------------

# https://cli.github.com/
# https://github.com/dlvhdr/gh-dash
alias ghd="gh dash"
# Open Octo with my issues/prs
alias eghp='nvim +"Octo search is:open is:pr author:benelan sort:updated"'
alias eghi='nvim +"Octo issue list assignee=benelan state=OPEN<CR>"'
