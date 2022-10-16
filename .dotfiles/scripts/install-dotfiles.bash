#!/usr/bin/env bash

git clone --bare git@github.com:benelan/dotfiles $HOME/.myconf
function config {
   /usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME $@
}
config checkout
if [ $? = 0 ]; then
  echo "Checked out config";
  else
    echo "Backing up pre-existing dotfiles";
    mkdir -p .dotfiles-backup
    rsync --remove-source-files -avh $(config checkout 2>&1 | egrep "\s+\." | awk {'print $1'}) $HOME/.dotfiles-backup
fi;
config checkout 
config config status.showUntrackedFiles no
if [ -f $HOME/README.md ]; then rm $HOME/README.md; fi
