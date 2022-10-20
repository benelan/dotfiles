#!/bin/sh

# any current, conflicting dotfiles will be moved here
BACKUP_DIR="$HOME/.dotfiles-backup"

git clone --bare git@github.com:benelan/dotfiles "$HOME/.git";

# creates alias for managing dotfiles
# this alias is also included in the dotfiles 
alias dotfiles='/usr/bin/git --git-dir=$HOME/.git/ --work-tree=$HOME';

if dotfiles checkout; then
  echo "Checked out dotfiles";
  else
    echo "Backing up pre-existing dotfiles";
    # get the list of files that need to be backed up
    files=$(dotfiles checkout 2>&1 | grep -E "\s+\.");

    # get names of the directories by 
    # removing everything after the last "/" from file paths
    # files in ~ will end up being blank lines, which need to be stripped
    # finally create the directories in the BACKUP_DIR
    echo "$files" | awk 'BEGIN{FS=OFS="/"} {NF--} 1' | \
      sed '/^[[:blank:]]*$/d' | \
      xargs -I{} mkdir -p "$BACKUP_DIR/{}"

    # move the files to the new directories
    echo "$files" | xargs -I{} mv {} "$BACKUP_DIR/{}"

    # alternatively you can use rsync to backup the files
    # rsync --remove-source-files -avh $(dotfiles checkout 2>&1 | grep -E "\s+\." | awk {'print $1'}) "$BACKUP_DIR"

    # check out the dotfiles now that there are no conflicts
    dotfiles checkout;
fi;

# prevents showing everything in ~ 
# to track files: "dotfiles add ~/.npmrc"
dotfiles config status.showUntrackedFiles no;


# Install fzf
if [[ ! "$(command -v fzf)" ]]; then
  "$HOME/.dotfiles/vendor/fzf/install --key-bindings --completion --no-fish --no-update-rc";
fi

# Install SourceCodePro Patched Nerd Font if they aren't already there
# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/SourceCodePro
fonts="$HOME/.fonts";
mkdir -p "$fonts"
if [[ $(find "$fonts" -iname 'Sauce Code Pro*Nerd Font Complete.ttf' | wc -l) -lt 5 ]]; then 
  cd "$fonts" && curl -fLo "Sauce Code Pro Medium Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Medium/complete/Sauce%20Code%20Pro%20Medium%20Nerd%20Font%20Complete.ttf;
  cd "$fonts" && curl -fLo "Sauce Code Pro Regular Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf;
  cd "$fonts" && curl -fLo "Sauce Code Pro Bold Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Bold/complete/Sauce%20Code%20Pro%20Bold%20Nerd%20Font%20Complete.ttf;
  cd "$fonts" && curl -fLo "Sauce Code Pro Italic Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Italic/complete/Sauce%20Code%20Pro%20Italic%20Nerd%20Font%20Complete.ttf;
  cd "$fonts" && curl -fLo "Sauce Code Pro Bold Italic Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Black-Italic/complete/Sauce%20Code%20Pro%20Black%20Italic%20Nerd%20Font%20Complete.ttf;
fi

# reload the font cache
fc-cache -rf



unset BACKUP_DIR;