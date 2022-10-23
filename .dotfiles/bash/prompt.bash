#!/usr/bin/env bash

# Use Starship for the prompt if installed
# Otherwise create a prompt manually
if [[ "$(type -P starship)" ]]; then
  # Only use Nerd Font symbols if one of the fonts is installed
  FONTS_DIR="$HOME/.local/share/fonts"
  if [[ $(find "$FONTS_DIR" -iname '*Nerd Font*') ]]; then
    export STARSHIP_CONFIG=~/.config/starship/nerdfont.starship.toml
  else
    export STARSHIP_CONFIG=~/.config/starship/starship.toml
  fi
  eval "$(starship init bash)"
else
  source ~/.dotfiles/bash/lib/git-prompt.bash

  if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM='gnome-256color'
  elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM='xterm-256color'
  fi

  if tput setaf 1 &>/dev/null; then
    tput sgr0 # reset colors
    bold=$(tput bold)
    reset=$(tput sgr0)
    # Gruvbox colors from: https://github.com/morhetz/gruvbox
    export black=$(tput setaf 235)
    export blue=$(tput setaf 66)
    export aqua=$(tput setaf 72)
    export green=$(tput setaf 106)
    export orange=$(tput setaf 166)
    export purple=$(tput setaf 132)
    export red=$(tput setaf 124)
    export white=$(tput setaf 230)
    export yellow=$(tput setaf 172)
  else
    bold=''
    reset="\e[0m"
    export black="\e[1;30m"
    export blue="\e[1;34m"
    export aqua="\e[1;36m"
    export green="\e[1;32m"
    export orange="\e[1;33m"
    export purple="\e[1;35m"
    export red="\e[1;31m"
    export white="\e[1;37m"
    export yellow="\e[1;33m"
  fi

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
  GIT_PS1_SHOWDIRTYSTATE="yes"
  GIT_PS1_SHOWSTASHSTATE="yes"
  GIT_PS1_SHOWUNTRACKEDFILES="yes"
  GIT_PS1_SHOWUPSTREAM="verbose"
  GIT_PS1_SHOWCONFLICTSTATE="yes"
  GIT_PS1_SHOWCOLORHINTS="yes"

  pre_prompt="\n"
  pre_prompt+="\[${bold}\]\[${userStyle}\]\u" # username
  pre_prompt+="\[${reset}\] at "
  pre_prompt+="\[${bold}\]\[${hostStyle}\]\h" # host
  pre_prompt+="\[${reset}\] in "
  pre_prompt+="\[${bold}\]\[${aqua}\]\w" # working directory full path
  pre_prompt+="\[${reset}\]" # reset styling

  post_prompt="\n"
  post_prompt+="\[${blue}\]\! " # history line number for easy hist expansion
  post_prompt+="\[${white}\]☕  " # add symbol, other options: ∴ ↪ ↳
  post_prompt+="\[${reset}\]" # reset styling

  PROMPT_COMMAND='__git_ps1 "${pre_prompt}" "${post_prompt}"'

  PS2="\[${yellow}\]→ \[${reset}\]"

  export PS2
fi
