local wezterm = require("wezterm") --[[@as Wezterm]]
local utils = require("utils")
local git_mux = require("git-mux")

local act = wezterm.action
local M = {}

function M.setup(config)
  config.disable_default_key_bindings = true
  config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1500 }

  config.keys = {
    {
      key = "p",
      mods = "LEADER|CTRL",
      action = wezterm.action_callback(git_mux.project),
    },
    -- {
    --   key = "p",
    --   mods = "LEADER|CTRL",
    --   action = wezterm.action_callback(function(win)
    --     local _, new_pane = win:mux_window():spawn_tab({})
    --     wezterm.GLOBAL.git_mux_pane_id = new_pane:pane_id()
    --     new_pane:send_text("git-mux project\n")
    --   end),
    -- },
    {
      key = "t",
      mods = "LEADER|CTRL",
      action = act.SpawnCommandInNewTab({ args = { "git-mux", "task" } }),
    },
    {
      key = "h",
      mods = "LEADER|CTRL",
      action = wezterm.action_callback(
        function(window, pane) git_mux.project(window, pane, { path = wezterm.home_dir }) end
      ),
    },
    {
      key = "n",
      mods = "LEADER|CTRL",
      action = wezterm.action_callback(
        function(window, pane) git_mux.project(window, pane, { path = os.getenv("NOTES") }) end
      ),
    },
    {
      key = "c",
      mods = "LEADER|CTRL",
      action = wezterm.action_callback(
        function(window, pane) git_mux.project(window, pane, { path = os.getenv("CALCITE") }) end
      ),
    },

    -- Workspace management
    { key = ")", mods = "LEADER|SHIFT", action = act.SwitchWorkspaceRelative(1) },
    { key = "(", mods = "LEADER|SHIFT", action = act.SwitchWorkspaceRelative(-1) },

    ---@diagnostic disable-next-line: assign-type-mismatch
    { key = "s", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },

    {
      key = "Tab",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, pane)
        if wezterm.GLOBAL.git_mux_previous_project then
          local current = wezterm.mux.get_active_workspace()
          window:perform_action(
            act.SwitchToWorkspace({ name = wezterm.GLOBAL.git_mux_previous_project }),
            pane
          )
          wezterm.GLOBAL.git_mux_previous_project = current
        end
      end),
    },

    {
      key = "S",
      mods = "LEADER|SHIFT",
      -- https://wezfurlong.org/wezterm/config/lua/keyassignment/PromptInputLine.html
      action = act.PromptInputLine({
        description = wezterm.format({
          { Attribute = { Intensity = "Bold" } },
          { Text = "Enter name for new workspace" },
        }),
        action = wezterm.action_callback(function(window, pane, line)
          -- line will be `nil` if they hit escape without entering anything
          -- An empty string if they just hit enter
          -- Or the actual line of text they wrote
          if line then window:perform_action(act.SwitchToWorkspace({ name = line }), pane) end
        end),
      }),
    },

    -- Tab management
    { key = "c", mods = "CTRL|ALT", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "q", mods = "CTRL|ALT", action = act.CloseCurrentTab({ confirm = true }) },
    { key = "n", mods = "CTRL|ALT", action = act.ActivateTabRelative(1) },
    { key = "p", mods = "CTRL|ALT", action = act.ActivateTabRelative(-1) },

    { key = "w", mods = "LEADER", action = act.ShowTabNavigator },
    { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = ">", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },
    { key = "<", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
    { key = "q", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
    { key = "Backspace", mods = "LEADER", action = act.ActivateLastTab },

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
    { key = "x", mods = "CTRL|ALT", action = act.CloseCurrentPane({ confirm = false }) },
    { key = "h", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Right") },
    { key = "k", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Up") },
    { key = "j", mods = "CTRL|ALT", action = act.ActivatePaneDirection("Down") },

    { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },

    { key = "LeftArrow", mods = "CTRL|ALT", action = act.AdjustPaneSize({ "Left", 5 }) },
    { key = "RightArrow", mods = "CTRL|ALT", action = act.AdjustPaneSize({ "Right", 5 }) },
    { key = "UpArrow", mods = "CTRL|ALT", action = act.AdjustPaneSize({ "Up", 5 }) },
    { key = "DownArrow", mods = "CTRL|ALT", action = act.AdjustPaneSize({ "Down", 5 }) },

    {
      key = "s",
      mods = "LEADER|CTRL",
      action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "v",
      mods = "LEADER|CTRL",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },

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

    { key = "o", mods = "LEADER|CTRL", action = act.RotatePanes("CounterClockwise") },
    { key = "o", mods = "LEADER|ALT", action = act.RotatePanes("Clockwise") },
    {
      key = "!",
      mods = "LEADER|SHIFT",
      action = act.PaneSelect({ mode = "MoveToNewTab" }),
    },
    { key = "f", mods = "LEADER", action = act.PaneSelect },

    -- clipboard
    { key = "y", mods = "CTRL|ALT", action = act.QuickSelect },
    { key = "[", mods = "CTRL|ALT", action = act.ActivateCopyMode },
    { key = "]", mods = "CTRL|ALT", action = act.PasteFrom("PrimarySelection") },
    { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
    { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
    { key = "]", mods = "LEADER", action = act.PasteFrom("PrimarySelection") },
    { key = "y", mods = "LEADER", action = act.QuickSelect },
    { key = "y", mods = "LEADER|CTRL", action = act.QuickSelect },

    -- General mappings
    {
      key = "o",
      mods = "CTRL|ALT",
      action = wezterm.action.QuickSelectArgs({
        label = "open url",
        patterns = { "https?://\\S+" },
        action = wezterm.action_callback(function(window, pane)
          local url = window:get_selection_text_for_pane(pane)
          wezterm.log_info("opening: " .. url)
          wezterm.open_with(url)
        end),
      }),
    },

    { key = ";", mods = "CTRL|ALT", action = act.ActivateCommandPalette },
    { key = "Enter", mods = "CTRL|ALT", action = act.ShowLauncher },
    { key = "0", mods = "CTRL|ALT", action = act.ResetFontSize },
    { key = "=", mods = "CTRL|ALT", action = act.IncreaseFontSize },
    { key = "-", mods = "CTRL|ALT", action = act.DecreaseFontSize },
    { key = "PageUp", mods = "NONE", action = act.ScrollByPage(-1) },
    { key = "PageDown", mods = "NONE", action = act.ScrollByPage(1) },
    { key = "PageUp", mods = "CTRL", action = act.ScrollToPrompt(-1) },
    { key = "PageDown", mods = "CTRL", action = act.ScrollToPrompt(1) },
    { key = "PageUp", mods = "CTRL|ALT", action = act.ScrollToTop },
    { key = "PageDown", mods = "CTRL|ALT", action = act.ScrollToBottom },
    { key = "r", mods = "LEADER", action = act.ReloadConfiguration },
    { key = "i", mods = "LEADER", action = act.CharSelect },
    { key = "/", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },
    { key = "/", mods = "CTRL|ALT", action = act.Search("CurrentSelectionOrEmptyString") },
    { key = ":", mods = "LEADER|SHIFT", action = act.ActivateCommandPalette },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "?", mods = "LEADER|SHIFT", action = act.ShowDebugOverlay },

    -- Key table keymaps
    {
      key = "Enter",
      mods = "LEADER",
      action = act.ActivateKeyTable({
        name = "pane_management",
        one_shot = false,
        timeout_milliseconds = 3000,
        until_unknown = true,
        replace_current = false,
      }),
    },
  }

  config.key_tables = {
    pane_management = {
      { key = "Escape", action = "PopKeyTable" },
      { key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 5 }) },
      { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 5 }) },
      { key = "UpArrow", action = act.AdjustPaneSize({ "Up", 5 }) },
      { key = "DownArrow", action = act.AdjustPaneSize({ "Down", 5 }) },
      { key = "h", action = act.ActivatePaneDirection("Left") },
      { key = "l", action = act.ActivatePaneDirection("Right") },
      { key = "k", action = act.ActivatePaneDirection("Up") },
      { key = "j", action = act.ActivatePaneDirection("Down") },
      { key = "x", action = act.CloseCurrentPane({ confirm = false }) },
      { key = "v", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
      { key = "s", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    },

    copy_mode = utils.merge_lists(wezterm.gui.default_key_tables().copy_mode, {
      {
        key = "/",
        mods = "NONE",
        action = act.Search("CurrentSelectionOrEmptyString"),
      },
      {
        key = "n",
        mods = "NONE",
        action = act.Multiple({
          act.CopyMode("NextMatch"),
          act.CopyMode("ClearSelectionMode"),
        }),
      },
      {
        key = "N",
        mods = "SHIFT",
        action = act.Multiple({
          act.CopyMode("PriorMatch"),
          act.CopyMode("ClearSelectionMode"),
        }),
      },
      {
        key = "Y",
        mods = "SHIFT",
        action = act.Multiple({
          act.CopyMode({ SetSelectionMode = "Line" }),
          act.CopyTo("ClipboardAndPrimarySelection"),
          act.CopyMode("Close"),
        }),
      },
      {
        key = "Escape",
        mods = "NONE",
        action = act.Multiple({
          act.ClearSelection,
          act.CopyMode("ClearPattern"),
          act.CopyMode("Close"),
        }),
      },
    }),

    search_mode = utils.merge_lists(wezterm.gui.default_key_tables().search_mode, {
      {
        key = "Enter",
        mods = "NONE",
        action = act.Multiple({ act.CopyMode("ClearSelectionMode"), act.ActivateCopyMode }),
      },
      { key = "n", mods = "NONE", action = act.CopyMode("NextMatch") },
      { key = "N", mods = "SHIFT", action = act.CopyMode("PriorMatch") },
    }),
  }
end

return M
