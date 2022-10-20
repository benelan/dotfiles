#!/bin/sh

# any current, conflicting dotfiles will be moved here
BACKUP_DIR="$HOME/.dotfiles-backup/"

# Check if there is an ssh key that _might_ be for github
# if find ~/.ssh -type f -name 'id_rsa.pub' -o -name 'id_ed25519.pub' -o -name 'id_ecdsa.pub' |
#   wc -l | xargs test 0 -eq; then
#   GIT_URL=https://github.com/benelan/dotfiles
# else
GIT_URL=git@github.com:benelan/dotfiles
# fi

git clone --bare "$GIT_URL" "$HOME/.git"


/usr/bin/git --git-dir="$HOME/.git/" --work-tree="$HOME" checkout 
if [ "$?" == 0 ]; then
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

  # check out the dotfiles now that there are no conflicts
  /usr/bin/git --git-dir="$HOME/.git/" --work-tree="$HOME" checkout 
fi

# prevents showing everything in ~
# to track files: "dots add ~/.npmrc"
/usr/bin/git --git-dir="$HOME/.git/" --work-tree="$HOME" config status.showUntrackedFiles no

# Install fzf
if [[ ! "$(command -v fzf)" ]]; then
  /usr/bin/git --git-dir="$HOME/.git/" --work-tree="$HOME" submodule update --init .dotfiles/vendor/fzf
  ~/.dotfiles/vendor/fzf/install --key-bindings --completion --no-fish --no-update-rc
fi

# Install SourceCodePro Patched Nerd Font if they aren't already there
# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/SourceCodePro
fonts="$HOME/.fonts"
mkdir -p "$fonts"
if [[ $(find "$fonts" -iname 'Sauce Code Pro*Nerd Font Complete.ttf' | wc -l) -lt 5 ]]; then
  cd "$fonts" && curl -fLo "Sauce Code Pro Medium Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Medium/complete/Sauce%20Code%20Pro%20Medium%20Nerd%20Font%20Complete.ttf
  cd "$fonts" && curl -fLo "Sauce Code Pro Regular Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf
  cd "$fonts" && curl -fLo "Sauce Code Pro Bold Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Bold/complete/Sauce%20Code%20Pro%20Bold%20Nerd%20Font%20Complete.ttf
  cd "$fonts" && curl -fLo "Sauce Code Pro Italic Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Italic/complete/Sauce%20Code%20Pro%20Italic%20Nerd%20Font%20Complete.ttf
  cd "$fonts" && curl -fLo "Sauce Code Pro Bold Italic Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Black-Italic/complete/Sauce%20Code%20Pro%20Black%20Italic%20Nerd%20Font%20Complete.ttf
fi

# reload the font cache
fc-cache -rf

unset fonts
unset files
unset GIT_URL
unset BACKUP_DIR


rm -f "$HOME/README.md"
rm -f "$HOME/LICENSE.md"