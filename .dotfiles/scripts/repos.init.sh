#!/usr/bin/env sh
set -e

OVERWRITE_REPOS=${OVERWRITE_REPOS:-false}
WORK_PATH="${WORK:-"$HOME/dev/work"}"
PERSONAL_PATH="${PERSONAL:-"$HOME/dev/personal"}"
mkdir -p "$WORK_PATH" "$PERSONAL_PATH"

clone_personal_gh_repo() {
    repo_dir="$PERSONAL_PATH/${2:-"$(basename "${1:?}")"}"
    # shellcheck disable=2086
    [ $OVERWRITE_REPOS != true ] && [ -d "$repo_dir" ] && return
    rm -rf "${dir:?}"
    git clone "git@github.com:${1:?}.git" "$repo_dir"
    unset repo_dir
}

clone_work_gh_repo() {
    repo_dir="$WORK_PATH/${2:-"$(basename "${1:?}")"}"
    # shellcheck disable=2086
    [ $OVERWRITE_REPOS != true ] && [ -d "$repo_dir" ] && return
    rm -rf "${dir:?}"
    git clone "git@github.com:${1:?}.git" "$repo_dir"
    unset repo_dir
}

clone_work_gh_repo_bare() {
    repo_dir="$WORK_PATH/${2:-"$(basename "${1:?}")"}"
    # shellcheck disable=2086
    [ $OVERWRITE_REPOS != true ] && [ -d "$repo_dir" ] && return
    rm -rf "${dir:?}"
    mkdir -p "$repo_dir"
    cd "$repo_dir" || return

    git clone --bare "git@github.com:$1.git" .git
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch origin

    default_branch="$(
        git remote show "$(
            git remote | grep -Eo "(upstream|origin)" | tail -1
        )" | grep "HEAD branch" | cut -d" " -f5
    )"

    git worktree add "$default_branch" "$default_branch"
    cd "$repo_dir" || return
    git branch -u "origin/$default_branch"
    unset dir default_branch repo_dir
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
