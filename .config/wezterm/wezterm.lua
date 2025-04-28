---@see Types: https://github.com/benelan/wezterm-types
---@type Wezterm
local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then config = wezterm.config_builder() end

package.path = string.format("%s/?/lua/?.lua;%s", os.getenv("PERSONAL"), package.path)
wezterm.GLOBAL.multiplexer = os.getenv("GIT_MUX_MULTIPLEXER") or "wezterm"

require("options").setup(config)
require("keymaps").setup(config)
require("git-mux").setup()

if wezterm.GLOBAL.multiplexer == "wezterm" then require("tmux").statusline(config) end

return config
