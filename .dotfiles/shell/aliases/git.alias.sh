#!/bin/sh
# shellcheck disable=2139

# Git
# -----------------------------------------------------------------------------

alias g='git'

# gets the default git branch
alias gbdefault='basename "$(git rev-parse --abbrev-ref origin/HEAD)"'
# same thing:  ="git branch --list --remotes '*/HEAD' | awk -F/ '{print $NF}'"

# add
######
alias ga='git add'
alias gall='git add --all'
alias gap='git add --patch'

# bisect
#########
alias gbi="git bisect"
alias gbis="git bisect start"
alias gbig="git bisect good"
alias gbib="git bisect bad"
alias gbir="git bisect reset"

# branch
#########
alias gb='git branch'
alias gbD='git branch --delete --force'

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
alias gcam='git commit --verbose -am'
alias gcaamd='git commit --all --amend -C HEAD'
alias gcamd='git commit --verbose --amend'
alias gcamdne='git commit --amend --no-edit'
alias gci='git commit --interactive'
alias gcsam='git commit -S -am'

# checkout
###########
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcobu='git checkout -b ${USER}/'
alias gcom='git checkout "$(gbdefault)"'

# clone
########
alias gcl='git clone'

# cherry-pick
##############
alias gcp='git cherry-pick'

# diff
#######
alias gdf='git diff'
alias gdfs='git diff --staged'
alias gdft='git difftool'
alias gdfe='$EDITOR $(git diff --name-only)'

# fetch
########
alias gf='git fetch --all --prune'
alias gft='git fetch --all --prune --tags'
alias gmu='git fetch origin -v; git fetch upstream -v; git merge upstream/"$(gbdefault)"'
alias gup='git fetch && git rebase'

# log
######
alias gg='git log --graph --pretty=format:'\''%C(bold)%h%Creset%C(magenta)%d%Creset %s %C(yellow)<%an> %C(cyan)(%cr)%Creset'\'' --abbrev-commit --date=relative'
alias ggf='git log --graph --date=short --pretty=format:'\''%C(auto)%h %Cgreen%an%Creset %Cblue%cd%Creset %C(auto)%d %s'\'''
alias ggs='gg --stat'
# show branches with unpushed commits
# https://stackoverflow.com/questions/39220870/in-git-list-names-of-branches-with-unpushed-commits
alias ggup='git log --branches --not --remotes --no-walk --decorate --oneline'
# show commits in current branch that aren't merged to the default branch
alias glum='git log "$(gbdefault)" ^HEAD'
alias gll='git log --graph --pretty=oneline --abbrev-commit'
# Show commits since last pull
# http://blogs.atlassian.com/2014/10/advanced-git-aliases/
alias gnew='git log HEAD@{1}..HEAD@{0}'
alias gwc='git whatchanged'

# files
########
# Show untracked files
alias glsut='git ls-files . --exclude-standard --others'
# Show unmerged (conflicted) files
alias glsum='git diff --name-only --diff-filter=U'

# merge
########
alias gm='git merge'
alias gmm='git merge "$(gbdefault)"'
alias gmt='git mergetool'

# patch
########
alias gpatch='git format-patch -1'

# push
#######
alias gp='git push'
alias gpo='git push origin HEAD'
alias gpom='git push origin "$(gbdefault)"'
alias gpu='git push --set-upstream'
alias gpuo='git push --set-upstream origin'
alias gpuoc='git push --set-upstream origin $(git symbolic-ref --short HEAD)'

# pull
#######
alias gplum='git pull upstream "$(gbdefault)"'
alias gpl='git pull'
alias gplp='git pull && git push'

# remote
#########
alias gr='git remote'

# rebase
#########
alias grb='git rebase'
alias grbi='git rebase -i'
alias grba='git rebase -i --auto'
alias grbc='git rebase --continue'
alias grbm='git rebase "$(gbdefault)"'
alias grbma='GIT_SEQUENCE_EDITOR=: git rebase  "$(gbdefault)" -i --autosquash'
# Rebase with latest remote
alias gprom='git fetch origin "$(gbdefault)" && git rebase origin/"$(gbdefault)" && git update-ref refs/heads/"$(gbdefault)" origin/"$(gbdefault)"'

# reset
########
alias gr='git reset'
alias grs='git reset --soft'
alias grH='git reset --hard'
alias gus='git reset HEAD'
alias gpristine='git reset --hard && git clean -dfx'

# status
#########
alias gs='git status'

# shortlog
###########
alias gsl='git shortlog -sn'

