local M = {}
local wezterm = require "wezterm"
local utils = require "utils"
local act = wezterm.action

M.keys = {
  -- Pane management
  { key = 'v', mods = 'ALT|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 's', mods = 'ALT|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
  { key = 'p', mods = 'ALT|SHIFT', action = act.PaneSelect { alphabet = "1234567890" } },
  { key = "b", mods = "ALT|SHIFT", action = act.RotatePanes "CounterClockwise", },
  { key = "f", mods = "ALT|SHIFT", action = act.RotatePanes "Clockwise" },
  { key = "q", mods = "ALT|SHIFT", action = act.CloseCurrentPane { confirm = true } },
  { key = 'h', mods = 'ALT|SHIFT', action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'ALT|SHIFT', action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'ALT|SHIFT', action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'ALT|SHIFT', action = act.ActivatePaneDirection 'Down' },

  -- Tab management
  { key = 'h', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = 'l', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) },
  { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = "q", mods = "CTRL|SHIFT", action = act.CloseCurrentTab { confirm = true } },

  -- General mappings
  { key = ':', mods = 'CTRL|SHIFT', action = act.QuickSelect },
  { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo "Clipboard" },
  { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom "Clipboard" },
  { key = "Insert", mods = "CTRL|SHIFT", action = act.PasteFrom "PrimarySelection" },
  { key = "=", mods = "CTRL|SHIFT", action = "ResetFontSize" },
  { key = "+", mods = "CTRL|SHIFT", action = "IncreaseFontSize" },
  { key = "-", mods = "CTRL|SHIFT", action = "DecreaseFontSize" },
  { key = "PageUp", mods = "CTRL|SHIFT", action = act.ScrollByPage(-1) },
  { key = "PageDown", mods = "CTRL|SHIFT", action = act.ScrollByPage(1) },
  { key = 'r', mods = 'CTRL|SHIFT', action = act.ReloadConfiguration },
  { key = '~', mods = 'CTRL|SHIFT', action = act.ClearScrollback 'ScrollbackOnly' },

  -- Keymaps for activating key tables
  {
    key = "r",
    mods = "LEADER",
    action = act.ActivateKeyTable {
      name = "resize_pane",
      one_shot = false,
      timeout_milliseconds = 1500,
      replace_current = false,
    },
  },
  {
    key = 'a',
    mods = 'LEADER',
    action = act.ActivateKeyTable {
      name = 'activate_pane',
      one_shot = false,
      timeout_milliseconds = 1500,
      replace_current = false,
    },
  },
  {
    key = "y",
    mods = "LEADER",
    action = act.ActivateKeyTable {
      name = "copy_mode",
      one_shot = false,
      timeout_milliseconds = 1500,
      replace_current = false,
    },
  },
  {
    key = "/",
    mods = "LEADER",
    action = act.ActivateKeyTable {
      name = "search_mode",
      one_shot = false,
      timeout_milliseconds = 1500,
      replace_current = false,
    },
  }
}

M.key_tables = {
  resize_pane = {
    { key = "Escape", action = "PopKeyTable" },
    { key = "LeftArrow", action = act.AdjustPaneSize { "Left", 1 } },
    { key = "RightArrow", action = act.AdjustPaneSize { "Right", 1 } },
    { key = "DownArrow", action = act.AdjustPaneSize { "Down", 1 } },
    { key = "UpArrow", action = act.AdjustPaneSize { "Up", 1 } },
    { key = "h", action = act.AdjustPaneSize { "Left", 1 } },
    { key = "l", action = act.AdjustPaneSize { "Right", 1 } },
    { key = "k", action = act.AdjustPaneSize { "Up", 1 } },
    { key = "j", action = act.AdjustPaneSize { "Down", 1 } },
  },

  activate_pane = {
    { key = 'LeftArrow', action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', action = act.ActivatePaneDirection 'Right' },
    { key = 'UpArrow', action = act.ActivatePaneDirection 'Up' },
    { key = 'DownArrow', action = act.ActivatePaneDirection 'Down' },
    { key = 'h', action = act.ActivatePaneDirection 'Left' },
    { key = 'l', action = act.ActivatePaneDirection 'Right' },
    { key = 'k', action = act.ActivatePaneDirection 'Up' },
    { key = 'j', action = act.ActivatePaneDirection 'Down' },
  },

  copy_mode = utils.merge_lists(
    wezterm.gui.default_key_tables().copy_mode,
    {
      { key = "u", mods = "CTRL", action = act.CopyMode "MoveToViewportTop" },
      { key = "d", mods = "CTRL", action = act.CopyMode "MoveToViewportBottom" },
      { key = "/", mods = "NONE", action = act.Search "CurrentSelectionOrEmptyString" },
      {
        key = "n",
        mods = "NONE",
        action = act.Multiple {
          act.CopyMode "NextMatch",
          act.CopyMode "ClearSelectionMode",
        },
      },
      {
        key = "N",
        mods = "SHIFT",
        action = act.Multiple {
          act.CopyMode "PriorMatch",
          act.CopyMode "ClearSelectionMode",
        },
      },
      {
        key = "Y",
        mods = "SHIFT",
        action = act.Multiple {
          act.CopyMode { SetSelectionMode = 'Line' },
          act.CopyTo "ClipboardAndPrimarySelection",
          act.CopyMode "Close",
        },
      },
      {
        key = "Escape",
        mods = "NONE",
        action = act.Multiple {
          act.ClearSelection,
          act.CopyMode "ClearPattern",
          act.CopyMode "Close",
        },
      },
    }
  ),

  search_mode = utils.merge_lists(
    wezterm.gui.default_key_tables().search_mode,
    {
      {
        key = "Enter",
        mods = "NONE",
        action = act.Multiple {
          act.CopyMode "ClearSelectionMode",
          act.ActivateCopyMode,
        },
      },
      { key = "n", mods = "NONE", action = act.CopyMode "NextMatch" },
      { key = "N", mods = "SHIFT", action = act.CopyMode "PriorMatch" },
    }
  )
}

M.mouse_bindings = {
  -- Bind 'Up' event of CTRL-Click to open hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
  -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.Nop,
  },
}

return M