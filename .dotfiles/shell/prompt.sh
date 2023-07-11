#!/usr/bin/env bash

# show readline mode                                          {{{
# [E]macs, vi [I]nsert, or vi [C]ommand
bind "set show-mode-in-prompt on"
bind "set emacs-mode-string \"E \""
bind "set vi-cmd-mode-string \"C \""
bind "set vi-ins-mode-string \"I \""

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}

# use starship for the prompt if installed                    {{{
if false && is-supported starship; then
    eval "$(starship init bash)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# otherwise create a prompt manually using ps1                {{{
else

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
    # post_prompt+="\[${PURPLE}\][\!]" # history line number for easy hist expansion
    # shellcheck disable=2181,2016
    post_prompt+='$(
      _exit_code="$?"
      if [ $_exit_code -ne 0 ]; then
        printf "\[%s\]%s✘  " "$RED" "$_exit_code"
      else
        printf "\[%s\]❱  " "$GREEN"
      fi
    )'
    post_prompt+="\[${RESET}\]" # reset styling

    # - - - - - - - - - - - - - - - - - - - - - - - }}}

    # shellcheck disable=2154
    PROMPT_COMMAND='__git_ps1 "${pre_prompt}" "${post_prompt}"'

    PS2="\[${YELLOW}\]→ \[${RESET}\]"

    export PS2
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
