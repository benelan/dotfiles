#!/bin/sh

# any current, conflicting dotfiles will be moved here
BACKUP_DIR="$HOME/.dotfiles-backup/"

# Check if there is an ssh key that _might_ be for github
# Don't use SSH to clone if there is no SSH key
if find ~/.ssh -type f -name 'id_rsa.pub' -o -name 'id_ed25519.pub' -o -name 'id_ecdsa.pub' |
  wc -l | xargs test 0 -eq; then
  GIT_URL=https://github.com/benelan/dotfiles
else
  GIT_URL=git@github.com:benelan/dotfiles
fi

git clone --bare "$GIT_URL" "$HOME/.git"

if /usr/bin/git --git-dir="$HOME/.git/" --work-tree="$HOME" checkout; then
  echo "Checked out dotfiles"
else
  echo "Backing up pre-existing dotfiles"
  # get the list of files that need to be backed up
  files=$(/usr/bin/git --git-dir="$HOME/.git/" --work-tree="$HOME" checkout 2>&1 | grep -e "^\s")
 
  # get names of the directories by
  # removing everything after the last "/" from file paths
  # files in ~ will end up being blank lines, which need to be stripped
  folders=$(echo "$files" | awk 'BEGIN{FS=OFS="/"} {NF--} 1' | sed '/^[[:blank:]]*$/d')
  
  # finally create the directories in the BACKUP_DIR
  mkdir -p "$BACKUP_DIR"
  echo "$folders" | xargs -I{} mkdir -p "$BACKUP_DIR{}"
  # move the files to the new directories
  echo "$files" | xargs -I{} mv {} "$BACKUP_DIR/{}"

  # alternatively you can use rsync to backup the files
  # rsync --remove-source-files -avh \
  #     $(dotfiles checkout 2>&1 | grep -E "\s+\." | awk {'print $1'}) "$BACKUP_DIR"

  # checkout the dotfiles now that there are no conflicts
  /usr/bin/git --git-dir="$HOME/.git/" --work-tree="$HOME" checkout 
fi

# prevents showing everything in ~
# to track new files: "dot add ~/.npmrc"
/usr/bin/git --git-dir="$HOME/.git/" --work-tree="$HOME" config status.showUntrackedFiles no

# Install fzf
if [[ ! "$(command -v fzf)" ]]; then
  /usr/bin/git --git-dir="$HOME/.git/" --work-tree="$HOME" submodule update --init .dotfiles/vendor/fzf
  ~/.dotfiles/vendor/fzf/install --bin
fi

unset files
unset GIT_URL
unset BACKUP_DIR

# Remove extra files
/usr/bin/git --git-dir="$HOME/.git/" --work-tree="$HOME" update-index --assume-unchanged "$HOME/LICENSE.md"
/usr/bin/git --git-dir="$HOME/.git/" --work-tree="$HOME" update-index --assume-unchanged "$HOME/README.md"
rm -f "$HOME/README.md" "$HOME/LICENSE.md"
rm -f "$HOME/LICENSE.md"

# make the bins executable
[ -d ~/.bin/ ] && chmod +x ~/.bin/*;
