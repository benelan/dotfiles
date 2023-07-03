#!/usr/bin/env sh

### Description     : turn all w3m plain text urls to real clickable urls (aka auto mark url).
###                 : this will mess up the numbers order in hinting mode.
### Depends On      : w3m coreutils
### Source          : https://github.com/felipesaa/A-vim-like-firefox-like-configuration-for-w3m
### References      : http://w3m.sourceforge.net/MANUAL#LocalCGI
### Install         : put this script in /usr/lib/w3m/cgi-bin/

# newsboat:
#  $ vim ~/.newsboat/config
#  $ pager "w3m ~/.w3m/cgi-bin/treat_as_url.cgi %f"
#
# w3m auto mark url in regular files:
#  $ w3m ~/.w3m/cgi-bin/treat_as_url.cgi filename.txt
#
# w3m auto mark url from websites:
#  $ w3m ~/.w3m/cgi-bin/treat_as_url.cgi <url>
#
# alias for ~/.bashrc or ~/.zshrc:
#   $ [ -f "~/.w3m/cgi-bin/treat_as_url.cgi" ] && alias w3m="w3m ~/.w3m/cgi-bin/treat_as_url.cgi"

printf "%s\r\n" "W3m-control: PREV";
printf "%s\r\n" "W3m-control: MARK_URL"
