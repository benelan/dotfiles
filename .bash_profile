#!/bin/bash

# Load the shell dotfiles
for file in $HOME/.dotfiles/bash/.{functions,paths,exports,aliases,prompt}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;


# Load commandline completions
for file in ~/.dotfiles/bash/completions*; do
   [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;


# Load plugins
for file in ~/.dotfiles/bash/plugins*; do
   [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;


# Load other stuff
cargo="$HOME/.cargo/env";
[ -r "$cargo" ] && [ -f "$cargo" ] && source "$cargo";
unset cargo;