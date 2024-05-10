#!/usr/bin/env bash
# shellcheck disable=2086

PREFIX=$(
    surfraw -elvi |
        grep -v "LOCAL\|GLOBAL" |
        fzf --prompt="Pick search engine: " \
            --layout=reverse \
            --tiebreak=index \
            --bind="enter:become(echo {1})"
)

[ -z "$PREFIX" ] && exit

INPUT=$(
    printf "" |
        fzf --prompt="Enter keyword(s) to search ${PREFIX}: " \
            --layout=reverse \
            --print-query
)

surfraw -p "$PREFIX" $INPUT | cb
clear
