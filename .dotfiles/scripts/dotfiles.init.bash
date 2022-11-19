#!/bin/sh

# This script sets up my dotfiles in a bare git repo
# so everything is tracked and under version control.
# I used symlinks for a while but they are too messy.
# There are `dot` aliases to manage the bare repo in
# ~/.dotfiles/sh/aliases/git.alias.sh

[ -d ~/.git ] &&
    echo "✖ The home directory is already under version control.
  ➜ Use 'dot pull' to update the dotfiles.
  ➜ Remove $HOME/.git and run the script again to continue." &&
    return

# any current, conflicting dotfiles will be moved here
BACKUP_DIR="$HOME/.dotfiles-backup"

dot() {
    /usr/bin/git --git-dir="$HOME"/.git/ --work-tree="$HOME" "$@"
}

# Don't use SSH to clone if there is no SSH key on the machine
if find ~/.ssh -type f -name '*.pub' | wc -l | xargs test 0 -eq; then
    GIT_URL=https://github.com/benelan/dotfiles
else
    GIT_URL=git@github.com:benelan/dotfiles
fi

git clone --bare "$GIT_URL" "$HOME/.git"

if dot checkout >/dev/null 2>&1; then
    printf "\n✔ Checked out dotfiles\n"
else
    printf "\n➜ Backing up conflicting dotfiles to %s\n" "$BACKUP_DIR"
    # Get the list of files that need to be backed up
    files=$(dot checkout 2>&1 | grep -e "^\s")
    printf "%s\n" "$files"

    # Get the directories by removing everything after the last "/" from file paths
    # Files in $HOME will end up being blank lines, which need to be stripped
    dirs=$(echo "$files" | awk 'BEGIN{FS=OFS="/"} {NF--} 1' | sed '/^[[:blank:]]*$/d')
    # Create the directories in $BACKUP_DIR
    mkdir -p "$BACKUP_DIR"
    echo "$dirs" | xargs -I{} mkdir -p "$BACKUP_DIR/{}"
    # Move the conflicting files to the new directories
    echo "$files" | xargs -I{} mv {} "$BACKUP_DIR/{}"

    # Checkout the dotfiles now that there are no conflicts
    # To undo this script, move the files from $BACKUP_DIR to $HOME
    # $ mv ~/.dotfiles-backup/* ~/
    if ! dot checkout; then
        printf "\n✖ Unable to initialize the dotfiles\n"
        return
    else
        printf "\n✔ Checked out dotfiles\n"
    fi
fi

# Prevents showing everything in $HOME when using status/diff
# Dotfiles need to be manually added for them to show up
# $ dot add ~/.npmrc
dot config status.showUntrackedFiles no

unset files
unset GIT_URL
unset BACKUP_DIR

# Remove extra files
dot update-index --assume-unchanged "$HOME/LICENSE.md" "$HOME/README.md"
rm -f "$HOME/LICENSE.md" "$HOME/README.md"

# Make the bins executable
printf "\n➜ Making scripts and bins executable\n"
[ -d ~/.bin/ ] && chmod +x ~/.bin/*
[ -d ~/.dotfiles/scripts/ ] && chmod +x ~/.dotfiles/scripts/*

# Install fzf
if [ ! "$(command -v fzf)" ]; then
    printf "\n➜ Installing fzf from source\n\n"
    dot submodule update --init .dotfiles/vendor/fzf
    ~/.dotfiles/vendor/fzf/install --bin
fi

printf "\n✔ Initialization complete\n"
