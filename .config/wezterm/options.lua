local wezterm = require "wezterm"
local utils = require "utils"
local M = {}

function M.apply_config(config)
  -- Using wezterm term requires additional setup
  -- https://wezfurlong.org/wezterm/config/lua/config/term
  config.term = "wezterm" -- xterm-256color
  config.default_cwd = wezterm.home_dir
  -- default_domain = "WSL:Ubuntu-22.04",
  config.audible_bell = "Disabled"
  config.animation_fps = 1
  config.check_for_updates = false
  config.enable_wayland = false
  config.enable_kitty_graphics = true
  config.warn_about_missing_glyphs = false
  config.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"
  config.hide_tab_bar_if_only_one_tab = true
  config.adjust_window_size_when_changing_font_size = false
  config.window_decorations = "NONE"
  config.window_background_opacity = 0.85
  config.window_padding = { left = 3, right = 0, top = 0, bottom = 0 }
  config.inactive_pane_hsb = { saturation = 0.7, brightness = 0.8 }
  config.switch_to_last_active_tab_when_closing_tab = true
  config.clean_exit_codes = { 130 }
  config.exit_behavior = "CloseOnCleanExit"
  config.window_close_confirmation = "NeverPrompt"
  config.scrollback_lines = 10000

  config.font_size = 14
  config.use_cap_height_to_scale_fallback_fonts = true
  config.font = wezterm.font_with_fallback { "Iosevka Nerd Font" }

  config.color_scheme = utils.color_scheme
  config.colors = {
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
  }

  config.launch_menu = {
    { args = { "btop" } },
    { args = { "gh", "dash" } },
    { args = { "lazygit" } },
    {
      label = "edit dotfiles",
      cwd = wezterm.home_dir,
      args = {
        "nvim",
        "~",
        "-c",
        ":Telescope git_files",
        "--cmd",
        "let $GIT_WORK_TREE = expand('~')",
        "--cmd",
        "let $GIT_DIR = expand('~/.git')",
      },
    },
    {
      label = "edit Calcite",
      cwd = wezterm.home_dir .. "/dev/work/calcite-design-system",
      args = { "nvim", ".", "-c", ":Telescope git_files" },
    },
  }

  config.hyperlink_rules = wezterm.default_hyperlink_rules()

  -- make username/project paths clickable. this implies paths like the following are for github.
  -- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
  -- as long as a full url hyperlink regex exists above this it should not match a full url to
  -- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
  table.insert(config.hyperlink_rules, {
    regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
    format = "https://www.github.com/$1/$3",
  })

  -- Linkify things that look like URLs with numeric addresses as hosts.
  -- E.g. http://127.0.0.1:8000 for a local development server,
  -- or http://192.168.1.1 for the web interface of many routers.
  table.insert(
    config.hyperlink_rules,
    { regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]], format = "$0" }
  )
end

return M
