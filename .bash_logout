#!/usr/bin/env bash
# ~/.bash_logout: executed by bash(1) when login shell exits.

# clear the screen when leaving the console to increase privacy
[ "$SHLVL" = 1 ] && [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
