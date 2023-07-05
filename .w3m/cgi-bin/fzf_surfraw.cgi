#!/usr/bin/env bash
# shellcheck disable=2086

# clear screen
printf "\033c"

PREFIX=$(
    surfraw -elvi |
        grep -v 'LOCAL\|GLOBAL' |
        fzf-tmux -d 30% -e --prompt='Pick search engine: ' \
            --info=inline --layout=reverse --tiebreak=index |
        awk '{print $1}'
)

[ -z "$PREFIX" ] && exit

INPUT=$(
    printf "\n\n" |
        fzf --prompt="Enter keyword(s) to search ${PREFIX}: " \
            --info=inline --layout=reverse --print-query
)

# read -rp "Enter keyword(s) to search ${PREFIX}: " INPUT

# surfraw -p "$PREFIX" $INPUT | xclip -selection clipboard
# surfraw -p "$PREFIX" $INPUT >/tmp/jamin_clipboard.txt
surfraw -p "$PREFIX" $INPUT | tmux load-buffer -
