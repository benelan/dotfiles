#!/usr/bin/env sh
# shellcheck disable=2139

# Git
# -----------------------------------------------------------------------------

alias g='git'

# deletes local branches already squash merged into the default branch
# shellcheck disable=2016,2034,2154
alias gbprune='TARGET_BRANCH="$(g bdefault)" && git fetch --prune --all && git checkout -q "$TARGET_BRANCH" && git for-each-ref refs/heads/ "--format=%(refname:short)" | grep -v -e main -e master -e develop -e dev | while read -r branch; do mergeBase=$(git merge-base "$TARGET_BRANCH" "$branch") && [[ "$(git cherry "$TARGET_BRANCH" "$(git commit-tree "$(git rev-parse "$branch"\^{tree})" -p "$mergeBase" -m _)")" == "-"* ]] && git branch -D "$branch"; done; unset TARGET_BRANCH mergeBase branch'

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
alias gcom='git checkout "$(g bdefault)"'

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
alias geom='default_branch=$(g bdefault); git fetch; git merge origin/$default_branch; $EDITOR $(git diff --name-only HEAD origin/$default_branch); unset default_branch'
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
alias glum='git log "$(g bdefault)" ^HEAD'
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
alias gmm='git merge "$(g bdefault)"'
alias gmom='git fetch && git merge origin/$(g bdefault)'
alias gmt='git mergetool'

# push
#######
alias gp='git push'
alias gpuoc='git push --set-upstream origin $(git symbolic-ref --short HEAD)'

# pull
#######
alias gpl='git pull'
alias gplum='git pull upstream "$(g bdefault)"'

# rebase
#########
alias grb='git rebase'
alias grbma='GIT_SEQUENCE_EDITOR=: git rebase "$(g bdefault)" -i --autosquash'
# Rebase with latest remote
alias gfrom='git fetch origin "$(g bdefault)" && git rebase origin/"$(g bdefault)" && git update-ref refs/heads/"$(g bdefault)" origin/"$(g bdefault)"'

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
alias gwR='git worktree remove'
alias gwl='git worktree list'
alias gwp='git worktree prune'

alias ghm='cd "$(git rev-parse --show-toplevel)"'
alias ghide='git update-index --assume-unchanged'
alias gunhide='git update-index --no-assume-unchanged'

# plugins
##########
alias glz="lazygit"
# delete multiple branches
alias fgbd="git branch | fzf --multi | xargs git branch -d"
# fgcoc - checkout git commit
alias fgcoc='git log --pretty=oneline --abbrev-commit --reverse | fzf --tac +s +m -e | sed "s/ .*//" | xargs git checkout'
# get git commit sha
alias fgcs='git log --color=always --pretty=oneline --abbrev-commit --reverse | fzf --tac +s +m -e --ansi --reverse | sed "s/ .*//"'
# open fugitive status
alias G="nvim +G +'wincmd o'"

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
alias D="edit_dotfiles +G +'wincmd o'"

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
alias lazydot="lazygit --git-dir='${HOME}/.git' --work-tree='${HOME}'"
alias dlz="lazydot"

# GitHub
# -----------------------------------------------------------------------------

# https://cli.github.com/
# https://github.com/dlvhdr/gh-dash
alias ghd="gh dash"
# Open Octo with my issues/prs
alias eghp='nvim +"Octo search is:open is:pr author:benelan sort:updated"'
alias eghi='nvim +"Octo issue list assignee=benelan state=OPEN<CR>"'
