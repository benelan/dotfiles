local wezterm = require "wezterm"
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

require("options").apply_config(config)
require("keymaps").apply_to_config(config)

require("right-status").setup()
-- require("gui-startup").setup()

return config
