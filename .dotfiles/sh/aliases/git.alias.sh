#!/bin/sh

alias lg="lazygit"

# git-branch-default
# gets the default git branch
alias gbdefault='git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@"'

alias g='git'
alias get='git'

# add
alias ga='git add'
alias gall='git add -A'
alias gap='git add -p'

# branch
alias gb='git branch'
alias gbD='git branch -D'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbm='git branch -m'
alias gbt='git branch --track'

# for-each-ref
alias gbc='git for-each-ref --format="%(authorname) %09 %(if)%(HEAD)%(then)*%(else)%(refname:short)%(end) %09 %(creatordate)" refs/remotes/ --sort=authorname DESC' # FROM https://stackoverflow.com/a/58623139/10362396

# commit
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcaa='git commit -a --amend -C HEAD' # Add uncommitted and unstaged changes to the last commit
alias gcam='git commit -v -am'
alias gcamd='git commit --amend'
alias gcm='git commit -v -m'
alias gci='git commit --interactive'
alias gcsam='git commit -S -am'

# checkout
alias gcb='git checkout -b'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcobu='git checkout -b ${USER}/'
alias gcom='git checkout "$(gbdefault)"'
alias gcpd='git checkout "$(gbdefault)"; git pull; git branch -D'
alias gct='git checkout --track'

# clone
alias gcl='git clone'

# clean
alias gclean='git clean -fd'

# cherry-pick
alias gcp='git cherry-pick'
alias gcpx='git cherry-pick -x'

# diff
alias gd='git diff'
alias gds='git diff --staged'
alias gdt='git difftool'

# archive
alias gexport='git archive --format zip --output'

# fetch
alias gf='git fetch --all --prune'
alias gft='git fetch --all --prune --tags'
alias gftv='git fetch --all --prune --tags --verbose'
alias gfv='git fetch --all --prune --verbose'
alias gmu='git fetch origin -v; git fetch upstream -v; git merge upstream/"$(gbdefault)"'
alias gup='git fetch && git rebase'

# log
alias gg='git log --graph --pretty=format:'\''%C(bold)%h%Creset%C(magenta)%d%Creset %s %C(yellow)<%an> %C(cyan)(%cr)%Creset'\'' --abbrev-commit --date=relative'
alias ggf='git log --graph --date=short --pretty=format:'\''%C(auto)%h %Cgreen%an%Creset %Cblue%cd%Creset %C(auto)%d %s'\'''
alias ggs='gg --stat'
alias ggup='git log --branches --not --remotes --no-walk --decorate --oneline' # FROM https://stackoverflow.com/questions/39220870/in-git-list-names-of-branches-with-unpushed-commits
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias gnew='git log HEAD@{1}..HEAD@{0}' # Show commits since last pull, see http://blogs.atlassian.com/2014/10/advanced-git-aliases/
alias gwc='git whatchanged'

# ls-files
alias gu='git ls-files . --exclude-standard --others' # Show untracked files
alias glsut='gu'
alias glsum='git diff --name-only --diff-filter=U' # Show unmerged (conflicted) files

# gui
alias ggui='git gui'

# home
alias ghm='cd "$(git rev-parse --show-toplevel)"' # Git home

# merge
alias gm='git merge'

# mv
alias gmv='git mv'

# patch
alias gpatch='git format-patch -1'

# push
alias gp='git push'
alias gpd='git push --delete'
alias gpf='git push --force'
alias gpo='git push origin HEAD'
alias gpom='git push origin "$(gbdefault)"'
alias gpu='git push --set-upstream'
alias gpunch='git push --force-with-lease'
alias gpuo='git push --set-upstream origin'
alias gpuoc='git push --set-upstream origin $(git symbolic-ref --short HEAD)'

# pull
alias glum='git pull upstream "$(gbdefault)"'
alias gpl='git pull'
alias gpp='git pull && git push'
alias gpr='git pull --rebase'

# remote
alias gr='git remote'
alias gra='git remote add'
alias grv='git remote -v'

# rm
alias grm='git rm'

# rebase
alias grb='git rebase'
alias grbc='git rebase --continue'
alias grm='git rebase "$(gbdefault)"'
alias grmi='git rebase "$(gbdefault)" -i'
alias grma='GIT_SEQUENCE_EDITOR=: git rebase  "$(gbdefault)" -i --autosquash'
alias gprom='git fetch origin "$(gbdefault)" && git rebase origin/"$(gbdefault)" && git update-ref refs/heads/"$(gbdefault)" origin/"$(gbdefault)"' # Rebase with latest remote

# reset
alias gus='git reset HEAD'
alias gpristine='git reset --hard && git clean -dfx'

# status
alias gs='git status'
alias gss='git status -s'

# shortlog
alias gcount='git shortlog -sn'
alias gsl='git shortlog -sn'

# show
alias gsh='git show'

# svn
alias gsd='git svn dcommit'
alias gsr='git svn rebase' # Git SVN

