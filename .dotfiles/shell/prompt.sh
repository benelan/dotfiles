#!/usr/bin/env bash

# show readline mode                                          {{{
# [E]macs, vi [I]nsert, or vi [C]ommand
bind "set show-mode-in-prompt on"
bind "set emacs-mode-string \"E \""
bind "set vi-cmd-mode-string \"C \""
bind "set vi-ins-mode-string \"I \""

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}

# use starship for the prompt if installed                    {{{
if is-supported starship; then
    # Only use Nerd Font symbols if they are available
    # if [ "$TERM" == "wezterm" ] ||
    #     # [ -n "$(find "$HOME/.local/share/fonts" -iname '*Nerd Font*')" ] ||
    #     tmux showenv | grep -q 'TERM=wezterm'; then
    #     export STARSHIP_CONFIG=~/.config/starship/nerdfont.starship.toml
    # else
    export STARSHIP_CONFIG=~/.config/starship/starship.toml
    # fi
    eval "$(starship init bash)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}

# otherwise create a prompt manually using ps1                {{{
else

    # If Bash 4.0 is available, trim very long paths in prompt
    if ((BASH_VERSINFO[0] >= 4)); then
        PROMPT_DIRTRIM=4
    fi

    # Highlight the user name when logged in as root.
    if [[ "${USER}" == "root" ]]; then
        userStyle="${BOLD}${RED}"
    else
        userStyle="${ORANGE}"
    fi

    # Highlight the hostname when connected via SSH.
    if [[ "${SSH_TTY}" ]]; then
        hostStyle="${BOLD}${RED}"
    else
        hostStyle="${YELLOW}"
    fi

    # get status of git repo in prompt
    export GIT_PS1_SHOWDIRTYSTATE="yes"
    export GIT_PS1_SHOWSTASHSTATE="yes"
    export GIT_PS1_SHOWUNTRACKEDFILES="yes"
    export GIT_PS1_SHOWUPSTREAM="verbose"
    export GIT_PS1_SHOWCONFLICTSTATE="yes"
    export GIT_PS1_SHOWCOLORHINTS="yes"

    pre_prompt="\[${RESET}\]\n"
    pre_prompt+="\[${BOLD}\]\[${userStyle}\]\u" # username
    pre_prompt+="\[${RESET}\] at "
    pre_prompt+="\[${BOLD}\]\[${hostStyle}\]\h" # host
    pre_prompt+="\[${RESET}\] in "
    pre_prompt+="\[${BOLD}\]\[${BLUE}\]\w" # working directory full path
    pre_prompt+="\[${RESET}\]"             # reset styling

    post_prompt="\n"
    post_prompt+="\[${PURPLE}\][\!]" # history line number for easy hist expansion
    # shellcheck disable=2181,2016
    post_prompt+='$(if [ $? -ne 0 ]; then printf "\[%s\] ✘  " "$red"; else printf "\[%s\] ❯ " "$green"; fi)'
    post_prompt+="\[${RESET}\]" # reset styling

    # shellcheck disable=2154
    PROMPT_COMMAND='__git_ps1 "${pre_prompt}" "${post_prompt}"'

    PS2="\[${YELLOW}\]→ \[${RESET}\]"

    export PS2
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
