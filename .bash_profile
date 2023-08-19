#!/usr/bin/env bash

# Load ~/.profile regardless of shell version
if [ -e "$HOME/.profile" ]; then
    . "$HOME/.profile"
fi

# Force the `posix` option on and if POSIXLY_CORRECT is set and stop sourcing
# startup scripts. So make sure everything in ~/.profile is posix-compliant.
if [ -n "$POSIXLY_CORRECT" ]; then
    set -o posix
    return
fi

# Source ~/.bashrc if it exists; the tests for both interactivity and
# minimum version numbers are in there
[ -r "$HOME/.bashrc" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
