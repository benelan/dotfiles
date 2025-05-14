local wezterm = require("wezterm") --[[@as Wezterm]]
local utils = require("utils")
local tmux = require("tmux")
local git_mux = wezterm.plugin.require("https://github.com/benelan/git-mux")

local act = wezterm.action
local M = {}

---@param config Config
function M.apply_to_config(config)
  config.disable_default_key_bindings = true
  config.leader = {
    key = " ",
    mods = wezterm.GLOBAL.multiplexer == "wezterm" and "CTRL" or "CTRL|SHIFT",
    timeout_milliseconds = 1500,
  }

  config.keys = utils.merge_lists(tmux.default_keybinds(), {
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

    { key = ">", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },
    { key = "<", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
    { key = "q", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
    { key = "Backspace", mods = "LEADER", action = act.ActivateLastTab },

    { key = "f", mods = "LEADER", action = act.PaneSelect({ mode = "Activate" }) },
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },

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
      key = "u",
      mods = "LEADER",
      action = act.QuickSelectArgs({
        patterns = { [[https?://[^\]",' ]+\w]] },
        label = "Open URL",
        action = wezterm.action_callback(function(window, pane)
          local url = window:get_selection_text_for_pane(pane)
          wezterm.open_with(url)
        end),
      }),
    },

    { key = "y", mods = "LEADER", action = act.QuickSelect },
    { key = "y", mods = "LEADER|CTRL", action = act.QuickSelect },

    -- General mappings
    {
      key = "o",
      mods = "LEADER",
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

    { key = "Enter", mods = "LEADER", action = act.ShowLauncher },
    { key = "0", mods = "LEADER", action = act.ResetFontSize },
    { key = "=", mods = "LEADER", action = act.IncreaseFontSize },
    { key = "-", mods = "LEADER", action = act.DecreaseFontSize },
    {
      key = "PageUp",
      action = wezterm.action_callback(function(win, pane)
        -- if TUI (such as fullscreen fzf), send key to TUI,
        -- otherwise scroll by page https://github.com/wez/wezterm/discussions/4101
        if pane:is_alt_screen_active() then
          win:perform_action(act.SendKey({ key = "PageUp" }), pane)
        else
          win:perform_action(act.ScrollByPage(-0.8), pane)
        end
      end),
    },
    {
      key = "PageDown",
      action = wezterm.action_callback(function(win, pane)
        if pane:is_alt_screen_active() then
          win:perform_action(act.SendKey({ key = "PageDown" }), pane)
        else
          win:perform_action(act.ScrollByPage(0.8), pane)
        end
      end),
    },
    {
      key = "i",
      mods = "LEADER",
      action = act.CharSelect({ copy_to = "ClipboardAndPrimarySelection" }),
    },
    { key = "/", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },
    { key = "?", mods = "LEADER|SHIFT", action = act.ShowDebugOverlay },
    { key = " ", mods = "LEADER|CTRL|SHIFT", action = act.ActivateCommandPalette },

    -- root key table (no leader)
    { key = "Enter", mods = "CTRL|SHIFT", action = act.ShowLauncher },
    { key = "PageUp", mods = "CTRL|SHIFT", action = act.ScrollToPrompt(-1) },
    { key = "PageDown", mods = "CTRL|SHIFT", action = act.ScrollToPrompt(1) },
    -- { key = "h", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
    -- { key = "l", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },
    -- { key = "k", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Up") },
    -- { key = "j", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Down") },
    -- { key = "q", mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
    -- { key = "n", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(1) },
    -- { key = "p", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
    -- { key = "x", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = false }) },

    -- { key = "[", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
    -- { key = "]", mods = "CTRL|SHIFT", action = act.PasteFrom("PrimarySelection") },
    -- { key = "/", mods = "CTRL|SHIFT", action = act.Search("CurrentSelectionOrEmptyString") },
    { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
    { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
    { key = "y", mods = "CTRL|SHIFT", action = act.QuickSelect },
    { key = "0", mods = "CTRL|SHIFT", action = act.ResetFontSize },
    { key = "=", mods = "CTRL|SHIFT", action = act.IncreaseFontSize },
    { key = "-", mods = "CTRL|SHIFT", action = act.DecreaseFontSize },

    -- Key table keymaps
    {
      key = "r",
      mods = "LEADER",
      action = act.ActivateKeyTable({
        name = "pane_management",
        one_shot = false,
        timeout_milliseconds = 3000,
        until_unknown = true,
        replace_current = false,
      }),
    },
  })

  config.key_tables = {
    pane_management = {
      { key = "Escape", action = "PopKeyTable" },
      { key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 5 }) },
      { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 5 }) },
      { key = "UpArrow", action = act.AdjustPaneSize({ "Up", 5 }) },
      { key = "DownArrow", action = act.AdjustPaneSize({ "Down", 5 }) },
      { key = "b", action = act.AdjustPaneSize({ "Left", 5 }) },
      { key = "f", action = act.AdjustPaneSize({ "Right", 5 }) },
      { key = "u", action = act.AdjustPaneSize({ "Up", 5 }) },
      { key = "d", action = act.AdjustPaneSize({ "Down", 5 }) },
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
        key = "/",
        mods = "SHIFT",
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
      { key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
      { key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
    }),
  }
end

return M
