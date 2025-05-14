---@see Types: https://github.com/benelan/wezterm-types
---@type Wezterm
local wezterm = require("wezterm")
local config = wezterm.config_builder and wezterm.config_builder() or {}

local git_mux = wezterm.plugin.require("https://github.com/benelan/git-mux")
wezterm.GLOBAL.multiplexer = os.getenv("GIT_MUX_MULTIPLEXER") or "wezterm"

local has_local_pre, local_pre = pcall(require, "local_pre")
local has_local_post, local_post = pcall(require, "local_post")

if has_local_pre then local_pre.apply_to_config(config) end

require("options").apply_to_config(config)
require("keymaps").apply_to_config(config)
require("tmux").apply_to_config(config)
git_mux.apply_to_config(config)

if has_local_post then local_post.apply_to_config(config) end

return config
