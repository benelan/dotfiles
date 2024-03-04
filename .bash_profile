#!/usr/bin/env bash

# Load ~/.profile regardless of shell version
[ -e "$HOME/.profile" ] && . "$HOME/.profile"

# Force the `posix` option on and if POSIXLY_CORRECT is set and stop sourcing
# startup scripts. So make sure everything in ~/.profile is posix-compliant.
[ -n "$POSIXLY_CORRECT" ] && set -o posix && return

# Source ~/.bashrc if it exists; the tests for both interactivity and
# minimum version numbers are in there
[ -r "$HOME/.bashrc" ] && . "$HOME/.bashrc"
