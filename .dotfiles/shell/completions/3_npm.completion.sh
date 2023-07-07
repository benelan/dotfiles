#!/usr/bin/env bash

if is-supported npm; then
    eval "$(npm completion)"
fi
