#!/usr/bin/env bash

# Load ~/.profile regardless of shell version
if [ -e "$HOME/.profile" ] ; then
    . "$HOME/.profile"
fi

# If POSIXLY_CORRECT is set after doing that, force the `posix` option on and
# don't load the rest of this stuff--so, just ~/.profile and ENV
if [ -n "$POSIXLY_CORRECT" ] ; then
    set -o posix
    return
fi

# Source ~/.bashrc if it exists; the tests for both interactivity and
# minimum version numbers are in there
[ -r "$HOME/.bashrc" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"