# show
#######
alias gsh='git show'

# stash
########
alias gst='git stash'
alias gstb='git stash branch'
alias gstD='git stash drop'
alias gstl='git stash list'
alias gstpo='git stash pop'
# 'stash push' introduced in git v2.13.2
alias gstpu='git stash push'
alias gstpum='git stash push -m'

# submodules
#############
alias gsmu='git submodule update --init --recursive'

# switch
#########
# these aliases requires git v2.23+
alias gsw='git switch'
alias gswc='git switch --create'
alias gswm='git switch "$(gbdefault)"'
alias gswt='git switch --track'

# tag
######
alias gt='git tag'
alias gta='git tag --annotate'
alias gtd='git tag --delete'
alias gtD='git tag --delete --force'
alias gtl='git tag --list'
# outputs the tag following the provided commit hash
# useful for finding the first reproducible version for bugs
# $ gtnext 84a29d4 # => v1.0.0-next.295~8 (8 commits before the tag)
alias gtnext='git name-rev --tags --name-only'

alias ghm='cd "$(git rev-parse --show-toplevel)"'
alias ghide='git update-index --assume-unchanged'
alias gunhide='git update-index --no-assume-unchanged'

# plugins
##########
alias glz="lazygit"
alias gfz="git fuzzy"
alias fgbD="git branch | fzf --multi | xargs git branch -D"
alias fgbd="git branch | fzf --multi | xargs git branch -d"

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

# creates env vars so git plugins
# work with the bare dotfiles repo
edot() {
    # shellcheck disable=2016
    nvim "${@:-"$HOME/.dotfiles"}" \
        --cmd "cd %:h | pwd" \
        --cmd 'let $GIT_WORK_TREE = expand("~")' \
        --cmd 'let $GIT_DIR = expand("~/.git")'
}

alias ehome="edot ~"
alias envim="edot ~/.config/nvim/init.lua"

alias d='dot'

# add
######
alias da='dot add'
# doesn't add untracked files
alias dall='dot add --update'
alias dap='dot add --patch'
# track new files in commonly added locations
alias danvim="dot add ${HOME}/.config/nvim/*"
alias dadots="dot add ${HOME}/.dotfiles/*"
alias dash="dot add ${HOME}/.dotfiles/shell/*"
alias dascripts="dot add ${HOME}/.dotfiles/scripts/*"
alias dabin="dot add ${HOME}/.dotfiles/bin/*"

# branch
#########
alias db='dot branch'
alias dbD='dot branch --delete --force'

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
alias ddfe='$EDITOR $(dot diff --name-only)'

# files
########
# Show unmerged (conflicted) files
alias dlsum='dot diff --name-only --diff-filter=U'

# log
######
alias dgg='dot log --graph --pretty=format:'\''%C(bold)%h%Creset%C(magenta)%d%Creset %s %C(yellow)<%an> %C(cyan)(%cr)%Creset'\'' --abbrev-commit --date=relative'
alias dgf='dot log --graph --date=short --pretty=format:'\''%C(auto)%h %Cgreen%an%Creset %Cblue%cd%Creset %C(auto)%d %s'\'''
alias dgs='dg --stat'
alias dgup='dot log --branches --not --remotes --no-walk --decorate --oneline'
alias dll='dot log --graph --pretty=oneline --abbrev-commit'
# Show commits since last pull
alias dnew='dot log HEAD@{1}..HEAD@{0}'
alias dwc='dot whatchanged'

# merge
########
alias dm='dot merge'
alias dmm='dot merge "$(dbdefault)"'
alias dmt='dot mergetool'

# pull
#######
alias dpl='dot pull'
alias dplp='dot pull && dot push'

# push
#######
alias dp='dot push'
alias dpo='dot push origin HEAD'
alias dpu='dot push --set-upstream'
alias dpuoc='dot push --set-upstream origin $(dot symbolic-ref --short HEAD)'

# reset
########
alias dr='dot reset'
alias drs='dot reset --soft'
alias drH='dot reset --hard'

# show
#######
alias dsh='dot show'

# stash
########
alias dst='dot stash'
alias dstb='dot stash branch'
alias dstd='dot stash drop'
alias dstl='dot stash list'
alias dstpo='dot stash pop'
alias dstpu='dot stash push'
alias dstpum='dot stash push -m'

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
alias dfz="dot fuzzy"

# GitHub
# -----------------------------------------------------------------------------

# https://cli.github.com/
# https://github.com/dlvhdr/gh-dash
alias ghd="gh dash"

