# pyright: reportUndefinedVariable=false
from os import getenv
from os.path import join

## General
# -----------------------------------------------------------------------------
config.load_autoconfig(False)
c.search.incremental = False
c.spellcheck.languages = ["en-US"]

terminal, editor = getenv("TERMINAL", "wezterm"), getenv("EDITOR", "nvim")
c.editor.command = [terminal, "-e", editor, "{file}", "+norm{line}G{column0}l"]

c.confirm_quit = ["downloads", "multiple-tabs"]
#c.auto_save.session = True

c.downloads.location.directory = "~/Downloads"
c.downloads.location.prompt = False
c.downloads.open_dispatcher = join(config.configdir, "userscripts/dispatcher")

c.tabs.last_close = "close"
c.tabs.select_on_remove = "last-used"
c.tabs.show = "multiple"

c.content.cookies.store = False
c.content.cookies.accept = "no-3rdparty"
#c.content.pdfjs = True
#c.content.javascript.enabled = False

## Search Engines
# -----------------------------------------------------------------------------
c.url.open_base_url = True

for bang in ["!ddg", "!duckduckgo"]:
    c.url.searchengines[bang] = 'https://duckduckgo.com/?q={quoted}'

## Colorscheme
# -----------------------------------------------------------------------------
c.colors.webpage.preferred_color_scheme = "dark"
config.source("colorschemes/gruvbox.py")

## Keybindings & Aliases
# -----------------------------------------------------------------------------
# config.bind("<Ctrl-e>", "scroll down")
# config.bind("<Ctrl-y>", "scroll up")
# config.bind("ao", "download-open")

c.aliases.update({
    "proxy": "spawn ssh proxy ;; set -t content.proxy socks5://localhost:8080",
    "noproxy": "spawn ssh -O exit proxy ;; config-unset -t content.proxy"
})

## Per-domain
# -----------------------------------------------------------------------------
with config.pattern("facebook.com") as p:
    p.content.blocking.enabled = True
