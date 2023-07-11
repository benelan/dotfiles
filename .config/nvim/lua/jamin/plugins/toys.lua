return {
  {
    "nvim-tree/nvim-web-devicons",
    -- enabled = false,
    lazy = true,
    cond = vim.g.use_devicons == true,
  },
  -----------------------------------------------------------------------------
  {
    "Eandrju/cellular-automaton.nvim",
    -- enabled = false,
    cmd = "CellularAutomaton",
    keys = {
      { "<leader>s!", "<cmd>CellularAutomaton make_it_rain<cr>", desc = "Make it rain" },
      { "<leader>s~", "<cmd>CellularAutomaton game_of_life<cr>", desc = "Game of life" },
    },
  },
  -----------------------------------------------------------------------------
  {
    "uga-rosa/ccc.nvim",
    -- enabled = false,
    cmd = { "CccPick", "CccConvert", "CccHighlighterToggle" },
    keys = {
      { "<leader>Ch", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle color highlighter" },
      { "<leader>Cp", "<cmd>CccPick<cr>", desc = "Pick color" },
      { "<leader>Cc", "<cmd>CccConvert<cr>", desc = "Convert color" },
    },
    opts = {
      save_on_quit = true,
      point_char = "x",
      win_opts = { border = "solid" },
      highlighter = {
        auto_enable = true,
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "css",
          "scss",
          "sass",
          "json",
        },
      },
    },
  },
  -----------------------------------------------------------------------------
  {
    "jinh0/eyeliner.nvim",
    -- enabled = false,
    event = "CursorHold",
    opts = { highlight_on_key = false, dim = true },
    config = function(_, opts)
      require("eyeliner").setup(opts)
      vim.api.nvim_set_hl(0, "EyelinerPrimary", { link = "Type" })
    end,
  },
  -----------------------------------------------------------------------------
  {
    "kosayoda/nvim-lightbulb",
    enabled = false,
    event = "VeryLazy",
    cond = vim.g.use_devicons,
    opts = { autocmd = { enabled = true } },
    init = function()
      vim.fn.sign_define("LightBulbSign", {
        text = require("jamin.resources").icons.ui.light,
        texthl = "Yellow",
      })
    end,
  },
  -----------------------------------------------------------------------------
  {
    "petertriho/nvim-scrollbar",
    enabled = false,
    event = "VeryLazy",
    dependencies = { "lewis6991/gitsigns.nvim" },
    opts = {
      max_lines = 10000,
      hide_if_all_visible = true,
      handle = { highlight = "TabLine" },
      marks = { Misc = { highlight = "Purple" } },
      handlers = { gitsigns = true },
      excluded_filetypes = require("jamin.resources").filetypes.excluded,
    },
    config = function(_, opts)
      require("scrollbar").setup(opts)
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },
  -----------------------------------------------------------------------------
  {
    "simrat39/symbols-outline.nvim",
    -- enabled = false,
    cmd = "SymbolsOutline",
    keys = {
      { "<leader>O", "<cmd>SymbolsOutline<cr>", desc = "SymbolsOutline" },
    },
    opts = {
      keymaps = { hover_symbol = "K", toggle_preview = "p" },
      fold_markers = {
        require("jamin.resources").icons.ui.collapsed,
        require("jamin.resources").icons.ui.expanded,
      },
      --stylua: ignore
      symbols = {
        File = { icon = require("jamin.resources").icons.lsp_kind.File, hl = "@text.uri" },
        Module = { icon = require("jamin.resources").icons.lsp_kind.Module, hl = "@namespace" },
        Namespace = { icon = require("jamin.resources").icons.lsp_kind.Namespace, hl = "@namespace" },
        Package = { icon = require("jamin.resources").icons.lsp_kind.Package, hl = "@namespace" },
        Class = { icon = require("jamin.resources").icons.lsp_kind.Class, hl = "@type" },
        Method = { icon = require("jamin.resources").icons.lsp_kind.Method, hl = "@method" },
        Property = { icon = require("jamin.resources").icons.lsp_kind.Property, hl = "@method" },
        Field = { icon = require("jamin.resources").icons.lsp_kind.Field, hl = "@field" },
        Constructor = { icon = require("jamin.resources").icons.lsp_kind.Constructor, hl = "@constructor" },
        Enum = { icon = require("jamin.resources").icons.lsp_kind.Enum, hl = "@type" },
        Interface = { icon = require("jamin.resources").icons.lsp_kind.Interface, hl = "@type" },
        Function = { icon = require("jamin.resources").icons.lsp_kind.Function, hl = "@function" },
        Variable = { icon = require("jamin.resources").icons.lsp_kind.Variable, hl = "@constant" },
        Constant = { icon = require("jamin.resources").icons.lsp_kind.Constant, hl = "@constant" },
        String = { icon = require("jamin.resources").icons.lsp_kind.String, hl = "@string" },
        Number = { icon = require("jamin.resources").icons.lsp_kind.Number, hl = "@number" },
        Boolean = { icon = require("jamin.resources").icons.lsp_kind.Boolean, hl = "@boolean" },
        Array = { icon = require("jamin.resources").icons.lsp_kind.Array, hl = "@constant" },
        Object = { icon = require("jamin.resources").icons.lsp_kind.Object, hl = "@type" },
        Key = { icon = require("jamin.resources").icons.lsp_kind.Key, hl = "@type" },
        Null = { icon = require("jamin.resources").icons.lsp_kind.Null, hl = "@type" },
        EnumMember = { icon = require("jamin.resources").icons.lsp_kind.EnumMember, hl = "@field" },
        Struct = { icon = require("jamin.resources").icons.lsp_kind.Struct, hl = "@type" },
        Event = { icon = require("jamin.resources").icons.lsp_kind.Event, hl = "@type" },
        Operator = { icon = require("jamin.resources").icons.lsp_kind.Operator, hl = "@operator" },
        TypeParameter = { icon = require("jamin.resources").icons.lsp_kind.TypeParameter, hl = "@parameter" },
        Component = { icon = require("jamin.resources").icons.lsp_kind.Component, hl = "@function" },
        Fragment = { icon = require("jamin.resources").icons.lsp_kind.Fragment, hl = "@constant" },
      },
    },
  },
  -----------------------------------------------------------------------------
  {
    "SmiteshP/nvim-navic",
    -- enabled = false,
    event = "LspAttach",
    opts = {
      icons = require("jamin.resources").icons.lsp_kind,
      separator = "  >  ",
      lsp = { auto_attach = true },
      -- highlight = true,
    },
  },
  -----------------------------------------------------------------------------
  {
    "j-hui/fidget.nvim",
    -- enabled = false,
    tag = "legacy",
    event = "LspAttach",
    opts = {
      text = { spinner = "circle" },
      window = { blend = 0 },
      sources = { ["null-ls"] = { ignore = true } },
    },
  },
  -----------------------------------------------------------------------------
  {
    "folke/which-key.nvim", -- keymap helper for the memory deficient
    -- enabled = false,
    event = "CursorHold",
    config = function()
      require("which-key").setup {
        icons = { separator = require("jamin.resources").icons.ui.prompt },
      }

      -- Normal mode
      require("which-key").register {
        ["g:"] = "External program operator",
        ["gp"] = { name = "preview" },
        ["]S"] = "Fix next misspelled word",
        ["[S"] = "Fix previous misspelled word",
        ["<leader>"] = {
          ["<C-l>"] = "Redraw",
          ["<Del>"] = "Delete buffer",
          ["bd"] = "Delete buffer and window",
          ["\\"] = "Vertical split",
          ["-"] = "Horizontal split",
          p = "Paste to clipboard",
          y = "Copy to clipboard",
          Y = "Copy eol to clipboard",
          q = "Quit",
          w = "Write",
          r = "Replace operator",
          u = "Undotree",
          Z = "Zoom buffer",
          C = { name = "color" },
          D = { name = "debug" },
          R = { name = "refactor" },
          S = { name = "system" },
          E = {
            name = "ex",
            ["!"] = "Bang repeat",
            R = "Replace word under cursor",
            r = "Edit register",
            g = "Execute vimgrep",
            h = "Execute lhelpgrep",
          },
          c = {
            name = "cheat",
            q = { name = "questions" },
            a = { name = "answers" },
            h = { name = "history" },
            s = { name = "see also" },
          },
          b = { name = "buffers" },
          d = { name = "doc" },
          f = { name = "find", z = { name = "fzf" } },
          l = { name = "lsp" },
          s = { name = "settings" },
          t = { name = "tabs" },
          W = { name = "wiki" },
          z = { name = "zk" },
          g = {
            name = "git",
            t = { name = "toggle options" },
            f = { name = "find" },
            h = { name = "hunk" },
            -- w = { name = "worktree" },
          },
          o = {
            name = "octo (github)",
            i = { name = "issues", D = { name = "remove" }, a = { name = "add" } },
            m = { name = "my stuff", i = { name = "issues" }, p = { name = "pull requests" } },
            p = {
              name = "pull requests",
              D = { name = "remove" },
              a = { name = "add" },
              r = { name = "reviews" },
            },
            r = { name = "reactions" },
          },
        },
      }
      -- Visual mode
      require("which-key").register({
        ["<leader>"] = {
          ["<C-l>"] = "Redraw",
          D = { name = "debug" },
          R = { name = "refactor" },
          y = "Copy to clipboard",
          p = "Paste to clipboard",
          d = "Delete to clipboard",
          r = "Replace operator",
          z = { name = "zk" },
          g = { name = "git", h = { name = "hunk" } },
          c = {
            name = "cheat",
            q = { name = "questions" },
            a = { name = "answers" },
            h = { name = "history" },
            s = { name = "see also" },
          },
        },
      }, { mode = "v" })

      -- Operator mode
      require("which-key").register({ V = "Last selection", B = "Whole buffer" }, { mode = "o" })
    end,
  },
}
