local wezterm = require("wezterm")
local utils = require("utils")

return {
  -- Using wezterm term requires additional setup
  -- https://wezfurlong.org/wezterm/config/lua/config/term
  term = "wezterm", -- xterm-256color
  default_cwd = wezterm.home_dir,
  -- default_domain = "WSL:Ubuntu",
  font = wezterm.font_with_fallback {
    'Iosevka Nerd Font',
    'SauceCodePro Nerd Font',
    'JetBrains Mono Nerd Font',
    'monspace'
  },
  font_size = 11,
  color_scheme = utils.color_scheme,
  colors = {
    tab_bar = {
      active_tab = {
        bg_color = utils.colors.background,
        fg_color = utils.colors.foreground,
      },
      inactive_tab = {
        fg_color = utils.colors.ansi[8],
        bg_color = 'transparent',
      },
      inactive_tab_edge = utils.colors.ansi[8],
      inactive_tab_hover = {
        bg_color = utils.colors.brights[1],
        fg_color = utils.colors.background,
      },
      new_tab_hover = {
        fg_color = utils.colors.foreground,
        bg_color = utils.colors.background,
      },
    },
  },
  audible_bell = 'Disabled',
  animation_fps = 1,
  check_for_updates = false,
  enable_wayland = false,
  enable_kitty_graphics = true,
  warn_about_missing_glyphs = false,
  hide_tab_bar_if_only_one_tab = false,
  adjust_window_size_when_changing_font_size = false,
  window_close_confirmation = "NeverPrompt", -- AlwaysPrompt
  window_decorations = "NONE",
  window_background_opacity = 0.95,
  window_padding = {
    left = 5,
    right = 5,
    top = 1,
    bottom = 1,
  },
  inactive_pane_hsb = {
    saturation = 0.7,
    brightness = 0.8,
  },
  skip_close_confirmation_for_processes_named = { 'bash', 'sh' },
  launch_menu = { { args = { 'htop' } } },
  leader = { key = ' ', mods = 'ALT|SHIFT', timeout_milliseconds = 1500 },
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
