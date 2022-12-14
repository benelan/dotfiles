#!/usr/bin/env bash

# cargo (Rust package manager) completion
if is-supported rustup && is-supported cargo; then
    eval "$(rustup completions bash cargo)"
fi
