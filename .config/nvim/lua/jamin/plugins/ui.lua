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
      { "<leader>vh", "<CMD>Fidget history<CR>", desc = "View notification history (fidget)" },
      { "<leader>vn", "<CMD>Fidget suppress<CR>", desc = "Toggle notifications (fidget)" },
      {
        "<leader>vp",
        "<CMD>Fidget lsp_suppress<CR>",
        desc = "Toggle LSP progress notifications (fidget)",
      },
      { "<leader>vx", "<CMD>Fidget clear<CR>", desc = "Clear notifications (fidget)" },
      {
        "<leader>vd",
        "<CMD>Fidget clear_history<CR>",
        desc = "Delete notification history (fidget)",
      },
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
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { { "<leader>O", "<cmd>Outline<CR>", desc = "Toggle outline" } },
    opts = {
      outline_window = { hide_cursor = true },
      outline_items = { show_symbol_lineno = true },
      symbols = {
        icons = {
          Array = { icon = res.icons.lsp_kind.Array, hl = "@constant" },
          Boolean = { icon = res.icons.lsp_kind.Boolean, hl = "@boolean" },
          Class = { icon = res.icons.lsp_kind.Class, hl = "@type" },
          Component = { icon = res.icons.lsp_kind.Component, hl = "@function" },
          Constant = { icon = res.icons.lsp_kind.Constant, hl = "@constant" },
          Constructor = { icon = res.icons.lsp_kind.Constructor, hl = "@constructor" },
          Enum = { icon = res.icons.lsp_kind.Enum, hl = "@type" },
          EnumMember = { icon = res.icons.lsp_kind.EnumMember, hl = "@field" },
          Event = { icon = res.icons.lsp_kind.Event, hl = "@type" },
          Field = { icon = res.icons.lsp_kind.Field, hl = "@field" },
          File = { icon = res.icons.lsp_kind.File, hl = "@text.uri" },
          Fragment = { icon = res.icons.lsp_kind.Fragment, hl = "@constant" },
          Function = { icon = res.icons.lsp_kind.Function, hl = "@function" },
          Interface = { icon = res.icons.lsp_kind.Interface, hl = "@type" },
          Key = { icon = res.icons.lsp_kind.Key, hl = "@type" },
          Macro = { icon = res.icons.lsp_kind.Macro, hl = "@method" },
          Method = { icon = res.icons.lsp_kind.Method, hl = "@method" },
          Module = { icon = res.icons.lsp_kind.Module, hl = "@namespace" },
          Namespace = { icon = res.icons.lsp_kind.Namespace, hl = "@namespace" },
          Null = { icon = res.icons.lsp_kind.Null, hl = "@type" },
          Number = { icon = res.icons.lsp_kind.Number, hl = "@number" },
          Object = { icon = res.icons.lsp_kind.Object, hl = "@type" },
          Operator = { icon = res.icons.lsp_kind.Operator, hl = "@operator" },
          Package = { icon = res.icons.lsp_kind.Package, hl = "@namespace" },
          Parameter = { icon = res.icons.lsp_kind.Parameter, hl = "@parameter" },
          Property = { icon = res.icons.lsp_kind.Property, hl = "@method" },
          StaticMethod = { icon = res.icons.lsp_kind.StaticMethod, hl = "@method" },
          String = { icon = res.icons.lsp_kind.String, hl = "@string" },
          Struct = { icon = res.icons.lsp_kind.Struct, hl = "@type" },
          TypeAlias = { icon = res.icons.lsp_kind.TypeAlias, hl = "@type" },
          TypeParameter = { icon = res.icons.lsp_kind.TypeParameter, hl = "@parameter" },
          Variable = { icon = res.icons.lsp_kind.Variable, hl = "@constant" },
        },
      },
    },
  },
}
