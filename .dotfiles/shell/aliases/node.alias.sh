#!/usr/bin/env sh

is-supported node || return

alias node-dev="export NODE_ENV=development"
alias node-prod="export NODE_ENV=production"

is-supported npm || return

# npm
alias ni="npm install"
alias nrmi="rm -rf node_modules && npm install"
alias nui="npm uninstall"
alias nst="npm start"
alias nlk="npm link"
alias nt="npm test"
alias nr="npm run"
alias nrb="npm run build"

# npx
alias ncu="npx npm-check-updates"
alias npxplz='npx $(fc -ln -1)'

# aliases using other tools
is-supported fzf || return
is-supported jq &&
    alias fnr='npm run "$(jq -r ".scripts | keys[] " <package.json | sort | fzf)"'
is-supported npm-fuzzy &&
    alias nfz="npm-fuzzy"
