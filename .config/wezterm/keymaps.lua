local wezterm = require "wezterm"
local utils = require "utils"
local act = wezterm.action
local M = {}

M.keys = {
  {
    key = "Enter",
    mods = "ALT",
    action = act.DisableDefaultAssignment,
  },
  {
    key = "=",
    mods = "CTRL",
    action = act.DisableDefaultAssignment,
  },
  {
    key = "+",
    mods = "ALT|SHIFT",
    action = act.IncreaseFontSize,
  },
  {
    key = "-",
    mods = "CTRL",
    action = act.DisableDefaultAssignment,
  },
  {
    key = "_",
    mods = "ALT|SHIFT",
    action = act.DecreaseFontSize,
  },
  {
    key = "0",
    mods = "CTRL",
    action = act.DecreaseFontSize,
  },
  {
    key = ")",
    mods = "ALT|SHIFT",
    action = act.ResetFontSize,
  },
  -- Pane management
  {
    key = "q",
    mods = "CTRL|SHIFT",
    action = act.CloseCurrentPane { confirm = false },
  },
  { key = "h", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection "Left" },
  { key = "l", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection "Right" },
  { key = "k", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection "Up" },
  { key = "j", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection "Down" },
  {
    key = "w",
    mods = "CTRL|SHIFT",
    action = act.PaneSelect { alphabet = "asdfghjklqwertyuipzxcvmnb" },
  },
  { key = "<", mods = "CTRL|SHIFT", action = act.RotatePanes "CounterClockwise" },
  { key = ">", mods = "CTRL|SHIFT", action = act.RotatePanes "Clockwise" },
  {
    key = "_",
    mods = "CTRL|SHIFT",
    action = act.SplitVertical { domain = "CurrentPaneDomain" },
  },
  {
    key = "|",
    mods = "CTRL|SHIFT",
    action = act.SplitHorizontal { domain = "CurrentPaneDomain" },
  },

  -- Tab management
  { key = "p", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
  { key = "n", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(1) },
  {
    key = "Delete",
    mods = "CTRL|SHIFT",
    action = act.CloseCurrentTab { confirm = true },
  },

  -- General mappings
  { key = "o", mods = "CTRL|SHIFT", action = act.SpawnWindow },
  { key = "{", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
  { key = "{", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
  { key = "}", mods = "CTRL|SHIFT", action = act.PasteFrom "PrimarySelection" },
  { key = ":", mods = "CTRL|SHIFT", action = act.QuickSelect },
  {
    key = "~",
    mods = "CTRL|SHIFT",
    action = act.ClearScrollback "ScrollbackOnly",
  },
  { key = "F12", mods = "CTRL|SHIFT", action = act.ShowDebugOverlay },

  -- Keymaps for activating key tables
  {
    key = "r",
    mods = "LEADER",
    action = act.ActivateKeyTable {
      name = "resize_pane",
      one_shot = false,
      timeout_milliseconds = 2000,
      until_unknown = true,
      replace_current = false,
    },
  },
  {
    key = "a",
    mods = "LEADER",
    action = act.ActivateKeyTable {
      name = "activate_pane",
      one_shot = false,
      timeout_milliseconds = 1500,
      until_unknown = true,
      replace_current = false,
    },
  },
}

M.key_tables = {
  resize_pane = {
    { key = "Escape", action = "PopKeyTable" },
    { key = "LeftArrow", action = act.AdjustPaneSize { "Left", 1 } },
    { key = "RightArrow", action = act.AdjustPaneSize { "Right", 1 } },
    { key = "DownArrow", action = act.AdjustPaneSize { "Down", 1 } },
    { key = "UpArrow", action = act.AdjustPaneSize { "Up", 5 } },
    { key = "h", action = act.AdjustPaneSize { "Left", 5 } },
    { key = "l", action = act.AdjustPaneSize { "Right", 5 } },
    { key = "k", action = act.AdjustPaneSize { "Up", 5 } },
    { key = "j", action = act.AdjustPaneSize { "Down", 5 } },
  },

  activate_pane = {
    { key = "LeftArrow", action = act.ActivatePaneDirection "Left" },
    { key = "RightArrow", action = act.ActivatePaneDirection "Right" },
    { key = "UpArrow", action = act.ActivatePaneDirection "Up" },
    { key = "DownArrow", action = act.ActivatePaneDirection "Down" },
    { key = "h", action = act.ActivatePaneDirection "Left" },
    { key = "l", action = act.ActivatePaneDirection "Right" },
    { key = "k", action = act.ActivatePaneDirection "Up" },
    { key = "j", action = act.ActivatePaneDirection "Down" },
    { key = "q", action = act.CloseCurrentPane { confirm = false } },
  },

  copy_mode = utils.merge_lists(wezterm.gui.default_key_tables().copy_mode, {
    { key = "u", mods = "CTRL", action = act.CopyMode "MoveToViewportTop" },
    { key = "d", mods = "CTRL", action = act.CopyMode "MoveToViewportBottom" },
    {
      key = "/",
      mods = "NONE",
      action = act.Search "CurrentSelectionOrEmptyString",
    },
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
        act.CopyMode { SetSelectionMode = "Line" },
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
  }),

  search_mode = utils.merge_lists(wezterm.gui.default_key_tables().search_mode, {
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
  }),
}

M.mouse_bindings = {
  -- Bind "Up" event of CTRL-Click to open hyperlinks
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = act.OpenLinkAtMouseCursor,
  },
  -- Disable the "Down" event of CTRL-Click to avoid weird program behaviors
  {
    event = { Down = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = act.Nop,
  },
}

return M
