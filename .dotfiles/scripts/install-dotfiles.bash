#!/usr/bin/env bash

git clone --bare git@github.com:benelan/dotfiles ~/.myconf
function dotfiles {
   /usr/bin/git --git-dir=~/.myconf/ --work-tree="$HOME" "$@"
}
dotfiles checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles";
  else
    echo "Backing up pre-existing dotfiles";
    mkdir -p .dotfiles-backup
    rsync --remove-source-files -avh "$(dotfiles checkout 2>&1 | grep -E "\s+\." | awk {'print $1'})" ~/.dotfiles-backup
fi;
dotfiles checkout 
dotfiles config status.showUntrackedFiles no


# Install fzf
if [[ ! "$(type -P fzf)" ]]; then
~/.dotfiles/vendor/fzf/install --key-bindings --completion --no-fish --no-update-rc
fi


# Install SourceCodePro Patched Nerd Font if they aren't already there
# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/SourceCodePro
mkdir -p ~./fonts
if [[ $(find ~/.fonts -iname 'Sauce Code Pro*Nerd Font Complete.ttf' | wc -l) -lt 5 ]]; then 
  cd ~/.local/share/fonts && curl -fLo "Sauce Code Pro Medium Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Medium/complete/Sauce%20Code%20Pro%20Medium%20Nerd%20Font%20Complete.ttf
  cd ~/.local/share/fonts && curl -fLo "Sauce Code Pro Regular Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf
  cd ~/.local/share/fonts && curl -fLo "Sauce Code Pro Bold Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Bold/complete/Sauce%20Code%20Pro%20Bold%20Nerd%20Font%20Complete.ttf
  cd ~/.local/share/fonts && curl -fLo "Sauce Code Pro Italic Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Italic/complete/Sauce%20Code%20Pro%20Italic%20Nerd%20Font%20Complete.ttf
  cd ~/.local/share/fonts && curl -fLo "Sauce Code Pro Bold Italic Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Black-Italic/complete/Sauce%20Code%20Pro%20Black%20Italic%20Nerd%20Font%20Complete.ttf
fi

# Install volta if necessary
if [[ ! "$VOLTA_HOME" ]]; then
  curl https://get.volta.sh | bash -s -- --skip-setup
  export VOLTA_HOME=~/.volta
  grep --silent "$VOLTA_HOME/bin" <<< "$PATH" || export PATH="$VOLTA_HOME/bin:$PATH"
  volta install node
  volta install yarn
  volta install tsc
fi
