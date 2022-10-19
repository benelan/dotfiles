#!/bin/sh


alias hosts='sudo $EDITOR /etc/hosts'

# searchable process list
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"

# Display drives and space in human readable format:
alias drives='df -h'

## pass options to free ##
alias meminfo='free -m -l -t'
 
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
 
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
 
## Get server cpu info ##
alias cpuinfo='lscpu'
 
## get GPU ram on desktop / laptop##
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

## shortcut  for iptables and pass it via sudo#
alias ipt='sudo /sbin/iptables'
 
# display all rules #
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist

# get web server headers #
alias header='curl -I'
 
# find out if remote server supports gzip / mod_deflate or not #
alias headerc='curl -I --compress'

# Prints each $PATH entry on a separate line.
alias path='echo -e ${PATH//:/\\n}'



# systemd shortcuts (Linux)
alias sc='systemctl'
alias scu='systemctl --user'
alias scdr='systemctl daemon-reload'
alias scdru='systemctl --user daemon-reload'
alias scr='systemctl restart'
alias scru='systemctl --user restart'
alias sce='systemctl stop'
alias sceu='systemctl --user stop'
alias scs='systemctl start'
alias scsu='systemctl --user start'



# Networking
# -----------------------------------------------------------------------------

alias speedtest="wget -O /dev/null http://speed.transip.nl/100mb.bin"

alias vpn="protonvpn-cli"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

alias myip="curl http://ipecho.net/plain; echo"

# Stop after sending count ECHO_REQUEST packets #
alias ping='ping -c 5'

# resume by default
alias wget='wget -c'
# Pings hostname(s) 30 times in quick succession.
alias fastping='ping -c 30 -i.2'

# Flushes the DNS cache.
alias flushdns='sudo /etc/init.d/dns-clean restart && echo DNS cache flushed'

# Gets all IP addresses.
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Gets local IP address.
alias localip="ip route get 1 | awk '{print \$NF;exit}'"

# Gets external IP address.
if command -v dig > /dev/null 2>&1; then
    alias publicip='dig +short myip.opendns.com @resolver1.opendns.com'
elif command -v curl > /dev/null 2>&1; then
    alias publicip='curl --silent --compressed --max-time 5 --url "https://ipinfo.io/ip"'
else
    alias publicip='wget -qO- --compression=auto --timeout=5 "https://ipinfo.io/ip"'
fi

# Sends HTTP requests.
command -v lwp-request > /dev/null 2>&1 && for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
    #shellcheck disable=SC2139
    alias $method="lwp-request -m '$method'"
done
unset method;
