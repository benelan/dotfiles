#!/usr/bin/env bash

git clone --bare git@github.com:benelan/dotfiles "$HOME"/.myconf
function dotfiles {
   /usr/bin/git --git-dir="$HOME"/.myconf/ --work-tree="$HOME" "$@"
}
dotfiles checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles";
  else
    echo "Backing up pre-existing dotfiles";
    mkdir -p .dotfiles-backup
    rsync --remove-source-files -avh "$(dotfiles checkout 2>&1 | grep -E "\s+\." | awk {'print $1'})" "$HOME"/.dotfiles-backup
fi;
dotfiles checkout 
dotfiles config status.showUntrackedFiles no
