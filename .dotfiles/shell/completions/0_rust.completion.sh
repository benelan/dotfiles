#!/usr/bin/env bash

# rustup and cargo completion
if is-supported rustup && is-supported cargo; then
    eval "$(rustup completions bash)"
    eval "$(rustup completions bash cargo)"
fi
