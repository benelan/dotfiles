#!/usr/bin/env bash

# Save w3m bookmarks to surfraw
# https://github.com/gotbletu/dotfiles_v2/blob/master/normal_user/w3m/.w3m/cgi-bin/save_bookmark_surfraw.cgi

bookmark_url="$(cb)"
# alternatively use the w3m env var:
# bookmark_url="$W3M_URL"

clear
echo "
 ____  _   _ ____  _____ ____      ___        __
/ ___|| | | |  _ \|  ___|  _ \    / \ \      / /
\___ \| | | | |_) | |_  | |_) |  / _ \ \ /\ / /
 ___) | |_| |  _ <|  _| |  _ <  / ___ \ V  V /
|____/ \___/|_| \_\_|   |_| \_\/_/   \_\_/\_/

SAVE BOOKMARK TO: ~/.config/surfraw/bookmarks

"
# show current url and display save location
echo -e "${BLUE}>>> URL: <${MAGENTA}$bookmark_url${BLUE}>${RESET}"

# ask user for bookmark name
echo -e "${AQUA}----------------------------------------------------------${RESET}"
echo -e "${GREEN}>>> 1) Enter a name for the bookmark. ${ORANGE}(no spaces or special chars except '-')${RESET}"
read -rp "Name: " bookmark_name
bookmark_name=$(awk '{print $1}' <<<"$bookmark_name")
echo

# ask for description
# echo -e "${green}>>> 2) Enter description for bookmark. ${orange}(no special characters except '-')${reset}"
# read -rp "Description: " DESCRIPTION

# ask user for keywords
echo -e "${GREEN}>>> 2) Enter tag(s) for the bookmark. ${ORANGE}(no special chars except '-', space separates tags)${RESET}"
read -rp "Tags: " bookmark_tags

# does the bookmark require javascript
echo -e "${GREEN}>>> 3) Should this bookmark be opened with a GUI browser? ${ORANGE}(e.g. does it require javascript)${RESET}"
read -rp "y/N: " bookmark_needs_gui

case "$bookmark_needs_gui" in
    [yY]*) bookmark_needs_gui=" -g" ;;
    *) bookmark_needs_gui="" ;;
esac

# append bookmarks to surfraw file
printf "\n%s %s :%s:%s" "${bookmark_name}" "${bookmark_url}" \
    "$(tr ' ' ':' <<<"${bookmark_tags}")" "$bookmark_needs_gui" \
    >>~/.config/surfraw/bookmarks

clear
