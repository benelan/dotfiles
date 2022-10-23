#!/usr/bin/env bash

# Clear console if possible when logging out
if [ "$SHLVL" = 1 ] ; then
    clear_console -q 2>/dev/null
fi
