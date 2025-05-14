local wezterm = require("wezterm") --[[@as Wezterm]]
local act = wezterm.action
local M = {}

---Setup Wezterm's tab bar to look like a tmux statusline.
---@param config Config
function M.statusline(config)
  config.tab_max_width = 70
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.show_new_tab_button_in_tab_bar = false
  config.hide_tab_bar_if_only_one_tab = false
  config.prefer_to_spawn_tabs = true

  wezterm.on("update-status", function(window)
    local mode = window:active_key_table() or ""
    if mode ~= "" then mode = string.format("[%s]", mode:sub(1, 1):upper()) end
    window:set_left_status(string.format(" [%s] ", window:active_workspace()))
    window:set_right_status(string.format(" %s[%s] ", mode, wezterm.hostname()))
  end)
end

---Get Wezterm's equivalent of the default tmux keybindings.
---```lua
---config.disable_default_key_bindings = true
---config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1500 }
---config.keys = {
--- table.unpack(require("tmux").default_keybinds()),
--- -- add your own keybinds here...
---}
---```
---@return Key[]
function M.default_keybinds()
  return {
    -- {
    --   key = config.leader.key,
    --   mods = "LEADER|" .. config.leader.mods,
    --   action = act.SendKey({ key = config.leader.key, mods = config.leader.mods }),
    -- },

    { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
    { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

    { key = ":", mods = "LEADER|SHIFT", action = act.ActivateCommandPalette },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "r", mods = "LEADER", action = act.ReloadConfiguration },

    -- Workspace management
    ---@diagnostic disable-next-line: assign-type-mismatch
    { key = "s", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
    { key = ")", mods = "LEADER|SHIFT", action = act.SwitchWorkspaceRelative(1) },
    { key = "(", mods = "LEADER|SHIFT", action = act.SwitchWorkspaceRelative(-1) },

    -- Tab management
    { key = "w", mods = "LEADER", action = act.ShowTabNavigator },
    { key = "l", mods = "LEADER", action = act.ActivateLastTab },
    { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "&", mods = "LEADER|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
    { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = "0", mods = "LEADER", action = act.ActivateTab(9) },
    { key = "9", mods = "LEADER", action = act.ActivateTab(8) },
    { key = "8", mods = "LEADER", action = act.ActivateTab(7) },
    { key = "7", mods = "LEADER", action = act.ActivateTab(6) },
    { key = "6", mods = "LEADER", action = act.ActivateTab(5) },
    { key = "5", mods = "LEADER", action = act.ActivateTab(4) },
    { key = "4", mods = "LEADER", action = act.ActivateTab(3) },
    { key = "3", mods = "LEADER", action = act.ActivateTab(2) },
    { key = "2", mods = "LEADER", action = act.ActivateTab(1) },
    { key = "1", mods = "LEADER", action = act.ActivateTab(0) },

    -- Pane management
    { key = "o", mods = "LEADER|CTRL", action = act.RotatePanes("CounterClockwise") },
    { key = "o", mods = "LEADER|ALT", action = act.RotatePanes("Clockwise") },
    { key = "o", mods = "LEADER", action = act.ActivatePaneDirection("Next") },
    { key = ";", mods = "LEADER", action = act.ActivatePaneDirection("Prev") },
    { key = "LeftArrow", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "RightArrow", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "UpArrow", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "DownArrow", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "LeftArrow", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "RightArrow", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "UpArrow", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "DownArrow", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "LeftArrow", mods = "LEADER|ALT", action = act.AdjustPaneSize({ "Left", 5 }) },
    { key = "RightArrow", mods = "LEADER|ALT", action = act.AdjustPaneSize({ "Right", 5 }) },
    { key = "UpArrow", mods = "LEADER|ALT", action = act.AdjustPaneSize({ "Up", 5 }) },
    { key = "DownArrow", mods = "LEADER|ALT", action = act.AdjustPaneSize({ "Down", 5 }) },
    {
      key = '"',
      mods = "LEADER|SHIFT",
      action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "%",
      mods = "LEADER|SHIFT",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    { key = "!", mods = "LEADER|SHIFT", action = act.PaneSelect({ mode = "MoveToNewTab" }) },
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },

    -- clipboard
    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
    { key = "]", mods = "LEADER", action = act.PasteFrom("PrimarySelection") },
  }
end

function M.apply_to_config(config)
  if wezterm.GLOBAL.multiplexer == "wezterm" then M.statusline(config) end
end

return M
