#!/usr/bin/env bash

# bash completion for go tool
# https://github.com/posener/complete

# Test `go version` because goenv creates shim scripts that will be found in PATH
# but do not always resolve to a working install.
if is-supported go && go version &>/dev/null; then
    # Same idea here, but no need to test a subcommand
    if is-supported gocomplete && gocomplete &>/dev/null; then
        # finally, apply completion
        complete -C gocomplete go
    fi
fi