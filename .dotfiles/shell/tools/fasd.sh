#!/usr/bin/env bash
# shellcheck disable=1090

# -----------------------------------------------------------------------------
# fasd - https://github.com/clvv/fasd
# -----------------------------------------------------------------------------

alias za='fasd -a'
alias zs='fasd -si'
alias zsd='fasd -sid'
alias zsf='fasd -sif'
alias zd='fasd -d'
alias zf='fasd -f'
alias ze="f -e nvim"
alias zo="a -e xdg-open"
alias z='fasd_cd -d'
alias zz='fasd_cd -d -i'

# function to execute built-in cd
fasd_cd() {
    if [ $# -le 1 ]; then
        fasd "$@"
    else
        local _fasd_ret
        _fasd_ret="$(fasd -e 'printf %s' "$@")"
        [ -z "$_fasd_ret" ] && return
        [ -d "$_fasd_ret" ] && cd "$_fasd_ret" || printf '%s\n' "$_fasd_ret"
    fi
}
_fasd_prompt_func() {
    eval "fasd --proc $(fasd --sanitize "$(history 1 |
        sed "s/^[ ]*[0-9]*[ ]*//")")" >>"/dev/null" 2>&1
}

# add bash hook
case $PROMPT_COMMAND in
    *_fasd_prompt_func*) ;;
    *) PROMPT_COMMAND="_fasd_prompt_func;$PROMPT_COMMAND" ;;
esac

# bash command mode completion
_fasd_bash_cmd_complete() {
    # complete command after "-e"
    local cur=${COMP_WORDS[COMP_CWORD]}
    [[ ${COMP_WORDS[COMP_CWORD - 1]} == -*e ]] &&
        COMPREPLY=($(compgen -A command $cur)) && return
    # complete using default readline complete after "-A" or "-D"
    case ${COMP_WORDS[COMP_CWORD - 1]} in
        -A | -D) COMPREPLY=($(compgen -o default $cur)) && return ;;
    esac
    # get completion results using expanded aliases
    local RESULT
    RESULT=$(fasd --complete "$(alias -p $COMP_WORDS \
        2>>"/dev/null" | sed -n "\$s/^.*'\\(.*\\)'/\\1/p")
    ${COMP_LINE#* }" | while read -r line; do
        quote_readline "$line" 2>/dev/null ||
            printf %q "$line" 2>/dev/null &&
            printf \\n
    done)
    local IFS=$'\n'
    COMPREPLY=($RESULT)
}
_fasd_bash_hook_cmd_complete() {
    for cmd in "$@"; do
        complete -F _fasd_bash_cmd_complete "$cmd"
    done
}

# enable bash command mode completion
_fasd_bash_hook_cmd_complete fasd za zs zd zf zsd zsf z zz ze zo
