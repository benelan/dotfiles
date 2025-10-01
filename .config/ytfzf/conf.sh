# shellcheck disable=2034
# Documentation: https://github.com/pystardust/ytfzf/wiki/ytfzf(5)
# Example: https://github.com/pystardust/ytfzf/blob/master/docs/conf.sh

is_sort=1
is_loop=1
async_thumbnails=1
thumbnail_viewer="mpv"
fzf_preview_side="right"
next_page_action_shortcut="alt-p"

if curl -sfw "%{exitcode}" "http://media:3333" >/dev/null 2>&1; then
    invidious_instance=http://media:3333
fi

external_menu() { rofi -dmenu -width 1500 -p "$1"; }
