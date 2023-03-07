#!/bin/sh

alias c='clear'
alias q='exit'
alias quit="exit"

# rerun last command as sudo
alias plz='sudo $(fc -ln -1)'
# Enable aliases to be sudo’ed
alias sudo='sudo '

alias md='mkdir -p'
alias rd='rmdir'
alias rr='rm -rf'

# copy to clipboard from file
alias cbf="xclip -se c <"

alias f="vifm"

# Directory listing/traversal
LS_COLORS=$(is-supported "ls --color" --color -G)
LS_TIMESTYLEISO=$(is-supported "ls --time-style=long-iso" --time-style=long-iso)
LS_GROUPDIRSFIRST=$(is-supported "ls --group-directories-first" --group-directories-first)

# list all files/dirs, short format, sort by time
alias l='ls -Art $LS_COLORS $LS_GROUPDIRSFIRST'
# list all files/dirs, long format, sort by time
alias ll='ls -hogArt $LS_COLORS $LS_TIMESTYLEISO $LS_GROUPDIRSFIRST'
# List directories, long format, sort by time
alias lsd='ls -radgoth */ $LS_COLORS $LS_TIMESTYLEISO'
# Lists hidden files, long format, sort by time
alias lsh='ls -radgoth .?* $LS_COLORS $LS_TIMESTYLEISO $LS_GROUPDIRSFIRST'

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated
alias grep='grep --color=auto'
alias fgrep='grep -f --color=auto'
alias egrep='grep -e --color=auto'

# Colorizes diff output, if possible.
if type 'colordiff' >/dev/null 2>&1; then
    alias diff='colordiff'
fi

# Finds directories.
alias fdd='find . -type d -name'
# Finds files.
alias fdf='find . -type f -name'

# List declared aliases, functions, paths
alias aliases="alias | sed 's/=.*//'"
alias functions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'"
alias paths='echo -e ${PATH//:/\\n}'

# Sets editors and defaults.
alias edit='${EDITOR:-vim}'
alias e='edit'
alias se='sudo e'
alias vimh='vim -c ":h | only"'

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Navigation
# -----------------------------------------------------------------------------

alias cd..="cd .." # Common misspelling
alias -- -="cd -"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Time
# -----------------------------------------------------------------------------

# Gets local/UTC date and time in ISO-8601 format `YYYY-MM-DDThh:mm:ss`.
alias now='date +"%Y-%m-%dT%H:%M:%S"'
alias unow='date -u +"%Y-%m-%dT%H:%M:%S"'

# Weather
# -----------------------------------------------------------------------------

alias wttr="curl wttr.in"

# Displays detailed weather and forecast.
if command -v curl >/dev/null; then
    alias forecast='curl --silent --compressed --max-time 10 --url "https://wttr.in?F"'
else
    alias forecast='wget -qO- --compression=auto --timeout=10 "https://wttr.in?F"'
fi

# Displays current weather.
if command -v curl >/dev/null; then
    alias weather='curl --silent --compressed --max-time 10 --url "https://wttr.in/?format=%l:+(%C)+%c++%t+\[%h,+%w\]"'
else
    alias weather='wget -qO- --compression=auto --timeout=10 "https://wttr.in/?format=%l:+(%C)+%c++%t+\[%h,+%w\]"'
fi

# Ubuntu/GNOME
# -----------------------------------------------------------------------------

# install with apt
alias apti='sudo apt install'
alias aptup='sudo apt update && sudo apt upgrade'

# Locks the session.
alias lock='gnome-screensaver-command --lock'

alias gsschemas='gsettings list-schemas | grep -i'
alias gskeys='gsettings list-keys'

