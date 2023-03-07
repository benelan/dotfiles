#!/bin/sh

alias hosts='sudo $EDITOR /etc/hosts'

# searchable process list
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"

# pass options to free
alias meminfo='free -m -l -t'

# get top processes eating memory
alias psmem='ps auxf | sort -nrk 4 | perl -e "print reverse <>"'
alias psmem10='ps auxf | sort -nrk 4 | head -10 | perl -e "print reverse <>"'

# get top processes eating cpu
alias pscpu='ps auxf | sort -nrk 3 | perl -e "print reverse <>"'
alias pscpu10='ps auxf | sort -nrk 3 | head -10 | perl -e "print reverse <>"'

alias ipt='sudo /sbin/iptables'

# display iptables rules
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist

# systemd shortcuts (Linux)
alias sc='systemctl'
alias scu='systemctl --user'
alias scdr='systemctl daemon-reload'
alias scudr='systemctl --user daemon-reload'
alias scr='systemctl restart'
alias scur='systemctl --user restart'
alias scq='systemctl stop'
alias scuq='systemctl --user stop'
alias scs='systemctl start'
alias scus='systemctl --user start'
alias sclt='systemctl list-units --type target --all'
alias scult='systemctl list-units --type target --all --user'

# Networking
# -----------------------------------------------------------------------------

alias speedtest="wget -O /dev/null http://speed.transip.nl/100mb.bin"

alias vpn="protonvpn-cli"

# Stop after sending count ECHO_REQUEST packets
alias ping='ping -c 5'

# resume by default
alias wget='wget -c'
# Pings hostname(s) 30 times in quick succession
alias fastping='ping -c 30 -i.2'

# Flushes the DNS cache
alias flushdns='sudo /etc/init.d/dns-clean restart && echo DNS cache flushed'

# Output all matched Git SHAs
alias match-git-sha="grep -oE '\b[0-9a-f]{5,40}\b'"

# Output all matched Git SHA ranges (e.g., 123456..654321)
alias match-git-range="grep -oE '[0-9a-fA-F]+\.\.\.?[0-9a-fA-F]+'"

# Output all matched IP addresses
alias match-ip="grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'"

# Output all matched URIs
alias match-uri="grep -P -o '(?:https?://|ftp://|news://|mailto:|file://|\bwww\.)[a-zA-Z0-9\-\@;\/?:&=%\$_.+!*\x27,~#]*(\([a-zA-Z0-9\-\@;\/?:&=%\$_.+!*\x27,~#]*\)|[a-zA-Z0-9\-\@;\/?:&=%\$_+*~])+'"

# Gets external IP address
if command -v dig >/dev/null 2>&1; then
    alias publicip='dig +short myip.opendns.com @resolver1.opendns.com'
elif command -v curl >/dev/null 2>&1; then
    alias publicip='curl --silent --compressed --max-time 5 --url "https://ipinfo.io/ip"'
else
    alias publicip='wget -qO- --compression=auto --timeout=5 "https://ipinfo.io/ip"'
fi

# Sends HTTP requests
command -v lwp-request >/dev/null 2>&1 && for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
    # shellcheck disable=2139
    alias $method="lwp-request -m '$method'"
done

# Docker
# -----------------------------------------------------------------------------

# display names of running containers
alias dockls="docker container ls | awk 'NR > 1 {print \$NF}'"
# delete every containers / images
alias dockR='docker rm $(docker ps -a -q) && docker rmi $(docker images -q)'
# stats on images
alias dockstats='docker stats $(docker ps -q)'
# list images installed
alias dockimg='docker images'
# prune everything
alias dockprune='docker system prune -a'
