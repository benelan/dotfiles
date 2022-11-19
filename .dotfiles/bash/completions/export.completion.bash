#!/usr/bin/env bash
# shellcheck disable=2016
complete -o nospace -S = -W '$(printenv | awk -F= "{print \$1}")' export
