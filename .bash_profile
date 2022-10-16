#!/bin/sh

# Load the shell dotfiles
for file in ~/.dotfiles/bash/.{paths,exports,aliases,functions,prompt}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;


# Load commandline completions
for file in ~/.dotfiles/bash/completions*; do
   [ -r "$file" ] && [ -f "$file" ] && source "$file";
done


# Load plugins
for file in ~/.dotfiles/bash/plugins*; do
   [ -r "$file" ] && [ -f "$file" ] && source "$file";
done
