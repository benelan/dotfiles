#!/bin/bash

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Load the shell dotfiles - order matters!
for file in ~/.dotfiles/sh/{paths,exports}.sh; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Load the commandline aliases
for file in ~/.dotfiles/sh/aliases/*; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

for file in ~/.dotfiles/bash/.{functions,prompt}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Load commandline completions
for file in ~/.dotfiles/bash/completions/*; do
   [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;


# Load plugins
for file in ~/.dotfiles/bash/plugins/*; do
   [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;


# Load other stuff
cargo=~/.cargo/env;
[ -r "$cargo" ] && [ -f "$cargo" ] && source "$cargo";
unset cargo;
