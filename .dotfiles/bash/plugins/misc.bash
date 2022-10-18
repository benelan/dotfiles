#!/usr/bin/env bash

eval "$(thefuck --alias)"

eval "$(fasd --init auto)"


function ff() {
  local fff=~/.dotfiles/bash/lib/fff.bash
  [ -r "$fff" ] && [ -f "$fff" ] && source "$fff"
}