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
alias gbd='git branch --delete'
alias gbD='git branch --delete --force'
alias gba='git branch --all'
alias gbm='git branch --move'
alias gbl="git branch --list"
alias gbt='git branch --track'

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
alias gcb='git checkout -b'
alias gcob='git checkout -b'
alias gcbu='git checkout -b ${USER}/'
alias gcobu='git checkout -b ${USER}/'
alias gcom='git checkout "$(gbdefault)"'
alias gcpD='git checkout "$(gbdefault)"; git pull; git branch -D'
alias gct='git checkout --track'

# clone
########
alias gcl='git clone'

# clean
########
alias gclean='git clean -fd'

# cherry-pick
##############
alias gcp='git cherry-pick'
alias gcpx='git cherry-pick -x'

# diff
#######
alias gdf='git diff'
alias gdfs='git diff --staged'
alias gdft='git difftool'

# archive
##########
alias gexport='git archive --format zip --output'

# fetch
########
alias gf='git fetch --all --prune'
alias gft='git fetch --all --prune --tags'
alias gftv='git fetch --all --prune --tags --verbose'
alias gfv='git fetch --all --prune --verbose'
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
alias gu='git ls-files . --exclude-standard --others'
alias glsut='gu'
# Show unmerged (conflicted) files
alias glsum='git diff --name-only --diff-filter=U'

# merge
########
alias gm='git merge'
alias gmm='git merge "$(gbdefault)"'
alias gmt='git mergetool'

# mv
#####
alias gmv='git mv'

# patch
########
alias gpatch='git format-patch -1'

# push
#######
alias gp='git push'
alias gpo='git push origin HEAD'
alias gpom='git push origin "$(gbdefault)"'
alias gpu='git push --set-upstream'
alias gpunch='git push --force-with-lease'
alias gpuo='git push --set-upstream origin'
alias gpuoc='git push --set-upstream origin $(git symbolic-ref --short HEAD)'

# pull
#######
alias glum='git pull upstream "$(gbdefault)"'
alias gpl='git pull'
alias gpp='git pull && git push'
alias gpr='git pull --rebase'

# remote
#########
alias gr='git remote'
alias gra='git remote add'
alias grv='git remote -v'

# rm
#####
alias grm='git rm'

# rebase
#########
alias grb='git rebase'
alias grbi='git rebase -i'
alias grba='git rebase -i --auto'
alias grbc='git rebase --continue'
alias grm='git rebase "$(gbdefault)"'
alias grmi='git rebase "$(gbdefault)" -i'
alias grma='GIT_SEQUENCE_EDITOR=: git rebase  "$(gbdefault)" -i --autosquash'
# Rebase with latest remote
alias gprom='git fetch origin "$(gbdefault)" && git rebase origin/"$(gbdefault)" && git update-ref refs/heads/"$(gbdefault)" origin/"$(gbdefault)"'

# reset
########
alias gr='git reset'
alias grs='git reset HEAD --soft'
alias grH='git reset --hard'
alias gus='git reset HEAD'
alias gpristine='git reset --hard && git clean -dfx'

# status
#########
alias gs='git status'
# set default to short in .gitconfig
alias gsl='git status -l'

# shortlog
###########
alias gcount='git shortlog -sn'
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
alias gsu='git submodule update --init --recursive'

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
alias dbdefault='basename "$(dot rev-parse --abbrev-ref origin/HEAD)"'

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
alias dba='dot branch --all'
alias dbd='dot branch --delete'
alias dbm='dot branch --move'
alias dbt='dot branch --track'

# commit
#########
alias dc='dot commit --verbose'
alias dcm='dot commit --verbose -m'
alias dcamd='dot commit --amend'
alias dcamdne='dot commit --amend --no-edit'
alias dci='dot commit --interactive'

# checkout
###########
alias dco='dot checkout'
alias dcb='dot checkout -b'
alias dcob='dot checkout -b'
alias dcom='dot checkout "$(dbdefault)"'
alias dcpD='dot checkout "$(dbdefault)"; dot pull; dot branch -D'

# diff
#######
alias ddf='dot diff'
alias ddfs='dot diff --staged'
alias ddft='dot difftool'

# fetch
########
alias df='dot fetch --all --prune'
alias dft='dot fetch --all --prune --tags'
alias dftv='dot fetch --all --prune --tags --verbose'
alias dfv='dot fetch --all --prune --verbose'
alias dup='dot fetch && dot rebase'

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
alias dpp='dot pull && dot push'
alias dpr='dot pull --rebase'

# push
#######
alias dp='dot push'
alias dpD='dot push --delete'
alias dpF='dot push --force'
alias dpo='dot push origin HEAD'
alias dpu='dot push --set-upstream'
alias dpunch='dot push --force-with-lease'
alias dpuo='dot push --set-upstream origin'
alias dpuoc='dot push --set-upstream origin $(dot symbolic-ref --short HEAD)'

# reset
########
alias dr='dot reset'
alias drs='dot reset HEAD --soft'
alias drH='dot reset --hard'

# shortlog
###########
alias dcount='dot shortlog -sn'
alias dsl='dot shortlog -sn'

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
# set default to short in .gitconfig
alias dsl='dot status --long'

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