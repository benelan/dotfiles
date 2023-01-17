#!/usr/bin/env bash
# shellcheck disable=2207

function __notify-send_completions() {
    local curr, prev
    curr=$(_get_cword)
    prev=$(_get_pword)
    case $prev in
        -u | --urgency)
            COMPREPLY=($(compgen -W "low normal critical" -- "$curr"))
            ;;
        *)
            COMPREPLY=($(compgen -W "-? --help -u --urgency -t --expire-time -a --app-name -i --icon -c --category -h --hint -v --version" -- "$curr"))
            ;;
    esac
}

complete -F __notify-send_completions notify-send
