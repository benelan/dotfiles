#!/bin/sh

# This script sets up my dotfiles in a bare git repo
# so everything is tracked and under version control.
# I used symlinks for a while but they can be a pain.
# There are `dot` aliases to manage the bare repo in
# ~/.dotfiles/sh/aliases/git.alias.sh

# any current, conflicting dotfiles will be moved here
BACKUP_DIR="$HOME/.dotfiles-backup/"

# Don't use SSH to clone if there is no SSH key on the machine
if find ~/.ssh -type f -name '*.pub' | wc -l | xargs test 0 -eq; then
  GIT_URL=https://github.com/benelan/dotfiles
else
  GIT_URL=git@github.com:benelan/dotfiles
fi

git clone --bare "$GIT_URL" "$HOME/.git"

if /usr/bin/git --git-dir="$HOME/.git/" --work-tree="$HOME" checkout; then
  echo "Checked out dotfiles"
else
  echo "Backing up pre-existing dotfiles"
  # Get the list of files that need to be backed up
  files=$(/usr/bin/git --git-dir="$HOME/.git/" --work-tree="$HOME" \
    checkout 2>&1 | grep -e "^\s")

  # Get the directories by removing everything after the last "/" from file paths
  # Files in $HOME will end up being blank lines, which need to be stripped
   dirs=$(echo "$files" | awk 'BEGIN{FS=OFS="/"} {NF--} 1' | grep .)
  # Create the directories in $BACKUP_DIR
  mkdir -p "$BACKUP_DIR"
  echo "$dirs" | xargs -I{} mkdir -p "$BACKUP_DIR{}"
  # Move the conflicting files to the new directories
  echo "$files" | xargs -I{} mv {} "$BACKUP_DIR/{}"

  # Checkout the dotfiles now that there are no conflicts
  # To undo this script, move the files from $BACKUP_DIR to $HOME
  # $ mv ~/.dotfiles-backup/* ~/
  /usr/bin/git --git-dir="$HOME/.git/" --work-tree="$HOME" checkout
fi

# Prevents showing everything in $HOME when using status/diff
# Dotfiles need to be manually added for them to show up
# $ dot add ~/.npmrc
/usr/bin/git --git-dir="$HOME/.git/" --work-tree="$HOME" \
  config status.showUntrackedFiles no

unset files
unset GIT_URL
unset BACKUP_DIR

# Remove extra files
/usr/bin/git --git-dir="$HOME/.git/" --work-tree="$HOME" \
  update-index --assume-unchanged "$HOME/LICENSE.md" "$HOME/README.md"
rm -f "$HOME/README.md" "$HOME/LICENSE.md"

# Make the bins executable
[ -d ~/.bin/ ] && chmod +x ~/.bin/*

# Install fzf
if [ ! "$(command -v fzf)" ] ; then
  /usr/bin/git --git-dir="$HOME/.git/" --work-tree="$HOME" \
    submodule update --init .dotfiles/vendor/fzf
  ~/.dotfiles/vendor/fzf/install --bin
fi
