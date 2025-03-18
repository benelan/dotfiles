---@see Types: https://github.com/benelan/wezterm-types
---@type Wezterm
local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then config = wezterm.config_builder() end

package.path = string.format("%s/?/lua/?.lua;%s", os.getenv("PERSONAL"), package.path)

-- require("tmux").statusline(config)
require("options").setup(config)
require("keymaps").setup(config)
require("git-mux").setup()

return config
