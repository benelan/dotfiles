local wezterm = require("wezterm")
local keymaps = require("keymaps")

return {
  font = wezterm.font 'JetBrains Mono',
  color_scheme = "Gruvbox dark, medium (base16)",
  colors = {
    tab_bar = {
      active_tab = {
        bg_color = '#282828',
        fg_color = '#a89984',
      }
    }
  },
  audible_bell = 'Disabled',
  check_for_updates = false,
  enable_wayland = false,
  use_dead_keys = false,
  warn_about_missing_glyphs = false,
  hide_tab_bar_if_only_one_tab = false,
  tab_bar_at_bottom = false,
  adjust_window_size_when_changing_font_size = false,
  window_close_confirmation = "AlwaysPrompt",
  window_decorations = "NONE",
  window_padding = {
    left = 7,
    right = 7,
    top = 3,
    bottom = 3,
  },
  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
  },
  skip_close_confirmation_for_processes_named = {
    'bash',
    'sh',
  },
  -- enable_kitty_graphics = false,
  animation_fps = 1,
  disable_default_key_bindings = false,
  leader = { key = ' ', mods = 'CTRL|SHIFT', timeout_milliseconds = 1500 },
  keys = keymaps.keys,
  key_tables = keymaps.key_tables,
  mouse_bindings = keymaps.mouse_bindings,
  selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%",
  hyperlink_rules = {
    -- Linkify things that look like URLs and the host has a TLD name.
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
      regex = '\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b',
      format = '$0',
    },

    -- linkify email addresses
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
      regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
      format = 'mailto:$0',
    },

    -- file:// URI
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
      regex = [[\bfile://\S*\b]],
      format = '$0',
    },

    -- Linkify things that look like URLs with numeric addresses as hosts.
    -- E.g. http://127.0.0.1:8000 for a local development server,
    -- or http://192.168.1.1 for the web interface of many routers.
    {
      regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
      format = '$0',
    },
    -- Make username/project paths clickable. This implies paths like the following are for GitHub.
    -- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
    -- As long as a full URL hyperlink regex exists above this it should not match a full URL to
    -- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
    {
      regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
      format = 'https://www.github.com/$1/$3',
    },
  },
}
