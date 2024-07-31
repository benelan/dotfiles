# shellcheck disable=2034
# Documentation: https://github.com/pystardust/ytfzf/wiki/ytfzf(5)
# Example: https://github.com/pystardust/ytfzf/blob/master/docs/conf.sh

is_sort=1
is_loop=1
fzf_preview_side="right"
next_page_action_shortcut="alt-p"
thumbnail_viewer="mpv"
async_thumbnails=1

external_menu() { rofi -dmenu -width 1500 -p "$1"; }
