#!/usr/bin/env bash
# shellcheck disable=1090

if is-supported npm; then
    # NOTE: the `cd` makes sure `npm completion` doesn't run in
    # a project that uses workspaces as a workaround for:
    # https://github.com/npm/cli/issues/5486
    source <(cd && npm completion)
fi
