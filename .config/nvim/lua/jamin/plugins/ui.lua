local res = require "jamin.resources"

return {
  {
    dir = "~/.vim/pack/foo/start/gruvbox-material",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/start/gruvbox-material",
    lazy = false,
    priority = 42069,
    config = function()
      vim.g.gruvbox_material_background = "soft"
      vim.g.gruvbox_material_foreground = "original"
      vim.g.gruvbox_material_ui_contrast = "high"
      vim.g.gruvbox_material_diagnostic_virtual_text = "highlghted"
      vim.g.gruvbox_material_float_style = "dim"
      vim.g.gruvbox_material_current_word = "bold"
      vim.g.gruvbox_material_statusline_style = "original"

      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_diagnostic_text_highlight = 0
      vim.g.gruvbox_material_disable_terminal_colors = 1
      -- vim.g.gruvbox_material_dim_inactive_windows = 1

      if not vim.g.neovide and not vim.g.started_by_firenvim then
        vim.g.gruvbox_material_transparent_background = 1
      end

      local gruvbox_custom_colors = function()
        local alt_palette = vim.fn["gruvbox_material#get_palette"]("hard", "material", { x = {} })
        local palette = vim.fn["gruvbox_material#get_palette"](
          vim.g.gruvbox_material_background,
          vim.g.gruvbox_material_foreground,
          {
            bg_visual_yellow = { "#7a380b", "208" },
            bg_orange = { "#5A3B0A", "130" },
          }
        )

        local hl = vim.fn["gruvbox_material#highlight"]

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

        hl("CmpItemAbbrDeprecated", palette.grey1, palette.none, "strikethrough")

        -- vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
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
    opts = {
      default = true,
      override = {
        ["md"] = { icon = "", color = "#ffffff", cterm_color = "231", name = "Md" },
        ["mdx"] = { icon = "", color = "#519aba", cterm_color = "74", name = "Mdx" },
      },
    },
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
  -----------------------------------------------------------------------------
  {
    "j-hui/fidget.nvim",
    -- enabled = false,
    event = "LspAttach",
    keys = {
      { "<leader>nn", "<CMD>Fidget history<CR>", desc = "View notification history (fidget)" },
      { "<leader>nt", "<CMD>Fidget suppress<CR>", desc = "Toggle notifications (fidget)" },
      { "<leader>nx", "<CMD>Fidget clear<CR>", desc = "Clear notifications (fidget)" },
      {
        "<leader>np",
        "<CMD>Fidget lsp_suppress<CR>",
        desc = "Toggle LSP progress notifications (fidget)",
      },
      {
        "<leader>nX",
        "<CMD>Fidget clear_history<CR>",
        desc = "Clear notification history (fidget)",
      },
    },
    opts = {
      progress = {
        poll_rate = 0.5,
        ignore_done_already = true,
        ignore = { "null-ls" },
        display = { done_icon = res.icons.ui.checkmark },
      },
      notification = {
        override_vim_notify = true,
        window = { winblend = 0, x_padding = 0 },
      },
    },
  },
}
