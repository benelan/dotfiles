#!/bin/sh

# Usage: indirect_expand PATH -> $PATH
indirect_expand() {
    env | sed -n "s/^$1=//p"
}

# Usage: pathremove /path/to/bin [PATH]
# Eg, to remove ~/bin from $PATH
#     pathremove ~/bin PATH
pathremove() {
    IFS=':'
    var=${2:-PATH}
    # Bash has ${!var}, but this is not portable.
    for dir in $(indirect_expand "$var"); do
        IFS=''
        if [ "$dir" != "$1" ]; then
            newpath=$newpath:$dir
        fi
    done
    export "$var"="${newpath#:}"
    unset newpath dir var IFS
}

# Usage: pathprepend /path/to/bin [PATH]
# Eg, to prepend ~/bin to $PATH
#     pathprepend ~/bin PATH
pathprepend() {
    # if the path is already in the variable,
    # remove it so we can move it to the front
    pathremove "$1" "$2"
    [ -d "${1}" ] || return
    var="${2:-PATH}"
    value=$(indirect_expand "$var")
    # shellcheck disable=2140
    export "${var}"="${1}${value:+:${value}}"
    unset var value
}

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

[ -d "$HOME/.dotfiles/bin" ] && pathappend "$HOME/.dotfiles/bin"
[ -d "$HOME/.local/bin" ] && pathappend "$HOME/.local/bin"
[ -d "$HOME/.cargo/bin" ] && pathappend "$HOME/.cargo/bin"
[ -d "$HOME/go/bin" ] && pathappend "$HOME/go/bin"
[ -d "$HOME/.bun/bin" ] && pathappend "$HOME/.bun/bin"
[ -d "$HOME/.volta/bin" ] && pathappend "$HOME/.volta/bin"
[ -d "$HOME/.luarocks/bin" ] && pathappend "$HOME/.luarocks/bin"

[ -d "$HOME/dev/personal/git-mux" ] &&
    pathappend "$HOME/dev/personal/git-mux"

[ -d "$HOME/dev/lib/fzf/bin" ] &&
    pathappend "$HOME/dev/lib/fzf/bin"

[ -d "$HOME/.local/share/nvim/mason/bin" ] &&
    pathprepend "$HOME/.local/share/nvim/mason/bin"

[ -d "/usr/local/go/bin" ] && pathappend "/usr/local/go/bin"

pathappend "/snap/bin"
pathappend "/usr/local/games"
pathappend "/usr/local/sbin"
pathappend "/usr/local/bin"
pathappend "/usr/games"
pathappend "/usr/sbin"
pathappend "/usr/bin"
pathappend "/sbin"
pathappend "/bin"
