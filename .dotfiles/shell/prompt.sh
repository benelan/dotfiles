#!/usr/bin/env bash

# Use Starship for the prompt if installed
# Otherwise create a prompt manually
if is-supported starship; then
    # Only use Nerd Font symbols if they are available
    # if [[ $(find "$HOME/.local/share/fonts" -iname '*Nerd Font*') ]] || [[ "$TERM" == "wezterm" ]] || [[ "$OG_TERM" == "wezterm" ]]; then
    #     export STARSHIP_CONFIG=~/.config/starship/nerdfont.starship.toml
    # else
        export STARSHIP_CONFIG=~/.config/starship/starship.toml
    # fi
    eval "$(starship init bash)"
else
    # shellcheck disable=1090
    source ~/.dotfiles/shell/lib/git-prompt.sh

    if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
        export TERM='gnome-256color'
    elif infocmp xterm-256color >/dev/null 2>&1; then
        export TERM='xterm-256color'
    fi

    if tput setaf 1 >/dev/null 2>&1; then
        reset=$(tput sgr0)
        bold=$(tput bold)
        underline=$(tput smul)
        # Gruvbox colors from: https://github.com/morhetz/gruvbox
        black=$(tput setaf 235)
        blue=$(tput setaf 66)
        aqua=$(tput setaf 72)
        green=$(tput setaf 106)
        orange=$(tput setaf 166)
        purple=$(tput setaf 132)
        red=$(tput setaf 124)
        white=$(tput setaf 230)
        yellow=$(tput setaf 172)
    else
        reset="\e[0m"
        bold='\e[1m'
        underline='e[4m'
        black="\e[1;30m"
        blue="\e[1;34m"
        aqua="\e[1;36m"
        green="\e[1;32m"
        orange="\e[1;33m"
        purple="\e[1;35m"
        red="\e[1;31m"
        white="\e[1;37m"
        yellow="\e[1;33m"
    fi
    export bold underline black blue aqua \
        green orange purple red white yellow

    # Highlight the user name when logged in as root.
    if [[ "${USER}" == "root" ]]; then
        userStyle="${bold}${red}"
    else
        userStyle="${orange}"
    fi

    # Highlight the hostname when connected via SSH.
    if [[ "${SSH_TTY}" ]]; then
        hostStyle="${bold}${red}"
    else
        hostStyle="${yellow}"
    fi

    # get status of git repo in prompt
    export GIT_PS1_SHOWDIRTYSTATE="yes"
    export GIT_PS1_SHOWSTASHSTATE="yes"
    export GIT_PS1_SHOWUNTRACKEDFILES="yes"
    export GIT_PS1_SHOWUPSTREAM="verbose"
    export GIT_PS1_SHOWCONFLICTSTATE="yes"
    export GIT_PS1_SHOWCOLORHINTS="yes"

    pre_prompt="\[${reset}\]\n"
    pre_prompt+="\[${bold}\]\[${userStyle}\]\u" # username
    pre_prompt+="\[${reset}\] at "
    pre_prompt+="\[${bold}\]\[${hostStyle}\]\h" # host
    pre_prompt+="\[${reset}\] in "
    pre_prompt+="\[${bold}\]\[${aqua}\]\w" # working directory full path
    pre_prompt+="\[${reset}\]"             # reset styling

    post_prompt="\n"
    post_prompt+="\[${blue}\]\! "  # history line number for easy hist expansion
    post_prompt+="\[${white}\]☕  " # add symbol, other options: ∴ ↪ ↳
    post_prompt+="\[${reset}\]"    # reset styling

    PROMPT_COMMAND='__git_ps1 "${pre_prompt}" "${post_prompt}"'

    PS2="\[${yellow}\]→ \[${reset}\]"

    export PS2
fi
