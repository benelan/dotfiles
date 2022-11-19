#!/usr/bin/env bash

if _binary_exists gh; then
    # If gh already completed, stop
    _completion_exists gh && return
    eval "$(gh completion --shell=bash)"
fi
