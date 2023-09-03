#!/usr/bin/env sh
set -e

# Ben Elan's Dotfiles
#
# This script sets up my dotfiles in a bare git repo so everything is tracked
# and under version control. I used symlinks for a while but they are too messy.
# Use the `dot` command as a replacement for `git` when working on the dotfiles.
# Aliases in ~/.config/git/config work with `dot` too. For example, `dot cm` is:
# $ git --git-dir="$HOME"/.git/ --work-tree="$HOME" commit -m

if [ -d ~/.git ]; then
    printf "%s\n  %s\n  %s" \
        "Error: the home directory is already under version control. Either" \
        "1. Use 'dot pull' to update the dotfiles." \
        "2. Remove ~/.git and run the script again to continue." >&2
    exit 1
fi

# any current, conflicting dotfiles will be moved here
DOTFILES_BACKUP_DIR="$HOME/.dotfiles-backup"

# Don't use SSH to clone if there is no SSH key on the machine
# This is for when I spin up a new VM and don't want to login to GitHub
if find ~/.ssh -type f -name '*.pub' | wc -l | xargs test 0 -eq; then
    GIT_URL=https://github.com/benelan/dotfiles
else
    GIT_URL=git@github.com:benelan/dotfiles
fi

git clone --bare "$GIT_URL" "$HOME/.git"

dot() {
    /usr/bin/git --git-dir="$HOME"/.git/ --work-tree="$HOME" "$@"
}

# Make sure fetching works correctly for all branches
dot config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

# Prevents showing everything in $HOME when using status/diff.
# Dotfiles need to be manually added for them to show up, e.g.
# $ dot add ~/.npmrc
dot config status.showUntrackedFiles no

dot branch --set-upstream-to=origin/master master

if dot checkout >/dev/null 2>&1; then
    printf "\nChecked out dotfiles\n" >&2
else
    printf "\n> Backing up conflicting dotfiles to %s\n" "$DOTFILES_BACKUP_DIR" >&2
    # Get the list of files that need to be backed up
    files=$(dot checkout 2>&1 | grep -e "^\s")
    printf "%s\n" "$files" >&2

    dirs=$(
        echo "$files" |
            # Remove everything after the last "/" from file paths
            awk 'BEGIN{FS=OFS="/"} {NF--} 1' |
            # Files in $HOME will end up being blank lines
            sed '/^[[:blank:]]*$/d'
    )
    # Using dirname is easier but won't work on OSX
    # dirs=$(echo "$files" | xargs dirname)

    # Create the directories in $DOTFILES_BACKUP_DIR
    mkdir -p "$DOTFILES_BACKUP_DIR"
    echo "$dirs" | xargs -I{} mkdir -p "$DOTFILES_BACKUP_DIR/{}"

    # Move the conflicting files to the new directories
    echo "$files" | xargs -I{} mv {} "$DOTFILES_BACKUP_DIR/{}"

    # Checkout the dotfiles now that there are no conflicts.
    # Move the files from $DOTFILES_BACKUP_DIR to $HOME to undo the script
    # $ mv ~/.dotfiles-backup/* ~/
    if ! dot checkout; then
        printf "\nError: unable to initialize the dotfiles\n" >&2
        exit 1
    else
        printf "\nChecked out dotfiles\n" >&2
    fi
fi

unset files
unset GIT_URL
unset DOTFILES_BACKUP_DIR

# Make the bins and scripts executable
printf "\n> Making scripts and bins executable\n" >&2
[ -d ~/.dotfiles/bin/ ] && chmod +x ~/.dotfiles/bin/*
[ -d ~/.dotfiles/scripts/ ] && chmod +x ~/.dotfiles/scripts/*

if [ -d /usr/share/bash-completion/completions ]; then
    printf "\n>  Copying completion scripts to system\n\n" >&2

    sudo cp ~/.dotfiles/shell/completions/0_tmux.completion.sh \
        /usr/share/bash-completion/completions/tmux

    sudo cp ~/.dotfiles/shell/completions/0_fasd.completion.sh \
        /usr/share/bash-completion/completions/fasd

    sudo cp ~/.dotfiles/shell/completions/0_npm.completion.sh \
        /usr/share/bash-completion/completions/npm
fi

# Must install libs before they can be pwn'd
printf "\n> Installing git submodules\n\n" >&2
cd && dot submodule update --init --recursive

# fzf install script
[ ! "$(command -v fzf)" ] &&
    ~/dev/lib/fzf/install \
        --bin --key-bindings --completion --no-update-rc

printf "\n+ Initialization complete!\n" >&2
cd -
