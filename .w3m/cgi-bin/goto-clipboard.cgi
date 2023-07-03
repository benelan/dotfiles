#!/usr/bin/env sh

### Description     : paste and go feature for w3m web browser using system clipboard (aka ctrl+v)
### Depends On      : w3m
### Source          : https://github.com/felipesaa/A-vim-like-firefox-like-configuration-for-w3m
### Install         : put this script in /usr/lib/w3m/cgi-bin/

# GOTO clipboard url (or blank page if no url)
printf "%s\r\n" "W3m-control: GOTO $(cb)";
# delete the buffer (element in history) created between the current and searched pages
printf "W3m-control: DELETE_PREVBUF\r\n"
