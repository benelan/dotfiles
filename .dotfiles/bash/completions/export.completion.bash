#!/usr/bin/env bash
complete -o nospace -S = -W '$(printenv | awk -F= "{print \$1}")' export
