#!/bin/sh

is-supported node || return

alias node-dev='export NODE_ENV=development'
alias node-prod='export NODE_ENV=production'

is-supported npm || return

# npm
alias ni='npm install'
alias nri="rm -rf node_modules && npm install"
alias nui='npm uninstall'
alias nst='npm start'
alias nlk='npm link'
alias nod='npm outdated'
alias nt='npm test'
alias nr='npm run'
alias nrb='npm run build'

# npx
alias npxncu='npx npm-check-updates'
alias npxplz='npx $(fc -ln -1)'

is-supported fzf && is-supported npm-fuzzy || return

alias nfz="npm-fuzzy"
alias nfzs="npm-fuzzy search"
alias nfzl="npm-fuzzy ls-versions"
alias nfzu="npm-fuzzy uninstall"

