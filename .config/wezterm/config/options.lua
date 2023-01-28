local wezterm = require("wezterm")
local utils = require("utils")

return {
  -- Using wezterm term requires additional setup
  -- https://wezfurlong.org/wezterm/config/lua/config/term
  term = "wezterm", -- xterm-256color
  default_cwd = wezterm.home_dir,
  -- default_domain = "WSL:Ubuntu",
  font = wezterm.font_with_fallback {
    "Iosevka Nerd Font",
    "SauceCodePro Nerd Font",
    "JetBrains Mono Nerd Font",
    "monspace"
  },
  font_size = 12,
  scrollback_lines = 10000,
  color_scheme = utils.color_scheme,
  colors = {
    cursor_bg = utils.colors.foreground,
    cursor_fg = utils.colors.background,
    cursor_border = utils.colors.foreground,
    compose_cursor = utils.colors.brights[4],
    quick_select_label_fg = { Color = utils.colors.brights[2] },
    quick_select_match_fg = { Color = utils.colors.brights[7] },
    split = utils.colors.brights[7],
    tab_bar = {
      active_tab = {
        bg_color = utils.colors.background,
        fg_color = utils.colors.foreground,
      },
      inactive_tab_edge = "transparent",
      inactive_tab_hover = {
        bg_color = utils.colors.brights[1],
        fg_color = utils.colors.background,
      },
      new_tab_hover = {
        bg_color = utils.colors.brights[1],
        fg_color = utils.colors.background,
      },
    },
  },
  audible_bell = "Disabled",
  animation_fps = 1,
  check_for_updates = false,
  enable_wayland = false,
  enable_kitty_graphics = true,
  warn_about_missing_glyphs = false,
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,
  window_decorations = "NONE",
  window_background_opacity = 0.95,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 1,
  },
  inactive_pane_hsb = {
    saturation = 0.7,
    brightness = 0.8,
  },
  skip_close_confirmation_for_processes_named = {
    "bash", "sh", "btop", "lazygit", "gh",
    "wslhost.exe", "wsl.exe", "conhost.exe"
  },
  launch_menu = {
    { args = { "btop" } },
    { args = { "gh", "dash" } },
    { args = { "lazygit" } },
    {
      label = "edit dotfiles",
      cwd = wezterm.home_dir,
      args = {
        "nvim", "~", "-c", ":Telescope git_files",
        "--cmd", "let $GIT_WORK_TREE = expand('~')",
        "--cmd", "let $GIT_DIR = expand('~/.git')"
      }
    },
    {
      label = "edit CC",
      cwd = wezterm.home_dir .. "/dev/work/calcite-components",
      args = {
        "nvim", ".", "-c", ":Telescope git_files"
      }
    },

  },
  leader = { key = " ", mods = "ALT|CTRL", timeout_milliseconds = 1500 },
  hyperlink_rules = {
    -- Linkify things that look like URLs and the host has a TLD name.
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
      regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
      format = "$0",
    },

    -- linkify email addresses
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
      regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
      format = "mailto:$0",
    },

    -- file:// URI
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
      regex = [[\bfile://\S*\b]],
      format = "$0",
    },

    -- Linkify things that look like URLs with numeric addresses as hosts.
    -- E.g. http://127.0.0.1:8000 for a local development server,
    -- or http://192.168.1.1 for the web interface of many routers.
    {
      regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
      format = "$0",
    },
    -- Make username/project paths clickable. This implies paths like the following are for GitHub.
    -- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
    -- As long as a full URL hyperlink regex exists above this it should not match a full URL to
    -- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
    {
      regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
      format = "https://www.github.com/$1/$3",
    },
  },
}
