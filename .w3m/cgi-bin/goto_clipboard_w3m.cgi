#!/usr/bin/env sh

# set open-url value to zero (aka empty url line)
printf "%s\r\n" "W3m-control: SET_OPTION default_url=0"

#GOTO url in clipboard in current page. If the clipboard has a
#"non url string/nothing" an blank page is shown.
printf "%s\r\n" "W3m-control: GOTO $(cat /tmp/jamin_clipboard.txt)"

#delete the buffer (element in history) created between the current page and
#the searched page by calling this script.
printf "%s\r\n" "W3m-control: DELETE_PREVBUF"

# set default open-url value to one (aka current url)
printf "%s\r\n" "W3m-control: SET_OPTION default_url=1"
