#!/bin/sh

alias c='clear'
alias q='exit'
alias quit="exit"

# rerun last command as sudo
alias plz='sudo $(fc -ln -1)'
# Enable aliases to be sudo’ed
alias sudo='sudo '

# Searches history.
alias h='history_search'          # see file `functions`
alias hs='history_session_search' # see file `functions`

alias md='mkdir -p'
alias rd='rmdir'
alias rr='rm -rf'
# Creates parent directories on demand.
alias mkdir='mkdir -pv'

# copy/paste from clipboard
alias cc="echo @{0} | tr -d '\n' | xclip -selection c"
alias pc="echo @{0} | xclip -selection c -o"
# copy to clipboard from file
alias cbf="xclip -se c <"

# Directory listing/traversal

LS_COLORS=$(is-supported "ls --color" --color -G)
LS_TIMESTYLEISO=$(is-supported "ls --time-style=long-iso" --time-style=long-iso)
LS_GROUPDIRSFIRST=$(is-supported "ls --group-directories-first" --group-directories-first)

# list all files/dirs, short format, sort by time
alias l='ls -Art $LS_COLORS $LS_GROUPDIRSFIRST'
# list all files/dirs, long format, sort by time
alias ll='ls -hogArt $LS_COLORS $LS_TIMESTYLEISO $LS_GROUPDIRSFIRST'
# list all files/dirs, long format, sort by name
alias lsa='ls -Argho $LS_COLORS $LS_TIMESTYLEISO $LS_GROUPDIRSFIRST'
# list all files/dirs, long format, sort by size
alias lss='ls -Argho $LS_COLORS $LS_TIMESTYLEISO $LS_GROUPDIRSFIRST'
# List directories, long format, sort by time
alias lsd='ls -radgoth */ $LS_COLORS $LS_TIMESTYLEISO'
# Lists hidden files, long format, sort by time
alias lsh='ls -radgoth .?* $LS_COLORS $LS_TIMESTYLEISO $LS_GROUPDIRSFIRST'
# all files/dirs recursively, excluding common auto-generated content
alias lsRA='ls -AR --ignore={.git,node_modules,build,dist,www,assets,vendor} $LS_COLORS'
alias lp="stat -c '%a %n' *"

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

# Global aliases
# shellcheck disable=2091
if $(is-supported "alias -g"); then
    alias -g G="| grep -i"
    alias -g H="| head"
    alias -g T="| tail"
    alias -g L="| less"
fi

# List declared aliases, functions, paths
alias aliases="alias | sed 's/=.*//'"
alias functions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'"
alias paths='echo -e ${PATH//:/\\n}'

# Sets editors and defaults.
alias edit='${EDITOR:-vim}'
alias e='edit'
alias se='sudo e'
alias vis='vim "+set si"'
alias snano='sudo nano'
alias svim='sudo ${VISUAL:-vim}'
alias vimh='vim -c ":h | only"'

# Reloas the shell.
alias reload='exec $SHELL -l'

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Navigation
# -----------------------------------------------------------------------------

alias cd..='cd ..' # Common misspelling for going up one directory
alias ~="cd ~"     # `cd` is probably faster to type though
alias -- -='cd -'  # Go back

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Shortcuts
alias dv="cd ~/dev"
alias dls="cd ~/Downloads"
alias dktp="cd ~/Desktop"
alias dcs="cd ~/Documents"
alias dts="cd ~/.dotfiles"
alias nvcnf="cd ~/.config/nvim"

# Time
# -----------------------------------------------------------------------------

# Gets local/UTC date and time in ISO-8601 format `YYYY-MM-DDThh:mm:ss`.
alias now='date +"%Y-%m-%dT%H:%M:%S"'
alias unow='date -u +"%Y-%m-%dT%H:%M:%S"'

# Gets date in `YYYY-MM-DD` format`
alias nowdate='date +"%Y-%m-%d"'
alias unowdate='date -u +"%Y-%m-%d"'

# Gets time in `hh:mm:ss` format`
alias nowtime='date +"%T"'
alias unowtime='date -u +"%T"'

# Gets Unix time stamp`
alias timestamp='date -u +%s'

# Gets week number in ISO-8601 format `YYYY-Www`.
alias week='date +"%Y-W%V"'

# Gets weekday number.
alias weekday='date +"%u"'

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

# install with apt-get
alias apti='sudo apt install'
alias aptup='sudo apt update && sudo apt upgrade'

# Locks the session.
alias lock='gnome-screensaver-command --lock'

alias gsschemas='gsettings list-schemas | grep -i'
alias gskeys='gsettings list-keys'

