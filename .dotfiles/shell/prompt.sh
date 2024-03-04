#!/usr/bin/env bash
# shellcheck disable=2016

# - - - - - - - - - - - - - - - - - - - - - - - }}}
# show readline mode                            {{{

# [E]macs, vi [I]nsert, or vi [C]ommand
bind "set show-mode-in-prompt on"
bind "set emacs-mode-string \"E \""
bind "set vi-cmd-mode-string \"C \""
bind "set vi-ins-mode-string \"I \""

# - - - - - - - - - - - - - - - - - - - - - - - }}}
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
# highlight hostname when connected via SSH     {{{

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
pre_prompt+="\[${BOLD}\]\[${userStyle}\]$(
    # replace username with (n)vim when using the builtin terminal
    if [ -n "$NVIM" ]; then
        echo "nvim"
    elif [ -n "$VIMRUNTIME" ]; then
        echo "vim"
    else
        echo "\u" # username
    fi
)"

pre_prompt+="\[${RESET}\] at "
pre_prompt+="\[${BOLD}\]\[${hostStyle}\]\h" # host
pre_prompt+="\[${RESET}\] in "
pre_prompt+="\[${BOLD}\]\[${BLUE}\]\w" # PWD
pre_prompt+="\[${RESET}\]"

# - - - - - - - - - - - - - - - - - - - - - - - }}}
# set the post_prompt                           {{{

post_prompt="\n"

# NOTE: this history number won't always be correct when ignoring duplicates
# post_prompt+="\[${CYAN}\]!\!\[${RESET}\]"

# show the shell level if its greater than 1 (or 2 if in tmux)
# show the exit code of the previous command if it failed
post_prompt+='$(
    _exit="$?"

    if [ -z "$TMUX" ] && [ $SHLVL -gt 1 ] || [ $SHLVL -gt 2 ]; then
        printf "%sL%s " '"\"\[$MAGENTA\]\""' "$SHLVL"
    fi

    if [ "$_exit" -ne 0 ]; then
        printf "%s%s✘  " '"\"\[$RED\]\""' "$_exit";
    else
        printf "%s❱ " '"\"\[$GREEN\]\""'
    fi
)'

post_prompt+="\[${RESET}\]" # reset styling

# - - - - - - - - - - - - - - - - - - - - - - - }}}
# setup git prompt                              {{{

# shellcheck disable=2089
PROMPT_COMMAND='__git_ps1 "${pre_prompt}" "${post_prompt}"'

# - - - - - - - - - - - - - - - - - - - - - - - }}}
# setup fasd                                    {{{

if is-supported fasd; then
    _fasd_prompt_func() {
        eval "fasd --proc $(fasd --sanitize "$(history 1 |
            sed "s/^[ ]*[0-9]*[ ]*//")")" >>"/dev/null" 2>&1
    }

    case $PROMPT_COMMAND in
        *_fasd_prompt_func*) ;;
        *) PROMPT_COMMAND="_fasd_prompt_func;$PROMPT_COMMAND" ;;
    esac
fi

# - - - - - - - - - - - - - - - - - - - - - - - }}}
# append session's history lines to file        {{{

case $PROMPT_COMMAND in
    *"history -a"*) ;;
    *) PROMPT_COMMAND="history -a; $PROMPT_COMMAND" ;;
esac

# - - - - - - - - - - - - - - - - - - - - - - --}}}
# setup PS2                                     {{{

# shellcheck disable=2090
export PROMPT_COMMAND PS2="\[${YELLOW}\]… \[${RESET}\] "

# - - - - - - - - - - - - - - - - - - - - - - --}}}
