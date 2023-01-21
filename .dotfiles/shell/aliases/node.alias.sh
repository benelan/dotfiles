#!/bin/sh

is-supported node || return

alias node-dev='export NODE_ENV=development'
alias node-prod='export NODE_ENV=production'

is-supported npm || return

# npm
alias ni='npm install'
alias nri="rm -rf node_modules && npm install"
alias nu='npm uninstall'
alias nst='npm start'
alias nlk='npm link'
alias nod='npm outdated'
alias nr='npm run'
alias nt='npm test'

# npx
alias npxplz='npx $(fc -ln -1)'
alias nxn='npx --no-install '
alias nxni='npx --no-install --ignore-existing '
alias npxncu='npx npm-check-updates'

is-supported fzf && is-supported npm-fuzzy || return

alias nfz="npm-fuzzy"
alias nfzs="npm-fuzzy search"
alias nfzl="npm-fuzzy ls-versions"
alias nfzu="npm-fuzzy uninstall"
