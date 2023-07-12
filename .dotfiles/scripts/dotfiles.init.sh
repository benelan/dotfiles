#!/usr/bin/env sh
set -e

# Ben Elan's Dotfiles
#
# This script sets up my dotfiles in a bare git repo
# so everything is tracked and under version control.
# I used symlinks for a while but they are too messy.
# There are `dot` aliases to manage the bare repo in
# ~/.dotfiles/shell/aliases.sh

[ -d ~/.git ] &&
    printf "✖  The home directory is already under version control. Either:
  ➜  Use 'dot pull' to update the dotfiles.
  ➜  Remove %s/.git and run the script again to continue." "$HOME" &&
    exit 1

# any current, conflicting dotfiles will be moved here
BACKUP_DIR="$HOME/.dotfiles-backup"

# Don't use SSH to clone if there is no SSH key on the machine
# This is for when I spin up a new VM and don't want to login to GitHub
if find ~/.ssh -type f -name '*.pub' | wc -l | xargs test 0 -eq; then
    GIT_URL=https://github.com/benelan/dotfiles
else
    GIT_URL=git@github.com:benelan/dotfiles
fi

dot() {
    /usr/bin/git --git-dir="$HOME"/.git/ --work-tree="$HOME" "$@"
}

git clone --bare "$GIT_URL" "$HOME/.git"

if dot checkout >/dev/null 2>&1; then
    printf "\n✔  Checked out dotfiles\n"
else
    printf "\n➜  Backing up conflicting dotfiles to %s\n" "$BACKUP_DIR"
    # Get the list of files that need to be backed up
    files=$(dot checkout 2>&1 | grep -e "^\s")
    printf "%s\n" "$files"

    dirs=$(
        echo "$files" |
            # Remove everything after the last "/" from file paths
            awk 'BEGIN{FS=OFS="/"} {NF--} 1' |
            # Files in $HOME will end up being blank lines
            sed '/^[[:blank:]]*$/d'
    )
    # Using dirname is easier but won't work on OSX
    # dirs=$(echo "$files" | xargs dirname)

    # Create the directories in $BACKUP_DIR
    mkdir -p "$BACKUP_DIR"
    echo "$dirs" | xargs -I{} mkdir -p "$BACKUP_DIR/{}"
    # Move the conflicting files to the new directories
    echo "$files" | xargs -I{} mv {} "$BACKUP_DIR/{}"

    # Checkout the dotfiles now that there are no conflicts
    # To undo this script, move the files from $BACKUP_DIR to $HOME
    # $ mv ~/.dotfiles-backup/* ~/
    if ! dot checkout; then
        printf "\n✖  Unable to initialize the dotfiles\n"
        exit 1
    else
        printf "\n✔  Checked out dotfiles\n"
    fi
fi

# Prevents showing everything in $HOME when using status/diff
# Dotfiles need to be manually added for them to show up
# $ dot add ~/.npmrc
dot config status.showUntrackedFiles no

# Make sure fetching works correctly for all branches
dot config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

unset files
unset GIT_URL
unset BACKUP_DIR

# Make the bins and scripts executable
printf "\n➜  Making scripts and bins executable\n"
[ -d ~/.dotfiles/bin/ ] && chmod +x ~/.dotfiles/bin/*
[ -d ~/.dotfiles/scripts/ ] && chmod +x ~/.dotfiles/scripts/*

# Must install libs before they can be pwn'd
printf "\n➜  Installing git submodules\n\n"

cd && dot submodule update --init --recursive

# fzf install script
[ ! "$(command -v fzf)" ] &&
    ~/dev/lib/fzf/install \
        --bin --key-bindings --completion --no-update-rc

printf "\n✔  Initialization complete\n"
cd -
