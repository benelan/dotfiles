#!/bin/sh

# Util functions                                                        {{{
# --------------------------------------------------------------------- {|}

# expand arg1 to an environment variable                      {{{
# Usage: indirect_expand PATH -> $PATH
indirect_expand() {
    env | sed -n "s/^$1=//p"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}

# remove an entry from PATH                                   {{{
# Usage: pathremove /path/to/bin [PATH]
# Eg, to remove ~/bin from $PATH
#     pathremove ~/bin PATH
pathremove() {
    IFS=':'
    var=${2:-PATH}
    # Bash has ${!var}, but this is not portable.
    for dir in $(indirect_expand "${var}"); do
        IFS=''
        if [ "${dir}" != "${1}" ]; then
            newpath=${newpath}:${dir}
        fi
    done
    export "${var}"="${newpath#:}"
    unset newpath dir var IFS
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}

# prepend an entry to PATH                                    {{{
# Usage: pathprepend /path/to/bin [PATH]
# Eg, to prepend ~/bin to $PATH
#     pathprepend ~/bin PATH
pathprepend() {
    # if the path is already in the variable,
    # remove it so we can move it to the front
    pathremove "${1}" "${2}"
    [ -d "${1}" ] || return
    var="${2:-PATH}"
    value=$(indirect_expand "$var")
    # shellcheck disable=2140
    export "${var}"="${1}${value:+:${value}}"
    unset var value
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}

# append an entry to PATH                                     {{{
# Usage: pathappend /path/to/bin [PATH]
# Eg, to append ~/bin to $PATH
#     pathappend ~/bin PATH
pathappend() {
    pathremove "${1}" "${2}"
    [ -d "${1}" ] || return
    var=${2:-PATH}
    value=$(indirect_expand "$var")
    # shellcheck disable=2140
    export "${var}"="${value:+${value}:}${1}"
    unset var value
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }}}

# --------------------------------------------------------------------- }}}
# Set path                                                              {{{
# --------------------------------------------------------------------- {|}

pathprepend "$HOME/.dotfiles/bin"
pathprepend "$HOME/.local/share/nvim/mason/bin"
pathappend "$HOME/dev/personal/git-mux"
pathappend "$HOME/dev/lib/forgit/bin"
pathappend "$HOME/dev/lib/fzf/bin"
pathappend "$HOME/dev/lib/fasd"
pathappend "$HOME/dev/lib/fff"
pathappend "$HOME/dev/lib/git-open"
pathappend "$HOME/.local/bin"
pathappend "$HOME/.volta/bin"
pathappend "$HOME/.bun/bin"
pathappend "$HOME/.cargo/bin"
pathappend "$HOME/.luarocks/bin"
pathappend "$HOME/.nimble/bin"
pathappend "$HOME/go/bin"
pathappend "/usr/local/go/bin"
pathappend "/snap/bin"
pathappend "/usr/local/games"
pathappend "/usr/local/sbin"
pathappend "/usr/local/bin"
pathappend "/usr/games"
pathappend "/usr/sbin"
pathappend "/usr/bin"
pathappend "/sbin"
pathappend "/bin"

# --------------------------------------------------------------------- }}}
