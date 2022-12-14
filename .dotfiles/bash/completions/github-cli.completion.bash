#!/usr/bin/env bash

if is-supported gh; then
    # If gh already completed, stop
    if complete -p gh &>/dev/null; then
        eval "$(gh completion --shell=bash)"
    fi
fi
