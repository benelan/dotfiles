#!/bin/sh

# Util functions                                                        {{{
# --------------------------------------------------------------------- {|}

# expand arg1 to an environment variable                      {{{
# Usage: indirect_expand PATH -> $PATH
indirect_expand() { env | sed -n "s/^$1=//p"; }

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# remove an entry from PATH                                   {{{
# Usage: path_remove /path/to/bin [PATH]
path_remove() {
    IFS=':'
    path_var=${2:-PATH}
    # Bash has ${!path_var}, but this is not portable.
    for path_dir in $(indirect_expand "${path_var}"); do
        IFS=''
        if [ "${path_dir}" != "${1}" ]; then
            new_path=${new_path}:${path_dir}
        fi
    done
    export "${path_var}"="${new_path#:}"
    unset new_path path_dir path_var IFS
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# prepend an entry to PATH                                    {{{
# Usage: path_prepend /path/to/bin [PATH]
path_prepend() {
    # if the path is already in the path_variable,
    # remove it so we can move it to the front
    path_remove "${1}" "${2}"
    [ -d "${1}" ] || return
    path_var="${2:-PATH}"
    path_value=$(indirect_expand "$path_var")
    export "${path_var}"="${1}${path_value:+:${path_value}}"
    unset path_var path_value
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# append an entry to PATH                                     {{{
# Usage: path_append /path/to/bin [PATH]
path_append() {
    path_remove "${1}" "${2}"
    [ -d "${1}" ] || return
    path_var=${2:-PATH}
    path_value=$(indirect_expand "$path_var")
    export "${path_var}"="${path_value:+${path_value}:}${1}"
    unset path_var path_value
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# print `path` usage info                                     {{{
path_help() {
    cat <<EOF
Append, prepend, or remove entries from \$PATH.

Usage:  path [(-a | -p | -r) <path>]...

Flags:
  -a    Add or move <path> to the front of \$PATH.
  -p    Add or move <path> to the end of \$PATH.
  -r    Remove <path> from \$PATH.
  -h    Show this message.

If no flags are given, print \$PATH.

EOF
    exit 1
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}

# --------------------------------------------------------------------- }}}
# Parse args                                                            {{{
# --------------------------------------------------------------------- {|}

# arg_is_flag() { case $1 in -*) true ;; *) false ;; esac }

path() {
    if [ -z "$1" ]; then
        echo "$PATH" | tr ':' '\n'
        return
    fi

    while getopts r:a:p:h opt; do
        case $opt in
            h) path_help ;;
            a) path_append "$OPTARG" ;;
            r) path_remove "$OPTARG" ;;
            p) path_prepend "$OPTARG" ;;
            *) path_help ;;
        esac
    done
}

# --------------------------------------------------------------------- }}}
# Set path                                                              {{{
# --------------------------------------------------------------------- {|}

path \
    -p "$HOME/.dotfiles/bin" \
    -p "$HOME/.local/share/nvim/mason/bin" \
    -a "$HOME/dev/personal/git-mux" \
    -a "$HOME/dev/lib/forgit/bin" \
    -a "$HOME/dev/lib/git-open" \
    -a "$HOME/dev/lib/fzf/bin" \
    -a "$HOME/dev/lib/fasd" \
    -a "$HOME/dev/lib/fff" \
    -a "$HOME/.luarocks/bin" \
    -a "$HOME/.nimble/bin" \
    -a "$HOME/.volta/bin" \
    -a "$HOME/.cargo/bin" \
    -a "$HOME/.bun/bin" \
    -a "$HOME/go/bin" \
    -a "$HOME/.local/bin" \
    -a "/snap/bin" \
    -a "/usr/local/go/bin" \
    -a "/usr/local/games" \
    -a "/usr/local/sbin" \
    -a "/usr/local/bin" \
    -a "/usr/games" \
    -a "/usr/sbin" \
    -a "/usr/bin" \
    -a "/sbin" \
    -a "/bin"

# --------------------------------------------------------------------- }}}
