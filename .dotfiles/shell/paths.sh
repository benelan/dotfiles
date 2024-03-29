#!/bin/sh

# Util functions                                                        {{{
# --------------------------------------------------------------------- {|}

# expand arg1 to an environment variable                      {{{
# Usage: _expand_var PATH -> $PATH
_expand_var() { env | sed -n "s/^$1=//p"; }

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# remove an entry from PATH                                   {{{
# Usage: path_remove /path/to/bin [PATH]
_pathremove() {
    IFS=':'
    path_var=${2:-PATH}
    # Bash has ${!path_var}, but this is not portable.
    for path_dir in $(_expand_var "${path_var}"); do
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
_pathprepend() {
    # if the path is already in the path_variable,
    # remove it so we can move it to the front
    _pathremove "${1}" "${2}"
    [ -d "${1}" ] || return
    path_var="${2:-PATH}"
    path_value=$(_expand_var "$path_var")
    export "${path_var}"="${1}${path_value:+:${path_value}}"
    unset path_var path_value
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}
# append an entry to PATH                                     {{{
# Usage: path_append /path/to/bin [PATH]
_pathappend() {
    _pathremove "${1}" "${2}"
    [ -d "${1}" ] || return
    path_var=${2:-PATH}
    path_value=$(_expand_var "$path_var")
    export "${path_var}"="${path_value:+${path_value}:}${1}"
    unset path_var path_value
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}

# --------------------------------------------------------------------- }}}
# Parse args                                                            {{{
# --------------------------------------------------------------------- {|}

# arg_is_flag() { case $1 in -*) true ;; *) false ;; esac }

path() {
    if [ -z "$1" ]; then
        echo "$PATH" | tr ':' '\n'
        return 0
    fi

    case $1 in
        a | -a | append | --append) _pathappend "$2" "$3" ;;
        r | -r | remove | --remove) _pathremove "$2" "$3" ;;
        p | -p | prepend | --prepend) _pathprepend "$2" "$3" ;;
        *)
            printf "Usage: path [append|prepend|remove] [PATH]" >&2
            return 1
            ;;
    esac
}

# --------------------------------------------------------------------- }}}
# Set path                                                              {{{
# --------------------------------------------------------------------- {|}

path -p "$HOME/.dotfiles/bin"
path -p "$HOME/.local/share/nvim/mason/bin"
path -a "$HOME/dev/personal/git-mux/bin"
path -a "$HOME/dev/lib/fzf/bin"
path -a "$HOME/.luarocks/bin"
path -a "$HOME/.nimble/bin"
path -a "$HOME/.volta/bin"
path -a "$HOME/.cargo/bin"
path -a "$HOME/.bun/bin"
path -a "$HOME/go/bin"
path -a "$HOME/.local/bin"
path -a "/snap/bin"
path -a "/usr/local/go/bin"
path -a "/usr/local/games"
path -a "/usr/local/sbin"
path -a "/usr/local/bin"
path -a "/usr/games"
path -a "/usr/sbin"
path -a "/usr/bin"
path -a "/sbin"
path -a "/bin"

# --------------------------------------------------------------------- }}}
