#!/usr/bin/env bash

# Gruvbox colors from:
# https://github.com/morhetz/gruvbox-contrib/blob/master/color.table
{
    if [ "$(tput colors)" -ge 256 ] 2>/dev/null; then
        RESET=$(tput sgr0)
        BOLD=$(tput bold)
        UNDERLINE=$(tput smul)

        BLACK=$(tput setaf 235)
        RED=$(tput setaf 124)
        GREEN=$(tput setaf 106)
        YELLOW=$(tput setaf 172)
        BLUE=$(tput setaf 66)
        MAGENTA=$(tput setaf 132)
        CYAN=$(tput setaf 72)
        ORANGE=$(tput setaf 166)
        WHITE=$(tput setaf 246)
        GREY=$(tput setaf 245)

        RED_BRIGHT=$(tput setaf 167)
        GREEN_BRIGHT=$(tput setaf 142)
        YELLOW_BRIGHT=$(tput setaf 214)
        BLUE_BRIGHT=$(tput setaf 109)
        MAGENTA_BRIGHT=$(tput setaf 175)
        CYAN_BRIGHT=$(tput setaf 14)
        ORANGE_BRIGHT=$(tput setaf 209)
        WHITE_BRIGHT=$(tput setaf 223)

        export RED_BRIGHT GREEN_BRIGHT YELLOW_BRIGHT BLUE_BRIGHT \
            MAGENTA_BRIGHT CYAN_BRIGHT ORANGE_BRIGHT WHITE_BRIGHT
    else
        RESET="\e[0m"
        BOLD='\e[1m'
        UNDERLINE='e[4m'
        BLACK="\e[30m"
        RED="\e[31m"
        GREEN="\e[32m"
        YELLOW="\e[33m"
        BLUE="\e[34m"
        MAGENTA="\e[35m"
        CYAN="\e[36m"
        ORANGE="\e[33m"
        WHITE="\e[37m"
        GREY="\e[1;30m"
    fi
} >/dev/null 2>&1

export BLACK RED GREEN YELLOW BLUE MAGENTA CYAN ORANGE WHITE GREY \
    BOLD UNDERLINE RESET

export HISTSIZE=10000000
export HISTFILESIZE=$HISTSIZE

# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth:erasedups'

# Keep the times of the commands in history
export HISTTIMEFORMAT=''

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="$BOLD$GREEN"
export LESS_TERMCAP_me="$RESET"
export LESS_TERMCAP_us="$UNDERLINE$YELLOW"
export LESS_TERMCAP_ue="$RESET"
export LESS_TERMCAP_so="$MAGENTA"
export LESS_TERMCAP_se="$RESET"

# see `man gpg-agent`
GPG_TTY=$(tty)
export GPG_TTY

# generate LS_COLORS
[ -r ~/.dircolors ] && supports dircolors && eval "$(dircolors ~/.dircolors)"

# Use a more compact format for the `time` builtin's output
# TIMEFORMAT='real:%lR user:%lU sys:%lS'

stty -ixon

# Use vi editing mode instead of emacs
# set -o vi
# set +o emacs

# Disable <CTRL-D> which is used to exit the shell
set -o ignoreeof

# Automatically prepend `cd` to directory names
shopt -s autocd

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

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Pass an empty value if no matches are found when expanding a glob
shopt -s nullglob

# Use programmable completion, if available
shopt -s progcomp

# Warn me if I try to shift nonexistent values off an array
shopt -s shift_verbose

# Don't search $PATH to find files for the `source` builtin
shopt -u sourcepath

# These options only exist since Bash 4.0-alpha
if ((BASH_VERSINFO[0] >= 4)); then

    # Correct small errors in directory names during completion
    shopt -s dirspell

    # Allow double-star globs to match files and recursive paths
    shopt -s globstar

    # Warn me about stopped jobs when exiting
    # Available since 4.0, but only set it if >=4.1 due to bug:
    # <https://lists.gnu.org/archive/html/bug-bash/2009-02/msg00176.html>
    if ((BASH_VERSINFO[0] >= 5)) || ((BASH_VERSINFO[1] >= 1)); then
        shopt -s checkjobs
    fi

    # # Expand variables in directory completion. Only available since 4.3
    # if ((BASH_VERSINFO[0] >= 5)) || ((BASH_VERSINFO[1] >= 3)); then
    #     shopt -s direxpand
    # fi

    # toggle sudo at the beginning of the current or the
    # previous command by hitting the ESC key twice
    sudo-command-line() {
        [ ${#READLINE_LINE} -eq 0 ] && READLINE_LINE=$(fc -l -n -1 | xargs)
        if [[ $READLINE_LINE == sudo\ * ]]; then
            READLINE_LINE="${READLINE_LINE#sudo }"
        else
            READLINE_LINE="sudo $READLINE_LINE"
        fi
        READLINE_POINT=${#READLINE_LINE}
    }

    # Define shortcut keys: [Esc] [Esc]
    bind -x '"\e\e": sudo-command-line'

fi
