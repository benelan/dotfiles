#!/usr/bin/env bash

# show readline mode                                          {{{
# [E]macs, vi [I]nsert, or vi [C]ommand
bind "set show-mode-in-prompt on"
bind "set emacs-mode-string \"E \""
bind "set vi-cmd-mode-string \"C \""
bind "set vi-ins-mode-string \"I \""

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# define terminal colors                                      {{{
{
    if [ "$(tput colors)" -gt 255 ]; then
        RESET=$(tput sgr0)
        BOLD=$(tput bold)
        UNDERLINE=$(tput smul)
        # Gruvbox colors from: https://github.com/morhetz/gruvbox
        BLACK=$(tput setaf 235)
        BLUE=$(tput setaf 66)
        CYAN=$(tput setaf 72)
        GREEN=$(tput setaf 106)
        ORANGE=$(tput setaf 166)
        MAGENTA=$(tput setaf 132)
        RED=$(tput setaf 124)
        WHITE=$(tput setaf 230)
        YELLOW=$(tput setaf 172)
    else
        RESET="\e[0m"
        BOLD='\e[1m'
        UNDERLINE='e[4m'
        BLACK="\e[1;30m"
        BLUE="\e[1;34m"
        CYAN="\e[1;36m"
        GREEN="\e[1;32m"
        ORANGE="\e[1;33m"
        MAGENTA="\e[1;35m"
        RED="\e[1;31m"
        WHITE="\e[1;37m"
        YELLOW="\e[1;33m"
    fi
} >/dev/null 2>&1

export BOLD UNDERLINE RESET BLACK BLUE CYAN \
    GREEN ORANGE MAGENTA RED WHITE YELLOW

# trim long paths if possible                   {{{
if ((BASH_VERSINFO[0] >= 4)); then
    PROMPT_DIRTRIM=4
fi

# - - - - - - - - - - - - - - - - - - - - - - - }}}
# highlight username when logged in as root     {{{
if [ "$EUID" -eq 0 ]; then
    userStyle="${BOLD}${RED}"
else
    userStyle="${ORANGE}"
fi

# - - - - - - - - - - - - - - - - - - - - - - - }}}
# highlight the hostname when connected via SSH {{{
if [ -n "${SSH_TTY}" ]; then
    hostStyle="${BOLD}${RED}"
else
    hostStyle="${YELLOW}"
fi

# - - - - - - - - - - - - - - - - - - - - - - - }}}
# git prompt options                            {{{
export GIT_PS1_SHOWDIRTYSTATE="yes"
export GIT_PS1_SHOWSTASHSTATE="yes"
export GIT_PS1_SHOWUNTRACKEDFILES="yes"
export GIT_PS1_SHOWCONFLICTSTATE="yes"
export GIT_PS1_SHOWCOLORHINTS="yes"
export GIT_PS1_COMPRESSSPARSESTATE="yes"
export GIT_PS1_HIDE_IF_PWD_IGNORED="yes"
export GIT_PS1_SHOWUPSTREAM="verbose"
export GIT_PS1_DESCRIBE_STYLE="contains"

# - - - - - - - - - - - - - - - - - - - - - - - }}}
# set the pre_prompt                            {{{
pre_prompt="\[${RESET}\]\n"
pre_prompt+="\[${BOLD}\]\[${userStyle}\]\u" # username
pre_prompt+="\[${RESET}\] at "
pre_prompt+="\[${BOLD}\]\[${hostStyle}\]\h" # host
pre_prompt+="\[${RESET}\] in "
pre_prompt+="\[${BOLD}\]\[${BLUE}\]\w" # working directory full path
pre_prompt+="\[${RESET}\]"             # reset styling

# - - - - - - - - - - - - - - - - - - - - - - - }}}
# set the post_prompt                           {{{
post_prompt="\n"
# post_prompt+="\[${MAGENTA}\][\!]" # history line number for easy hist expansion
# shellcheck disable=2016
post_prompt+='$(if [ $? -ne 0 ]; then printf "\[%s\]✘  " "$RED"; else printf "\[%s\]❱  " "$GREEN"; fi;)'
post_prompt+="\[${RESET}\]" # reset styling

# - - - - - - - - - - - - - - - - - - - - - - - }}}

if command -v __git_ps1 >/dev/null 2>&1; then
    PROMPT_COMMAND='__git_ps1 "${pre_prompt}" "${post_prompt}"'
else
    PROMPT_COMMAND='export PS1=${pre_prompt}${post_prompt}'
fi

PS2="\[${YELLOW}\]… \[${RESET}\] "

export PROMPT_COMMAND PS2

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
