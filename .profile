#!/bin/sh

# Load the commandline aliases
for file in ~/.dotfiles/bash/aliases/*; do
	[ -r "$file" ] && [ -f "$file" ] && . "$file";
done;
unset file;