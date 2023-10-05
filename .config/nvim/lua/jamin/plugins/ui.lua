return {
  {
    dir = "~/.vim/pack/foo/start/gruvbox-material",
    lazy = false,
    priority = 42069,
    config = function()
      vim.g.gruvbox_material_background = "soft"
      vim.g.gruvbox_material_foreground = "original"
      vim.g.gruvbox_material_ui_contrast = "high"
      vim.g.gruvbox_material_diagnostic_virtual_text = "highlghted"
      -- vim.g.gruvbox_material_statusline_style = "original"

      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_enable_bold = 0
      vim.g.gruvbox_material_diagnostic_text_highlight = 0
      -- vim.g.gruvbox_material_disable_terminal_colors = 1
      -- vim.g.gruvbox_material_dim_inactive_windows = 1

      if not vim.g.neovide then vim.g.gruvbox_material_transparent_background = 1 end

      local gruvbox_custom_colors = function()
        local palette = vim.fn["gruvbox_material#get_palette"]("soft", "material", {
          bg_visual_yellow = { "#7a380b", "208" },
          bg_orange = { "#5A3B0A", "130" },
        })

        local hl = vim.fn["gruvbox_material#highlight"]

        hl("DiffDelete", palette.bg5, palette.bg_diff_red)
        hl("DiffChange", palette.none, palette.bg_orange)
        hl("DiffText", palette.fg0, palette.bg_visual_yellow)

        hl("GitSignsChange", palette.orange, palette.none)
        hl("GitSignsChangeNr", palette.orange, palette.none)
        hl("GitSignsChangeLn", palette.orange, palette.none)

        hl("GitStatusLineChange", palette.orange, palette.bg3)
        hl("GitStatusLineAdd", palette.green, palette.bg3)
        hl("GitStatusLineDelete", palette.red, palette.bg3)

        hl("LazyStatusLineInfo", palette.purple, palette.bg3)
        hl("DapStatusLineInfo", palette.aqua, palette.bg3)

        hl("CmpItemAbbrDeprecated", palette.grey1, palette.none, "strikethrough")

        vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Normal" })
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "Normal" })
        vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { link = "Folded" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { link = "Boolean" })

        vim.cmd "highlight ErrorMsg cterm=bold gui=bold"
      end

      vim.api.nvim_create_autocmd({ "ColorScheme" }, {
        pattern = "gruvbox-material",
        group = vim.api.nvim_create_augroup("jamin_gruvbox_custom_colors", { clear = true }),
        callback = gruvbox_custom_colors,
      })

      vim.cmd "colorscheme gruvbox-material"
    end,
  },
  -----------------------------------------------------------------------------
  {
    "nvim-tree/nvim-web-devicons", -- filetype icons
    -- enabled = false,
    lazy = true,
    cond = vim.g.use_devicons == true,
  },
  -----------------------------------------------------------------------------
  {
    "Eandrju/cellular-automaton.nvim", -- best useless plugin ever
    -- enabled = false,
    cmd = "CellularAutomaton",
    keys = {
      { "<leader>s!", "<CMD>CellularAutomaton make_it_rain<CR>", desc = "Make it rain" },
      { "<leader>s~", "<CMD>CellularAutomaton game_of_life<CR>", desc = "Game of life" },
    },
  },
  -----------------------------------------------------------------------------
  {
    "jinh0/eyeliner.nvim", -- highlights the best character to f/F/t/T per word
    -- enabled = false,
    event = "CursorHold",
    opts = { highlight_on_key = false, dim = true },
    config = function(_, opts)
      require("eyeliner").setup(opts)
      vim.api.nvim_set_hl(0, "EyelinerPrimary", { link = "Operator" })
    end,
  },
}
