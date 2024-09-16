#!/usr/bin/env bash
# vim:filetype=sh foldmethod=marker:
# shellcheck disable=2016

# show readline mode {{{1
# [E]macs, vi [I]nsert, or vi [C]ommand
bind "set show-mode-in-prompt on"
bind "set emacs-mode-string \"E \""
bind "set vi-cmd-mode-string \"C \""
bind "set vi-ins-mode-string \"I \""

# trim long paths if possible {{{1
if ((BASH_VERSINFO[0] >= 4)); then
    PROMPT_DIRTRIM=4
fi

# highlight username when logged in as root {{{1
if [ "$EUID" -eq 0 ]; then
    userStyle="${BOLD}${RED}"
else
    userStyle="${ORANGE}"
fi

# highlight hostname when connected via SSH {{{1
if [ -n "${SSH_TTY}" ]; then
    hostStyle="${BOLD}${RED}"
else
    hostStyle="${YELLOW}"
fi

# git prompt options {{{1
export GIT_PS1_SHOWDIRTYSTATE="yes"
export GIT_PS1_SHOWSTASHSTATE="yes"
export GIT_PS1_SHOWUNTRACKEDFILES="yes"
export GIT_PS1_SHOWCONFLICTSTATE="yes"
export GIT_PS1_SHOWCOLORHINTS="yes"
export GIT_PS1_COMPRESSSPARSESTATE="yes"
export GIT_PS1_HIDE_IF_PWD_IGNORED="yes"
export GIT_PS1_SHOWUPSTREAM="verbose"
export GIT_PS1_DESCRIBE_STYLE="contains"

# set the pre_prompt {{{1
__pre_prompt="\[${RESET}\]\n"
__pre_prompt+="\[${BOLD}\]\[${userStyle}\]$(
    # replace username with (n)vim when using the builtin terminal
    if [ -n "$NVIM" ]; then
        echo "nvim"
    elif [ -n "$VIMRUNTIME" ]; then
        echo "vim"
    else
        echo "\u" # username
    fi
)"
__pre_prompt+="\[${RESET}\]"

# https://wezfurlong.org/wezterm/config/lua/keyassignment/ScrollToPrompt.html
__pre_prompt+="\e]133;P\e\\ " # OSC 133 - prompt
__pre_prompt+="at"
__pre_prompt+="\e]133;B\e\\ "
__pre_prompt+="\[${BOLD}\]\[${hostStyle}\]\h" # host
__pre_prompt+="\[${RESET}\]"
__pre_prompt+=" in "
__pre_prompt+="\[${BOLD}\]\[${BLUE}\]\w" # PWD
__pre_prompt+="\[${RESET}\]"

# set the post_prompt {{{1
__post_prompt="\n"

# NOTE: this history number won't always be correct when ignoring duplicates
# __post_prompt+="\[${CYAN}\]!\!\[${RESET}\] "

__post_prompt+='$(
    __exit="$?"

    if [ -z "$TMUX" ] && [ $SHLVL -gt 1 ] || [ $SHLVL -gt 2 ]; then
        printf "%sL%s " '"\"\[$MAGENTA\]\""' "$SHLVL"
    fi

    if [ "$__exit" -ne 0 ]; then
        printf "%s%s✘  " '"\"\[$RED\]\""' "$__exit";
    else
        printf "%s❱ " '"\"\[$GREEN\]\""'
    fi
)'

__post_prompt+="\[${RESET}\]"

# setup git info and bash history {{{1
# shellcheck disable=2089
PROMPT_COMMAND='history -a; __git_ps1 "${__pre_prompt}" "${__post_prompt}"'

# setup fasd integration {{{1
if supports fasd; then
    __prompt_fasd() {
        eval "fasd --proc $(
            fasd --sanitize "$(history 1 | sed "s/^[ ]*[0-9]*[ ]*//")"
        )" >/dev/null 2>&1
    }

    PROMPT_COMMAND="__prompt_fasd; $PROMPT_COMMAND"
fi

# setup osc7 integration {{{1
# https://codeberg.org/dnkl/foot/wiki#shell-integration
__prompt_osc7() {
    local strlen=${#PWD}
    local encoded=""
    local pos c o
    for ((pos = 0; pos < strlen; pos++)); do
        c=${PWD:$pos:1}
        case "$c" in
            [-/:_.!\'\(\)~[:alnum:]]) o="${c}" ;;
            *) printf -v o '%%%02X' "'${c}" ;;
        esac
        encoded+="${o}"
    done
    printf '\e]7;file://%s%s\e\\' "${HOSTNAME}" "${encoded}"
}

PROMPT_COMMAND="__prompt_osc7; $PROMPT_COMMAND"

# setup PS2 {{{1
# shellcheck disable=2090
export PROMPT_COMMAND PS2="\[${YELLOW}\]↳ \[${RESET}\] "
