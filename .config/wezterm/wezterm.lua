---@type Wezterm
local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then config = wezterm.config_builder() end

package.path = string.format("%s/?/lua/?.lua;%s", os.getenv("PERSONAL"), package.path)

require("options").apply_config(config)
require("keymaps").apply_to_config(config)

require("events").setup()
require("git-mux").setup()

return config
