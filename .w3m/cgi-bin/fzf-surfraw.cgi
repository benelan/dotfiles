#!/usr/bin/env bash

### Description     : interactive surfraw smart prefix search engine (mainly use within w3m web browser)
### Depends On      : surfraw  fzf  gawk  coreutils  grep  procps-ng
### Source          : https://github.com/felipesaa/A-vim-like-firefox-like-configuration-for-w3m

### Setup
# add the following lines to ~/.w3m/keymapL
#     keymap  xs      COMMAND       "SHELL ~/.w3m/cgi-bin/fzf_surfraw.cgi ; GOTO ~/.w3m/cgi-bin/goto_clipboard.cgi"
#     keymap  XS      COMMAND       "SHELL ~/.w3m/cgi-bin/fzf_surfraw.cgi ; TAB_GOTO ~/.w3m/cgi-bin/goto_clipboard.cgi"

clear

# select your elvi
PREFIX=$(surfraw -elvi | grep -v 'LOCAL\|GLOBAL'| fzf -e | awk '{print $1}')

# exit script if no elvi is selected (e.g hit ESC)
if [ "$PREFIX" = "" ]; then exit; fi

# get user input
read -r -e -p "  $PREFIX >> Enter Your Search Keyword: " INPUT

# print proper url and copy to primary clipboard (aka highlighted clipboard) and tmux clipboard
surfraw -p "$PREFIX" "$INPUT" | cb
# pidof tmux >/dev/null && tmux set-buffer "$(surfraw -p "$PREFIX" "$INPUT")"