# stash
alias gst='git stash'
alias gstb='git stash branch'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'  # kept due to long-standing usage
alias gstpo='git stash pop' # recommended for it's symmetry with gstpu (push)

## 'stash push' introduced in git v2.13.2
alias gstpu='git stash push'
alias gstpum='git stash push -m'

# submodules
alias gsu='git submodule update --init --recursive'

# switch
# these aliases requires git v2.23+
alias gsw='git switch'
alias gswc='git switch --create'
alias gswm='git switch "$(gbdefault)"'
alias gswt='git switch --track'

# tag
alias gt='git tag'
alias gta='git tag -a'
alias gtd='git tag -d'
alias gtl='git tag -l'

alias ghide='git update-index --assume-unchanged'
alias gunhide='git update-index --no-assume-unchanged'

# git-branch-clean
# removes all local branches which have been merged into the default branch
alias gbclean='git checkout -q "$(gbdefault)" && git for-each-ref refs/heads/ "--format=%(refname:short)" | grep -v -e main -e master -e develop -e dev | while read branch; do mergeBase=$(git merge-base "$(gbdefault)" "$branch") && [[ $(git cherry "$(gbdefault)" $(git commit-tree $(git rev-parse "$branch^{tree}") -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done && git fetch --prune --all'

# Dotfiles
# -----------------------------------------------------------------------------

# setup the alias for managing dotfiles
# It behaves like git, and can be called from any directory, e.g.
# $ dot add .nuxtrc && dot commit -m "chore: add nuxtrc" && dot push
# The whole home directory besides the dotfiles is untracked.
# Prevent `dot clean` so everything isn't deleted
dot() {
    if [ "$1" = "clean" ]; then
        echo "Don't delete your home directory, dumbass"
    else
        /usr/bin/git --git-dir="$HOME"/.git/ --work-tree="$HOME" "$@"
    fi
}

alias d='dot'

# add
alias da='dot add'
alias dall='dot add -u'
alias dap='dot add -p'

# branch
alias db='dot branch'
alias dbD='dot branch -D'
alias dba='dot branch -a'
alias dbd='dot branch -d'
alias dbm='dot branch -m'
alias dbt='dot branch --track'

# commit
alias dc='dot commit -v'
alias dcamd='dot commit --amend'
alias dcm='dot commit -v -m'
alias dci='dot commit --interactive'

# stash
alias dst='dot stash'
alias dstb='dot stash branch'
alias dstd='dot stash drop'
alias dstl='dot stash list'
alias dstp='dot stash pop'  # kept due to long-standing usage
alias dstpo='dot stash pop' # recommended for it's symmetry with gstpu (push)
alias dstpu='dot stash push'
alias dstpum='dot stash push -m'

# reset
alias dus='dot reset HEAD'
alias drh='dot reset --hard'

# status
alias ds='dot status'
alias dss='dot status -s'

# shortlog
alias dcount='dot shortlog -sn'
alias dsl='dot shortlog -sn'

# show
alias dsh='dot show'

# diff
alias ddiff='dot diff'
alias ddiffs='dot diff --staged'
alias ddifft='dot difftool'

# fetch
alias df='dot fetch --all --prune'
alias dft='dot fetch --all --prune --tags'
alias dftv='dot fetch --all --prune --tags --verbose'
alias dfv='dot fetch --all --prune --verbose'
alias dup='dot fetch && dot rebase'

# log
alias dg='dot log --graph --pretty=format:'\''%C(bold)%h%Creset%C(magenta)%d%Creset %s %C(yellow)<%an> %C(cyan)(%cr)%Creset'\'' --abbrev-commit --date=relative'
alias dgf='dot log --graph --date=short --pretty=format:'\''%C(auto)%h %Cgreen%an%Creset %Cblue%cd%Creset %C(auto)%d %s'\'''
alias dgs='gg --stat'
alias dgup='dot log --branches --not --remotes --no-walk --decorate --oneline'
alias dll='dot log --graph --pretty=oneline --abbrev-commit'
alias dnew='dot log HEAD@{1}..HEAD@{0}' # Show commits since last pull
alias dwc='dot whatchanged'

# ls-files
alias dlsum='dot diff --name-only --diff-filter=U' # Show unmerged (conflicted) files

# gui
alias dgui='dot gui'

# merge
alias dm='dot merge'

# push
alias dp='dot push'
alias dpd='dot push --delete'
alias dpf='dot push --force'
alias dpo='dot push origin HEAD'
alias dpu='dot push --set-upstream'
alias dpunch='dot push --force-with-lease'
alias dpuo='dot push --set-upstream origin'
alias dpuoc='dot push --set-upstream origin $(dot symbolic-ref --short HEAD)'

# pull
alias dpl='dot pull'
alias dpp='dot pull && dot push'
alias dpr='dot pull --rebase'

alias dhide='dot update-index --assume-unchanged'
alias dunhide='dot update-index --no-assume-unchanged'
