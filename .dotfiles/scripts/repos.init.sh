#!/usr/bin/env sh
set -e

OVERWRITE_REPOS=${OVERWRITE_REPOS:-false}

get_default_branch() {
    git -C "${1:-$PWD}" remote show "$(
        git -C "${1:-$PWD}" remote | grep -Eo "(upstream|origin)" | tail -1
    )" | grep "HEAD branch" | cut -d" " -f5
}

clone_gh_repo() {
    PARENT_PATH="$HOME/dev/${1:-"personal"}"
    mkdir -p "$PARENT_PATH"
    repo_dir="$PARENT_PATH/${3:-"$(basename "${2:?}")"}"

    printf "\n%s\n---------------------\n" "$2"
    if [ -d "$repo_dir" ]; then
        if [ "$OVERWRITE_REPOS" = true ]; then
            printf "removing '%s\'\n" "$repo_dir"
            rm -rf "${repo_dir:?}"
        else
            current_branch="$(git -C "$repo_dir" symbolic-ref --short HEAD)"
            printf "stashing changes on '%s'\n" "$current_branch"
            git -C "$repo_dir" stash push -m "automatic stash from repo update script"

            default_branch="$(get_default_branch "$repo_dir")"
            printf "checking out and pulling changes to '%s'\n" "$default_branch"
            git -C "$repo_dir" checkout "$default_branch"
            git -C "$repo_dir" pull

            printf "checking out and unstashing changes to '%s'\n" "$current_branch"
            git -C "$repo_dir" checkout "$current_branch"
            git -C "$repo_dir" stash pop || true
            unset repo_dir current_branch default_branch
            return
        fi
    fi

    printf "cloning '%s'\n" "$2" "$repo_dir"
    git clone "git@github.com:$2.git" "$repo_dir"
    unset repo_dir
}

clone_gh_repo_bare() {
    PARENT_PATH="$HOME/dev/$1"
    mkdir -p "$PARENT_PATH"
    repo_dir="$PARENT_PATH/${3:-"$(basename "${2:?}")"}"

    if [ -d "$repo_dir" ]; then
        cd "$repo_dir" || return

        if [ "$OVERWRITE_REPOS" = true ]; then
            printf "removing %s\n" "$repo_dir"
            rm -rf "${repo_dir:?}"
        elif ! [ -d "$repo_dir/.git" ]; then
            printf "dir exists but is not a git repo\n"
        else
            printf "skipping %s\n" "$repo_dir"
            unset repo_dir
            return
        fi
    fi

    printf "cloning '%s' to '%s'\n" "$2" "$repo_dir"
    git clone --bare "git@github.com:$2.git" .git
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch origin

    default_branch="$(get_default_branch)"
    worktree_name="$(echo "$default_branch" | tr "./" "__")"
    printf "creating worktree '%s' for branch '%s'\n" "$worktree_name" "$default_branch"
    git worktree add "$worktree_name" "$default_branch"
    cd "$worktree_name" || return
    git branch -u "origin/$default_branch"
    unset default_branch repo_dir worktree_name
}

clone_gh_repo_bare "work" "Esri/calcite-components"
clone_gh_repo_bare "work" "Esri/calcite-components-examples"
clone_gh_repo "work" "ArcGIS/calcite-components-output-targets"
clone_gh_repo "work" "Esri/jsapi-resources"
clone_gh_repo "work" "benelan/arcgis-esm-samples"
clone_gh_repo "work" "benelan/calcite-samples"
clone_gh_repo "work" "benelan/build-sizes"
clone_gh_repo "work" "benelan/github-scripts"
clone_gh_repo "work" "benelan/milestone-action"
clone_gh_repo "work" "benelan/need-info-action"
clone_gh_repo "work" "benelan/test"
clone_gh_repo "personal" "benelan/git-mux"
clone_gh_repo "personal" "benelan/notes"

unset WORK_PATH PERSONAL_PATH OVERWRITE_REPOS
