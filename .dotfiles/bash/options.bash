#!/usr/bin/env bash

# Keep around 128K lines of history in file
HISTFILESIZE=131072

# Omit duplicates and commands that begin with a space from history.
HISTCONTROL='ignoreboth:erasedups'

# Keep the times of the commands in history
HISTTIMEFORMAT='%F %T  '

# Use a more compact format for the `time` builtin's output
# TIMEFORMAT='real:%lR user:%lU sys:%lS'

# If not set, make new shells get the history lines from all previous
# shells instead of the default "last window closed" history.

if ! printf "%s" "$PROMPT_COMMAND" | grep "history -a" &>/dev/null; then
  PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
fi

# Enable `vi` editing mode.
set -o vi

# Correct small errors in directory names given to the `cd` builtin
shopt -s cdspell
# Check that hashed commands still exist before running them
shopt -s checkhash
# Update LINES and COLUMNS after each command if necessary
shopt -s checkwinsize
# Put multi-line commands into one history entry
shopt -s cmdhist
# Include filenames with leading dots in pattern matching
shopt -s dotglob
# Enable extended globbing: !(foo), ?(bar|baz)...
shopt -s extglob
# Append history to $HISTFILE rather than overwriting it
shopt -s histappend
# If history expansion fails, reload the command to try again
shopt -s histreedit
# Load history expansion result as the next command, don't run them directly
shopt -s histverify
# Don't assume a word with a @ in it is a hostname
shopt -u hostcomplete
# Don't change newlines to semicolons in history
shopt -s lithist
# Don't try to tell me when my mail is read
shopt -u mailwarn
# Don't complete a Tab press on an empty line with every possible command
shopt -s no_empty_cmd_completion
# Use programmable completion, if available
shopt -s progcomp
# Warn me if I try to shift nonexistent values off an array
shopt -s shift_verbose
# Don't search $PATH to find files for the `source` builtin
shopt -u sourcepath
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob
# Autocorrect typos in path names when using `cd`
shopt -s cdspell
# Automatically prepend `cd` to directory names.
shopt -s autocd
# Do not autocomplete when accidentally pressing Tab on an empty line.
shopt -s no_empty_cmd_completion
# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Tab completion setup
bind '"\t":menu-complete'
bind "set show-all-if-ambiguous on"
bind "set completion-ignore-case on"
bind "set menu-complete-display-prefix on"

# These options only exist since Bash 4.0-alpha
if ((BASH_VERSINFO[0] >= 4)); then

  # Correct small errors in directory names during completion
  shopt -s dirspell
  # Allow double-star globs to match files and recursive paths
  shopt -s globstar

  # Warn me about stopped jobs when exiting
  # Available since 4.0, but only set it if >=4.1 due to bug:
  # <https://lists.gnu.org/archive/html/bug-bash/2009-02/msg00176.html>
  if ((BASH_VERSINFO[1] >= 1)); then
    shopt -s checkjobs
  fi

  # Expand variables in directory completion
  # Only available since 4.3
  if ((BASH_VERSINFO[1] >= 3)); then
    shopt -s direxpand
  fi
fi
