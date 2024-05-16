---@type Wezterm
local wezterm = require("wezterm") ---@diagnostic disable-line: assign-type-mismatch
local M = {}

M.setup = function()
  wezterm.on("update-status", function(window)
    local mode = window:active_key_table() or ""
    if mode ~= "" then mode = string.format("[%s]", mode:sub(1, 1):upper()) end

    window:set_left_status(string.format(" [%s] ", window:active_workspace()))
    window:set_right_status(string.format(" %s[%s] ", mode, wezterm.hostname()))
  end)
end

return M
