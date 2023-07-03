#!/usr/bin/env bash

# info: save w3m bookmarks to surfraw
# requirements: w3m surfraw
# source: https://github.com/gotbletu/dotfiles_v2/blob/master/normal_user/w3m/.w3m/cgi-bin/save_bookmark_surfraw.cgi

# Reset
Color_Off='\e[0m'       # Text Reset
# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# METHOD 1: get url from clipboard
# URL="$(cb)"

# config requirements:
#   ~/.w3m/kepmap
## bookmark current page
#     keymap  XA      COMMAND       "EXTERN '(echo -n %s | cb)' ; SHELL ~/.w3m/cgi-bin/save_bookmark.cgi"
## bookmark current cursor link
#     keymap  xa      COMMAND       "EXTERN_LINK '(echo -n %s | cb)' ; SHELL ~/.w3m/cgi-bin/save_bookmark.cgi"

# METHOD 2
# get url from w3m environment variables (e.g !env | less)
URL="$W3M_URL"

clear
echo "
 ____  _   _ ____  _____ ____      ___        __
/ ___|| | | |  _ \|  ___|  _ \    / \ \      / /
\___ \| | | | |_) | |_  | |_) |  / _ \ \ /\ / /
 ___) | |_| |  _ <|  _| |  _ <  / ___ \ V  V /
|____/ \___/|_| \_\_|   |_| \_\/_/   \_\_/\_/

SAVE BOOKMARKS TO: ~/.config/surfraw/bookmarks

"
# show current url and display save location
echo -e "${Blue}>>> URL: $URL ${Color_Off}"

# ask user for bookmark name
echo -e "${Green}----------------------------------------------------------${Color_Off}"
echo -e "${Green}>>> 1) Enter Name for Bookmark. ${Red}(Single Word, No Spaces, No Symbols)${Color_Off}"
read -rp "Name: " NAME
NAME=$(echo "$NAME" | awk '{print $1}')
echo

# ask user for keywords
echo -e "${Green}>>> 2) Enter Keyword(s) for Bookmark. ${Red}(Separate Each Keyword With A Space)${Color_Off}"
read -rp "Keywords: " KEYWORDS

# append bookmarks to surfraw file
echo -e "${NAME}\t${URL}\t;; ${KEYWORDS}" >> ~/.config/surfraw/bookmarks
clear
