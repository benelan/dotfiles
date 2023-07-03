#!/usr/bin/env perl

# usage:
# in url input: "youtube:rick roll"
# on the commandline: "w3m urban:blumpkin"
#
# installation:
#   $ sudo cp ./surfraw.cgi /usr/lib/w3m/cgi-bin/
#   $ sudo chmod +x /usr/lib/w3m/cgi-bin/surfraw.cgi
#
# create file if not already existing:
#   $ touch ~/.w3m/urimethodmap
#
# add lines in the following format
# (<elvi>: file:/cgi-bin/surfraw.cgi%s)
#
# for example:
#   $ echo 'google: file:/cgi-bin/surfraw.cgi?%s' >>~/.w3m/urimethodmap
#
# w3m needs to be restarted each time you make changes in the urimethodmap file
#
$search = $ENV{"QUERY_STRING"};
$search =~ tr/:/ /;
$url = `surfraw -p $search`;
print <<EOF;
w3m-control: GOTO $url
EOF
