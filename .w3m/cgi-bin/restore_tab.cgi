#!/usr/bin/env sh

### Description     : restore a closed tab in w3m
### Depends On      : w3m coreutils
### Source          : https://github.com/felipesaa/A-vim-like-firefox-like-configuration-for-w3m
### References      : http://w3m.sourceforge.net/MANUAL#LocalCGI
### Install         : put this script in /usr/lib/w3m/cgi-bin/

# open the last closed tab
last_tab=$(tail -n 1 ~/.w3m/RestoreTab.txt)

# limit of tabs stored
limit=$(tail -n 20 ~/.w3m/RestoreTab.txt)
other_tabs=$(printf "%s" "$limit" | head -n -1)

echo "$other_tabs" >~/.w3m/RestoreTab.txt
echo "W3m-control: GOTO $last_tab"
echo "W3m-control: DELETE_PREVBUF"
