#!/bin/sh

# setup the alias for managing dotfiles
# It behaves like git, e.g.
# $ dotfiles add .nuxtrc && dotfiles commit -m "chore: add nuxtrc"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.git/ --work-tree=$HOME'


alias c='clear'
alias q='exit'
alias quit="exit"

# rerun last command as sudo
alias plz='sudo $(fc -ln -1)'
# Enable aliases to be sudo’ed
alias sudo='sudo '

# Searches history.
alias h='history_search' # see file `functions`
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
alias ccf="xclip -se c <"


# Directory listing/traversal

LS_COLORS="$(is-supported "ls --color" --color -G)"
LS_TIMESTYLEISO=$(is-supported "ls --time-style=long-iso" --time-style=long-iso)
LS_GROUPDIRSFIRST=$(is-supported "ls --group-directories-first" --group-directories-first)

alias l='ls -lahA $LS_COLORS $LS_TIMESTYLEISO $LS_GROUPDIRSFIRST'
alias la='ls -lAF $LS_COLORS' # List all files colorized in long format, excluding . and ..
alias lsd='ls -lF $LS_COLORS | grep --color=never ^d' # List only directories
alias lsh='ls -dlA .?* $LS_COLORS $LS_TIMESTYLEISO $LS_GROUPDIRSFIRST' # Lists hidden files in long format.
alias lt='ls -lhAtr $LS_COLORS $LS_TIMESTYLEISO $LS_GROUPDIRSFIRST'
alias ld='ls -ld $LS_COLORS */'
alias lp="stat -c '%a %n' *"

unset LS_COLORS LS_TIMESTYLEISO LS_GROUPDIRSFIRST

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Colorizes diff output, if possible.
if type 'colordiff' > /dev/null 2>&1; then
    alias diff='colordiff'
fi

# Finds directories.
alias fdd='find . -type d -name'
# Finds files.
alias fdf='find . -type f -name'


# Global aliases
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
alias edit='${EDITOR:-${ALTERNATE_EDITOR:-vi}}'
alias e='edit'
alias se='sudo e'
alias vi='vim'
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

alias cd..='cd ..'       # Common misspelling for going up one directory
alias ~="cd ~"           # `cd` is probably faster to type though
alias -- -='cd -'        # Go back

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."


# Shortcuts
alias d="cd ~/dev"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias dc="cd ~/Documents"


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
if command -v curl > /dev/null; then
    alias forecast='curl --silent --compressed --max-time 10 --url "https://wttr.in?F"'
else
    alias forecast='wget -qO- --compression=auto --timeout=10 "https://wttr.in?F"'
fi

# Displays current weather.
if command -v curl > /dev/null; then
    alias weather='curl --silent --compressed --max-time 10 --url "https://wttr.in/?format=%l:+(%C)+%c++%t+\[%h,+%w\]"'
else
    alias weather='wget -qO- --compression=auto --timeout=10 "https://wttr.in/?format=%l:+(%C)+%c++%t+\[%h,+%w\]"'
fi


# Ubuntu
# -----------------------------------------------------------------------------

# install with apt-get
alias apti='sudo apt install'
alias aptup='sudo apt-get update && sudo apt-get upgrade'

# Locks the session.
alias lock='gnome-screensaver-command --lock'

