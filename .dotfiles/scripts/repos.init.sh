#!/bin/sh
set -e

OVERWRITE_REPOS=false
WORK_PATH="${WORK:-"$HOME/dev/work"}"
PERSONAL_PATH="${PERSONAL:-"$HOME/dev/personal"}"
mkdir -p "$WORK_PATH" "$PERSONAL_PATH"


clone_work_gh_repo() {
    dir="$WORK_PATH/${2:-"$(basename "${1:?}")"}"
    [ $OVERWRITE_REPOS != true ] && [ -d "$dir" ] && return
    rm -rf "${dir:?}"
    git clone "git@github.com:${1:?}.git" "$dir"
}

clone_personal_gh_repo() {
    dir="$PERSONAL_PATH/${2:-"$(basename "${1:?}")"}"
    [ $OVERWRITE_REPOS != true ] && [ -d "$dir" ] && return
    rm -rf "${dir:?}"
    git clone "git@github.com:${1:?}.git" "$dir"
}

clone_work_gh_repo_bare() {
    dir="$WORK_PATH/${2:-"$(basename "${1:?}")"}"
    [ $OVERWRITE_REPOS != true ] && [ -d "$dir" ] && return
    rm -rf "${dir:?}"
    mkdir -p "$dir"
    cd "$dir" || return

    git clone --bare "git@github.com:$1.git" .git
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch origin

    default_branch="$(
        git remote show "$(
            git remote | grep -Eo "(upstream|origin)" | tail -1
        )" | grep "HEAD branch" | cut -d" " -f5
    )"

    git worktree add asdf "$default_branch"
    cd "$dir" || return
    git branch -u "origin/$default_branch"
    unset dir default_branch
}

clone_work_gh_repo_bare "Esri/calcite-components"
clone_work_gh_repo "Esri/calcite-components-examples"
clone_work_gh_repo "ArcGIS/calcite-components-output-targets"
clone_work_gh_repo "ArcGIS/jsapi-resources"
clone_work_gh_repo "benelan/arcgis-esm-samples"
clone_work_gh_repo "benelan/calcite-samples"
clone_work_gh_repo "benelan/build-sizes"
clone_work_gh_repo "benelan/github-scripts"
clone_work_gh_repo "benelan/milestone-action"
clone_work_gh_repo "benelan/need-info-action"
clone_work_gh_repo "benelan/test"

unset WORK_PATH PERSONAL_PATH OVERWRITE_REPOS
