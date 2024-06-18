local wezterm = require("wezterm") --[[@as Wezterm]]
local utils = require("utils")
local M = {}

---@param config Config
function M.apply_config(config)
  if string.match(wezterm.target_triple, "windows") then
    config.default_domain = "WSL:Ubuntu-22.04"
  else
    local home = utils.basename(wezterm.home_dir)
    config.unix_domains = { { name = "git-mux" } }
    config.default_gui_startup_args = { "connect", "git-mux", "--workspace", home }
  end

  -- Using wezterm TERM requires additional setup
  -- https://wezfurlong.org/wezterm/config/lua/config/term
  config.term = "wezterm" -- xterm-256color
  config.default_cwd = wezterm.home_dir
  config.animation_fps = 1
  config.cursor_blink_rate = 0
  config.check_for_updates = false
  config.scrollback_lines = 10000

  config.audible_bell = "Disabled"
  config.window_close_confirmation = "NeverPrompt"

  config.clean_exit_codes = { 130 }
  config.exit_behavior = "Close"

  config.font_size = 15
  config.font = wezterm.font_with_fallback({ "Iosevka Nerd Font" })
  config.use_cap_height_to_scale_fallback_fonts = true
  config.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"
  config.warn_about_missing_glyphs = false

  config.adjust_window_size_when_changing_font_size = false
  config.window_decorations = "RESIZE"
  config.window_background_opacity = 0.90
  config.window_padding = { left = 3, right = 0, top = 0, bottom = 0 }
  config.inactive_pane_hsb = { saturation = 0.8, brightness = 0.8 }

  config.tab_max_width = 70
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.show_new_tab_button_in_tab_bar = false

  config.color_scheme = "GruvboxDark"
  local palette = wezterm.get_builtin_color_schemes()[config.color_scheme]

  config.colors = {
    cursor_bg = palette.foreground,
    cursor_fg = palette.background,
    cursor_border = palette.foreground,
    compose_cursor = palette.brights[4],
    quick_select_label_fg = { Color = palette.brights[2] },
    quick_select_match_fg = { Color = palette.brights[7] },
    split = palette.brights[7],
    tab_bar = {
      active_tab = {
        bg_color = palette.background,
        fg_color = palette.foreground,
        intensity = "Bold",
      },
      inactive_tab_edge = "transparent",
      inactive_tab_hover = {
        bg_color = palette.brights[1],
        fg_color = palette.background,
      },
      new_tab_hover = {
        bg_color = palette.brights[1],
        fg_color = palette.background,
      },
    },
  }

  config.launch_menu = {
    { args = { "btop" } },
    { args = { "gh-fzf" } },
    {
      label = "GitHub Issues",
      args = { "nvim", "-c", ":Octo issue list assignee=benelan state=OPEN" },
    },
    {
      label = "GitHub Pull Requests",
      args = { "nvim", "-c", ":Octo search is:open is:pr author:benelan sort:updated" },
    },
    {
      label = "Fugitive Status",
      args = {
        "nvim",
        "-c",
        ":Git | only",
        "--cmd",
        "let $GIT_WORK_TREE = expand('~')",
        "--cmd",
        "let $GIT_DIR = expand('~/.git')",
      },
    },
    {
      label = "Edit Dotfiles",
      cwd = wezterm.home_dir,
      args = {
        "nvim",
        "-c",
        ":Telescope git_files",
        "--cmd",
        "let $GIT_WORK_TREE = expand('~')",
        "--cmd",
        "let $GIT_DIR = expand('~/.git')",
      },
    },
    {
      label = "Edit Calcite",
      cwd = wezterm.home_dir .. "/dev/work/calcite-design-system/main",
      args = { "nvim", "-c", ":Telescope git_files" },
    },
  }

  config.hyperlink_rules = wezterm.default_hyperlink_rules()

  -- Linkify things that look like URLs with numeric addresses as hosts.
  -- E.g. http://127.0.0.1:8000 for a local development server,
  -- or http://192.168.1.1 for the web interface of many routers.
  table.insert(
    config.hyperlink_rules,
    { regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]], format = "$0" }
  )
end

return M
