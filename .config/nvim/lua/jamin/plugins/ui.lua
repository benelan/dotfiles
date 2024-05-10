local res = require("jamin.resources")

return {
  {
    dir = "~/.vim/pack/foo/start/gruvbox-material",
    cond = vim.fn.isdirectory("~/.vim/pack/foo/start/gruvbox-material"),
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

        vim.cmd.highlight("ErrorMsg cterm=bold gui=bold")
      end

      vim.api.nvim_create_autocmd({ "ColorScheme" }, {
        pattern = "gruvbox-material",
        group = vim.api.nvim_create_augroup("jamin_gruvbox_custom_colors", {}),
        callback = gruvbox_custom_colors,
      })

      vim.cmd.colorscheme("gruvbox-material")
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
      { "<leader>!", "<CMD>CellularAutomaton make_it_rain<CR>", desc = "Make it rain" },
      { "<leader>~", "<CMD>CellularAutomaton game_of_life<CR>", desc = "Game of life" },
    },
  },

  -----------------------------------------------------------------------------
  {
    "j-hui/fidget.nvim",
    -- enabled = false,
    event = "LspAttach",
    keys = {
      { "<leader>vh", "<CMD>Fidget history<CR>", desc = "View message history (fidget)" },
      { "<leader>vd", "<CMD>Fidget clear_history<CR>", desc = "Delete message history (fidget)" },
      { "<leader>vx", "<CMD>Fidget clear<CR>", desc = "Clear displayed notifications (fidget)" },
      { "<leader>vn", "<CMD>Fidget suppress<CR>", desc = "Toggle notification display (fidget)" },
      { "<leader>vp", "<CMD>Fidget lsp_suppress<CR>", desc = "Toggle LSP progress (fidget)" },
    },
    opts = {
      progress = {
        ignore = { "null-ls" },
        display = { done_icon = res.icons.ui.checkmark },
      },
      notification = {
        override_vim_notify = true,
        window = { winblend = 0, x_padding = 0 },
      },
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
    "folke/trouble.nvim", -- lsp/diagnsotic lists
    cmd = "Trouble",
    branch = "dev",
    keys = {
      {
        "<leader>xx",
        "<CMD>Trouble diagnostics toggle<CR>",
        desc = "Diagnostics (trouble)",
      },
      {
        "<leader>xb",
        "<CMD>Trouble diagnostics toggle filter.buf=0<CR>",
        desc = "Buffer diagnostics (trouble)",
      },
      {
        "<leader>xs",
        "<CMD>Trouble symbols toggle focus=false<CR>",
        desc = "Symbols (trouble)",
      },
      {
        "<leader>xl",
        "<CMD>Trouble lsp toggle focus=false win.position=right<CR>",
        desc = "LSP definitions/references/etc (trouble)",
      },
      {
        "<leader>xL",
        "<CMD>Trouble loclist toggle<CR>",
        desc = "Location list (trouble)",
      },
      {
        "<leader>xQ",
        "<CMD>Trouble qflist toggle<CR>",
        desc = "Quickfix list (trouble)",
      },
      {
        "]d",
        function()
          if require("trouble").is_open({ mode = "diagnostics" }) then
            ---@diagnostic disable-next-line: missing-parameter
            require("trouble").next({ mode = "diagnostics", jump = true })
          else
            vim.diagnostic.goto_next({ float = true })
          end
        end,
        desc = "Next diagnostic (trouble)",
      },
      {
        "[d",
        function()
          if require("trouble").is_open({ mode = "diagnostics" }) then
            ---@diagnostic disable-next-line: missing-parameter
            require("trouble").prev({ mode = "diagnostics", jump = true })
          else
            vim.diagnostic.goto_prev({ float = true })
          end
        end,
        desc = "Previous diagnostic (trouble)",
      },
    },

    opts = {
      keys = { H = "fold_close", J = "next", K = "prev", L = "fold_open" },
      modes = {
        cascade = {
          mode = "diagnostics",
          filter = function(items)
            local severity = vim.diagnostic.severity.HINT
            for _, item in ipairs(items) do
              severity = math.min(severity, item.severity)
            end
            return vim.tbl_filter(function(item) return item.severity == severity end, items)
          end,
        },
      },
      icons = {
        indent = { fold_open = res.icons.ui.expanded, fold_closed = res.icons.ui.collapsed },
        folder_closed = res.icons.ui.folder_closed,
        folder_open = res.icons.ui.folder_open,
        kinds = res.icons.lsp_kind,
      },
    },
  },
}
