#!/usr/bin/env bash

function is-supported() {
  if [ $# -eq 1 ]; then
    if eval "$1" > /dev/null 2>&1; then 
      exit 0
    else
      exit 1
    fi
  else
    if eval "$1" > /dev/null 2>&1; then
      echo -n "$2"
    else
      echo -n "$3"
    fi
  fi
}

# checks for existence of a command
function _command_exists() {
	# _param '1: command to check'
	# _param '2: (optional) log message to include when command not found'
	# _example '$ _command_exists ls && echo exists'

	# local msg="${2:-Command '$1' does not exist}"
	if type -t "$1" > /dev/null; then
		return 0
	else
		# echo "$msg"
		return 1
	fi
}

# checks for existence of a binary
function _binary_exists() {
	# _param '1: binary to check'
	# _param '2: (optional) log message to include when binary not found'
	# _example '$ _binary_exists ls && echo exists'

	# local msg="${2:-Binary '$1' does not exist}"
	if type -P "$1" > /dev/null; then
		return 0
	else
		# echo "$msg"
		return 1
	fi
}

# checks for existence of a completion
function _completion_exists() {
	# _param '1: command to check'
	# _param '2: (optional) log message to include when completion is found'
	# _example '$ _completion_exists gh && echo exists'

	# local msg="${2:-Completion for '$1' already exists}"
	if complete -p "$1" &> /dev/null; then
		# echo "$msg"
		return 0
	else
		return 1
	fi
}


# `start` with no arguments opens the current directory, otherwise opens the given
# location
function start() {
	if [ $# -eq 0 ]; then
		start .;
	else
		start "$@";
	fi;
}

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

duf() {
  du --max-depth="${1:-0}" -c | sort -r -n | awk '{split("K M G",v); s=1; while($1>1024){$1/=1024; s++} print int($1)v[s]"\t"$2}'
}



# Get gzipped file size
gz() {
  local ORIGSIZE=$(wc -c < "$1")
  local GZIPSIZE=$(gzip -c "$1" | wc -c)
  local RATIO=$(echo "$GZIPSIZE * 100/ $ORIGSIZE" | bc -l)
  local SAVED=$(echo "($ORIGSIZE - $GZIPSIZE) * 100/ $ORIGSIZE" | bc -l)
  printf "orig: %d bytes\ngzip: %d bytes\nsave: %2.0f%% (%2.0f%%)\n" "$ORIGSIZE" "$GZIPSIZE" "$SAVED" "$RATIO"
}

# Create a data URL from a file
dataurl() {
  local MIMETYPE=$(file --mime-type "$1" | cut -d ' ' -f2)
  if [[ $MIMETYPE == "text/*" ]]; then
    MIMETYPE="${MIMETYPE};charset=utf-8"
  fi
  echo "data:${MIMETYPE};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}


# Find real from shortened url
unshorten() {
  curl -sIL "$1" | sed -n 's/Location: *//p'
}


# Show 256 TERM colors
colors() {
  local X=$(tput op)
  local Y=$(printf %$((COLUMNS-6))s)
  for i in {0..256}; do
  o=00$i;
  echo -e "${o:${#o}-3:3}" $(tput setaf "$i";tput setab "$i")"${Y// /=}""$X";
  done
}

# toggle sudo at the beginning of the current or the previous command by hitting the ESC key twice
function sudo-command-line() {
  [[ ${#READLINE_LINE} -eq 0 ]] && READLINE_LINE=$(fc -l -n -1 | xargs)
  if [[ $READLINE_LINE == sudo\ * ]]; then
    READLINE_LINE="${READLINE_LINE#sudo }"
  else
    READLINE_LINE="sudo $READLINE_LINE"
  fi
  READLINE_POINT=${#READLINE_LINE}
}

# Define shortcut keys: [Esc] [Esc]

# Readline library requires bash version 4 or later
if [ "$BASH_VERSINFO" -ge 4 ]; then
  bind -x '"\e\e": sudo-command-line'
fi


	# prevent duplicate directories in your PATH variable
	# "pathmunge /path/to/dir" is equivalent to PATH=/path/to/dir:$PATH
	# "pathmunge /path/to/dir after" is equivalent to PATH=$PATH:/path/to/dir
function pathmunge() {
	if [[ -d "${1:-}" && ! $PATH =~ (^|:)"${1}"($|:) ]]; then
		if [[ "${2:-before}" == "after" ]]; then
			export PATH="$PATH:${1}"
		else
			export PATH="${1}:$PATH"
		fi
	fi
}


# add entry to ssh config
function add_ssh() {
  [[ $# -ne 3 ]] && echo "add_ssh host hostname user" && return 1
  [[ ! -d ~/.ssh ]] && mkdir -m 700 ~/.ssh
  [[ ! -e ~/.ssh/config ]] && touch ~/.ssh/config && chmod 600 ~/.ssh/config
  echo -en "\n\nHost $1\n  HostName $2\n  User $3\n  ServerAliveInterval 30\n  ServerAliveCountMax 120" >> ~/.ssh/config
}


# list hosts defined in ssh config
function sshlist() {
  awk '$1 ~ /Host$/ {for (i=2; i<=NF; i++) print $i}' ~/.ssh/config
}

# add all ssh private keys to agent
function ssh-add-all() {
  grep -slR "PRIVATE" ~/.ssh | xargs ssh-add
}


# display all ip addresses for this host
function ips() {
	if _command_exists ifconfig; then
		ifconfig | awk '/inet /{ gsub(/addr:/, ""); print $2 }'
	elif _command_exists ip; then
		ip addr | grep -oP 'inet \K[\d.]+'
	else
		echo "You don't have ifconfig or ip command installed!"
	fi
}


# checks whether a website is down for you, or everybody
function down4me() {
	# param '1: website url'
	# example '$ down4me http://www.google.com
	curl -Ls "http://downforeveryoneorjustme.com/$1" | sed '/just you/!d;s/<[^>]*>//g'
}

# displays your ip address, as seen by the Internet
function myip() {
	list=("http://myip.dnsomatic.com/" "http://checkip.dyndns.com/" "http://checkip.dyndns.org/")
	for url in "${list[@]}"; do
		if res="$(curl -fs "${url}")"; then
			break
		fi
	done
	res="$(echo "$res" | grep -Eo '[0-9\.]+')"
	echo -e "Your public IP is: ${echo_bold_green-} $res ${echo_normal-}"
}


# generates random password from dictionary words, w optional integer length
function passgen() {
	local -i i length=${1:-4}
	local pass
	# shellcheck disable=SC2034
	pass="$(for i in $(eval "echo {1..$length}"); do pickfrom /usr/share/dict/words; done)"
	echo "With spaces (easier to memorize): ${pass//$'\n'/ }"
	echo "Without spaces (easier to brute force): ${pass//$'\n'/}"
}


# preview markdown file in a browser
if _command_exists markdown && _command_exists browser; then
	function pmdown() {
		# param '1: markdown file'
		# example '$ pmdown README.md'
		markdown "${1?}" | browser
	}
fi


# runs argument in background
function quiet() {
	nohup "$@" &> /dev/null < /dev/null &
}

# disk usage per directory, in Mac OS X and Linux
function usage() {
	case $OSTYPE in
		*'darwin'*)
			du -hd 1 "$@"
			;;
		*'linux'*)
			du -h --max-depth=1 "$@"
			;;
	esac
}


# back up file with timestamp
function buf() {
	# param 'filename'
	local filename="${1?}" filetime
	filetime=$(date +%Y%m%d_%H%M%S)
	cp -a "${filename}" "${filename}_${filetime}"
}

# move files to hidden folder in tmp, that gets cleared on each reboot
if ! _command_exists del; then
	function del() {
		# param: file or folder to be deleted
		# example: del ./file.txt
		mkdir -p /tmp/.trash && mv "$@" /tmp/.trash
	}
fi


# make one or more directories and cd into the last one
function mcd() {
  mkdir -p -- "$@" && cd -- "${!#}" || return
}

# Lists drive mounts.
function mnt() {
  mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | grep -E ^/dev/ | sort
}

# Git
#---------------------------------------------------------------------------------

# git checkout (find)
# makes sure everything is up to date with master
# you can checkout using any word in the commit
# usage (to checkout benelan/2807-consistent-slot-doc): gcof slot
function gcof() {
  git checkout "$(gbdefault)" && git pull && git branch | grep "$1" | xargs git checkout && git merge "$(gbdefault)"
}

# git checkout (new)
# creates a new branch starting with my username
# usage (to create branch benelan/2807-slots): gcon 2807-slots
function gcon() {
  git checkout "$(gbdefault)" && git pull && git checkout -b benelan/"$1" 2> /dev/null || git checkout benelan/"$1" && git merge "$(gbdefault)"
}

# git-extras-big-blobs
# human readably list the blobs by size, excluding HEAD
function gxbigblobs() {
  git rev-list --objects --all |
  git cat-file --batch-check="%(objecttype) %(objectname) %(objectsize) %(rest)" |
  sed -n "s/^blob //p" |
  sort --numeric-sort --key=2 |
  cut -c 1-12,41- |
  $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest |
  grep -vF --file=<(git ls-tree -r HEAD | awk "{print $3}")
}



# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Search history.

h() {
    #           ┌─ Enable colors for pipe.
    #           │  ("--color=auto" enables colors only
   #           │   if the output is in the terminal.)
    grep --color=always "$*" "$HISTFILE" \
        | less --no-init --raw-control-chars
          #    │         └─ Display ANSI color escape sequences in raw form.
          #    └─ Don't clear the screen after quitting less.
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Search for text within the current directory.

s() {
    grep --color=always "$*" \
         --exclude-dir=".git" \
         --exclude-dir="node_modules" \
         --ignore-case \
         --recursive \
         . \
        | less --no-init --raw-control-chars
          #    │         └─ Display ANSI color escape sequences in raw form.
          #    └─ Don't clear the screen after quitting less.
}

# Arrays
#---------------------------------------------------------------------------------


# Array mapper. Calls map_fn for each item ($1) and index ($2) in array, and
# prints whatever map_fn prints. If map_fn is omitted, all input array items
# are printed.
# Usage: array_map array_name [map_fn]
function array_map() {
  local __i__ __val__ __arr__=$1; shift
  for __i__ in $(eval echo "\${!$__arr__[@]}"); do
    __val__="$(eval echo "\"\${$__arr__[__i__]}\"")"
    if [[ "$1" ]]; then
      "$@" "$__val__" "$__i__"
    else
      echo "$__val__"
    fi
  done
}

# Print bash array in the format "i <val>" (one per line) for debugging.
function array_print() { array_map "$1" __array_print; }
function __array_print() { echo "$2 <$1>"; }

# Array filter. Calls filter_fn for each item ($1) and index ($2) in array_name
# array, and prints all values for which filter_fn returns a non-zero exit code
# to stdout. If filter_fn is omitted, input array items that are empty strings
# will be removed.
# Usage: array_filter array_name [filter_fn]
# Eg. mapfile filtered_arr < <(array_filter source_arr)
function array_filter() { __array_filter 1 "$@"; }
# Works like array_filter, but outputs array indices instead of array items.
function array_filter_i() { __array_filter 0 "$@"; }
# The core function. Wheeeee.
function __array_filter() {
  local __i__ __val__ __mode__ __arr__
  __mode__=$1; shift; __arr__=$1; shift
  for __i__ in $(eval echo "\${!$__arr__[@]}"); do
    __val__="$(eval echo "\${$__arr__[__i__]}")"
    if [[ "$1" ]]; then
      "$@" "$__val__" "$__i__" >/dev/null
    else
      [[ "$__val__" ]]
    fi
    if [[ "$?" == 0 ]]; then
      if [[ $__mode__ == 1 ]]; then
        eval echo "\"\${$__arr__[__i__]}\""
      else
        echo "$__i__"
      fi
    fi
  done
}

# Array join. Joins array ($1) items on string ($2).
function array_join() { __array_join 1 "$@"; }
# Works like array_join, but removes empty items first.
function array_join_filter() { __array_join 0 "$@"; }

function __array_join() {
  local __i__ __val__ __out__ __init__ __mode__ __arr__
  __mode__=$1; shift; __arr__=$1; shift
  for __i__ in $(eval echo "\${!$__arr__[@]}"); do
    __val__="$(eval echo "\"\${$__arr__[__i__]}\"")"
    if [[ $__mode__ == 1 || "$__val__" ]]; then
      [[ "$__init__" ]] && __out__="$__out__$@"
      __out__="$__out__$__val__"
      __init__=1
    fi
  done
  [[ "$__out__" ]] && echo "$__out__"
}

# Do something n times.
function n_times() {
  local max=$1; shift
  local i=0; while [[ $i -lt $max ]]; do "$@"; i=$((i+1)); done
}

# Do something n times, passing along the array index.
function n_times_i() {
  local max=$1; shift
  local i=0; while [[ $i -lt $max ]]; do "$@" "$i"; i=$((i+1)); done
}

# Given strings containing space-delimited words A and B, "setdiff A B" will
# return all words in A that do not exist in B. Arrays in bash are insane
# (and not in a good way).
# From http://stackoverflow.com/a/1617303/142339
function setdiff() {
  local debug skip a b
  if [[ "$1" == 1 ]]; then debug=1; shift; fi
  if [[ "$1" ]]; then
    local setdiff_new setdiff_cur setdiff_out
    setdiff_new="($1)"; setdiff_cur="($2)"
  fi
  setdiff_out=()
  for a in "${setdiff_new[@]}"; do
    skip=
    for b in "${setdiff_cur[@]}"; do
      [[ "$a" == "$b" ]] && skip=1 && break
    done
    [[ "$skip" ]] || setdiff_out=("${setdiff_out[@]}" "$a")
  done
  [[ "$debug" ]] && for a in setdiff_new setdiff_cur setdiff_out; do
    echo "$a ($(eval echo "\${#$a[*]}")) $(eval echo "\${$a[*]}")" 1>&2
  done
  [[ "$1" ]] && echo "${setdiff_out[@]}"
}

# This function searches an array for an exact match against the term passed
# as the first argument to the function. This function exits as soon as
# a match is found.
#
# Returns:
#   0 when a match is found, otherwise 1.
#
# Examples:
#   $ declare -a fruits=(apple orange pear mandarin)
#
#   $ _array-contains-element apple "@{fruits[@]}" && echo 'contains apple'
#   contains apple
#
#   $ if _array-contains-element pear "${fruits[@]}"; then
#       echo "contains pear!"
#     fi
#   contains pear!
#
#
function _array-contains-element() {
	local e element="${1?}"
	shift
	for e in "$@"; do
		[[ "$e" == "${element}" ]] && return 0
	done
	return 1
}

# Dedupe an array (without embedded newlines).
function _array-dedup() {
	printf '%s\n' "$@" | sort -u
}