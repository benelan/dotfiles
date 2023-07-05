#!/usr/bin/env bash

# info: save w3m bookmarks to surfraw
# requirements: w3m surfraw
# source: https://github.com/gotbletu/dotfiles_v2/blob/master/normal_user/w3m/.w3m/cgi-bin/save_bookmark_surfraw.cgi

URL="$(xclip -o)"
# URL="$W3M_URL"

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
echo -e "${blue}>>> URL: $URL ${reset}"

# ask user for bookmark name
echo -e "${green}----------------------------------------------------------${reset}"
echo -e "${green}>>> 1) Enter Name for Bookmark. ${red}(No Spaces)${reset}"
read -rp "Name: " NAME
NAME=$(echo "$NAME" | awk '{print $1}')
echo

# ask user for keywords
echo -e "${green}>>> 2) Enter Keyword(s) for Bookmark. ${red}(Separate Each Keyword With A Space)${reset}"
read -rp "Keywords: " KEYWORDS

# append bookmarks to surfraw file
echo -e "${NAME} ${URL} :: ${KEYWORDS}" >> ~/.config/surfraw/bookmarks
clear
