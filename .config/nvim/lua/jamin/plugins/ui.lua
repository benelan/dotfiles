---Plugins to make things purrty

---@type LazySpec
return {
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 100,

    config = function()
      if vim.g.neovide or vim.g.started_by_firenvim then
        vim.g.gruvbox_material_dim_inactive_windows = 1
      else
        vim.g.gruvbox_material_transparent_background = 1
        vim.g.gruvbox_material_background = "soft"
      end

      vim.g.gruvbox_material_foreground = "original"
      vim.g.gruvbox_material_ui_contrast = "high"
      vim.g.gruvbox_material_float_style = "dim"
      vim.g.gruvbox_material_menu_selection_background = "blue"
      vim.g.gruvbox_material_current_word = "grey background"
      -- vim.g.gruvbox_material_inlay_hints_background = "dimmed"
      vim.g.gruvbox_material_diagnostic_virtual_text = "highlighted" -- "grey", "colored"

      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_disable_italic_comment = 1
      vim.g.gruvbox_material_disable_terminal_colors = 1

      local gruvbox_custom_colors = function()
        local hl = vim.fn["gruvbox_material#highlight"]
        local alt_palette = vim.fn["gruvbox_material#get_palette"]("hard", "material", { x = {} })
        local palette = vim.fn["gruvbox_material#get_palette"](
          vim.g.gruvbox_material_background or "medium",
          vim.g.gruvbox_material_foreground or "material",
          {
            bg_visual_yellow = { "#7a380b", "208" },
            bg_orange = { "#5A3B0A", "130" },
          }
        )

        hl("DiffDelete", palette.bg5, palette.bg_diff_red)
        hl("DiffChange", palette.none, palette.bg_orange)
        hl("DiffText", palette.fg0, palette.bg_visual_yellow)

        hl("StatusLineState", palette.none, palette.bg3)
        hl("StatusLineLazy", palette.purple, palette.bg3)
        hl("StatusLineDap", palette.aqua, palette.bg3)

        hl("StatusLineDiagnosticSev1", palette.red, palette.bg3) -- error
        hl("StatusLineDiagnosticSev2", palette.yellow, palette.bg3) -- warning
        hl("StatusLineDiagnosticSev3", palette.blue, palette.bg3) -- info
        hl("StatusLineDiagnosticSev4", palette.green, palette.bg3) -- hint

        hl("StatusLineGitChange", alt_palette.orange, palette.bg3)
        hl("StatusLineGitAdd", alt_palette.green, palette.bg3)
        hl("StatusLineGitDelete", alt_palette.red, palette.bg3)

        hl("GitSignsChange", alt_palette.orange, palette.none)
        hl("GitSignsChangeNr", alt_palette.orange, palette.none)
        hl("GitSignsChangeLn", alt_palette.orange, palette.none)
        hl("GitSignsUntracked", alt_palette.purple, palette.none)

        hl("CmpItemAbbrDeprecated", palette.grey1, palette.none, "strikethrough")

        vim.api.nvim_set_hl(0, "CursorLineNr", { link = "Boolean" })
        vim.cmd.highlight("ErrorMsg cterm=bold gui=bold")
      end

      vim.api.nvim_create_autocmd({ "ColorScheme" }, {
        pattern = "gruvbox-material",
        group = vim.api.nvim_create_augroup("jamin.gruvbox_custom_colors", {}),
        callback = gruvbox_custom_colors,
      })

      vim.cmd.colorscheme("gruvbox-material")
    end,
  },

  -----------------------------------------------------------------------------
  -- syntax for log files
  { "fei6409/log-highlight.nvim", ft = { "log" } },

  -----------------------------------------------------------------------------
  -- filetype icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    cond = vim.g.have_nerd_font,
    opts = {
      default = true,
      override = {
        ["md"] = { icon = "", color = "#ffffff", cterm_color = "231", name = "Md" },
        ["mdx"] = { icon = "", color = "#519aba", cterm_color = "74", name = "Mdx" },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- best useless plugin ever
  {
    "Eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
    keys = {
      { "<leader>!", "<CMD>CellularAutomaton make_it_rain<CR>", desc = "Make it rain" },
      { "<leader>~", "<CMD>CellularAutomaton game_of_life<CR>", desc = "Game of life" },
    },
  },

  -----------------------------------------------------------------------------
  -- highlights the best character to f/F/t/T per word
  {
    "jinh0/eyeliner.nvim",
    event = "VeryLazy",
    opts = {
      disabled_filetypes = Jamin.filetypes.excluded,
      disabled_buftypes = { "nofile", "help", "quickfix", "terminal" },
    },
    config = function(_, opts)
      require("eyeliner").setup(opts)
      vim.api.nvim_set_hl(0, "EyelinerPrimary", { link = "Operator" })
      vim.api.nvim_set_hl(0, "EyelinerSecondary", { link = "Boolean" })
    end,
  },
}
