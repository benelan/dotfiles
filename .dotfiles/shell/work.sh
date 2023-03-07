#!/usr/bin/env bash
# shellcheck disable=2139

# For running npm scripts in a docker container due to a Stencil bug
# https://github.com/ionic-team/stencil/issues/3853
# Uses a bind mount so works for local development, e.g.
# $ cc-drun npm run test:watch
alias cc-drun="docker run --init --interactive --rm --cap-add SYS_ADMIN --volume .:/app:z --user $(id -u):$(id -g) --publish 3333:3333 --name calcite-components calcite-components"
alias cc-dbuild="docker build --tag calcite-components ."
# I need to link the Dockerfile to the current git worktree
alias cc-dlink="ln -f ~/dev/work/calcite-components/Dockerfile"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Toggles a label we use for running visual snapshots on a pull request
if type -P gh >/dev/null 2>&1; then
    cc-vsnap() {
        if [[ "$(gh repo view --json name -q ".name")" = "calcite-components" ]]; then
            local current_branch
            current_branch="$(git symbolic-ref --short HEAD)"
            gh pr edit "$current_branch" --remove-label "pr ready for visual snapshots"
            gh pr edit "$current_branch" --add-label "pr ready for visual snapshots"
        fi
    }
fi
