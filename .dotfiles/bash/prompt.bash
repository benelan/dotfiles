#!/usr/bin/env bash

# Use Starship for the prompt if installed
# Otherwise create a prompt manually
if [[ "$(type -P starship)" ]]; then
  # Only use Nerd Font symbols if one of the fonts is installed
  FONTS_DIR="$HOME/.local/share/fonts"
  if [[ $(find "$FONTS_DIR" -iname '*Nerd Font*') ]]; then
    export STARSHIP_CONFIG=~/.config/starship/starship.toml
  else
    export STARSHIP_CONFIG=~/.config/starship/unicode.starship.toml
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

  # Set the terminal title and prompt.
  PS1="\[\033]0;\W\007\]"   # working directory base name
  PS1+="\[${bold}\]\n"      # newline
  PS1+="\[${userStyle}\]\u" # username
  PS1+="\[${white}\] at "
  PS1+="\[${hostStyle}\]\h" # host
  PS1+="\[${white}\] in "
  PS1+="\[${aqua}\]\w" # working directory full path
  # PS1+="\[${white}\] on ";
  PS1+="\[${green}\]"'`__git_ps1`' # Git repository details
  PS1+="\n"
  PS1+="\[${white}\]☕ \[${reset}\]" # symbol (and reset color)
  # λ ⏩ ॐ ℷ⚡⚪☕✋✨ ∃ ∑ ∴ ↪ ↳

  # prompt with background color
  # PS1='\n\n\[\e[97;104m\] \u \[\e[30;43m\] \w \[\e[97;45m\] `__git_ps1` \[\e[0m\]\n\n'

  export PS1

  PS2="\[${yellow}\]→ \[${reset}\]"
  export PS2
fi
