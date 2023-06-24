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
  },
  -----------------------------------------------------------------------------
  {
    "kosayoda/nvim-lightbulb",
    enabled = false,
    event = "VeryLazy",
    opts = { autocmd = { enabled = true } },
    init = function()
      vim.fn.sign_define("LightBulbSign", {
        text = require("jamin.resources").icons.ui.Light,
        texthl = "Yellow",
      })
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
        require("jamin.resources").icons.ui.Collapsed,
        require("jamin.resources").icons.ui.Expanded,
      },
      --stylua: ignore
      symbols = {
        File = { icon = require("jamin.resources").icons.kind.File, hl = "@text.uri" },
        Module = { icon = require("jamin.resources").icons.kind.Module, hl = "@namespace" },
        Namespace = { icon = require("jamin.resources").icons.kind.Namespace, hl = "@namespace" },
        Package = { icon = require("jamin.resources").icons.kind.Package, hl = "@namespace" },
        Class = { icon = require("jamin.resources").icons.kind.Class, hl = "@type" },
        Method = { icon = require("jamin.resources").icons.kind.Method, hl = "@method" },
        Property = { icon = require("jamin.resources").icons.kind.Property, hl = "@method" },
        Field = { icon = require("jamin.resources").icons.kind.Field, hl = "@field" },
        Constructor = { icon = require("jamin.resources").icons.kind.Constructor, hl = "@constructor" },
        Enum = { icon = require("jamin.resources").icons.kind.Enum, hl = "@type" },
        Interface = { icon = require("jamin.resources").icons.kind.Interface, hl = "@type" },
        Function = { icon = require("jamin.resources").icons.kind.Function, hl = "@function" },
        Variable = { icon = require("jamin.resources").icons.kind.Variable, hl = "@constant" },
        Constant = { icon = require("jamin.resources").icons.kind.Constant, hl = "@constant" },
        String = { icon = require("jamin.resources").icons.kind.String, hl = "@string" },
        Number = { icon = require("jamin.resources").icons.kind.Number, hl = "@number" },
        Boolean = { icon = require("jamin.resources").icons.kind.Boolean, hl = "@boolean" },
        Array = { icon = require("jamin.resources").icons.kind.Array, hl = "@constant" },
        Object = { icon = require("jamin.resources").icons.kind.Object, hl = "@type" },
        Key = { icon = require("jamin.resources").icons.kind.Key, hl = "@type" },
        Null = { icon = require("jamin.resources").icons.kind.Null, hl = "@type" },
        EnumMember = { icon = require("jamin.resources").icons.kind.EnumMember, hl = "@field" },
        Struct = { icon = require("jamin.resources").icons.kind.Struct, hl = "@type" },
        Event = { icon = require("jamin.resources").icons.kind.Event, hl = "@type" },
        Operator = { icon = require("jamin.resources").icons.kind.Operator, hl = "@operator" },
        TypeParameter = { icon = require("jamin.resources").icons.kind.TypeParameter, hl = "@parameter" },
        Component = { icon = require("jamin.resources").icons.kind.Component, hl = "@function" },
        Fragment = { icon = require("jamin.resources").icons.kind.Fragment, hl = "@constant" },
      },
    },
  },
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
      excluded_filetypes = require("jamin.resources").exclude_filetypes,
    },
    config = function(_, opts)
      require("scrollbar").setup(opts)
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },
  -----------------------------------------------------------------------------
  {
    "SmiteshP/nvim-navic",
    -- enabled = false,
    event = "LspAttach",
    opts = {
      icons = require("jamin.resources").icons.kind,
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
  {
    "lvimuser/lsp-inlayhints.nvim",
    enabled = false,
    event = "LspAttach",
    opts = {
      inlay_hints = {
        highlight = "Comment",
        parameter_hints = { show = false },
        type_hints = {
          prefix = string.format("   %s ", require("jamin.resources").icons.ui.CaretDoubleLeft),
        },
      },
    },
    config = function(_, opts)
      require("lsp-inlayhints").setup(opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("jamin_lsp_attach_inlayhints", {}),
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("lsp-inlayhints").on_attach(client, args.buf)
        end,
      })
    end,
  },
  -----------------------------------------------------------------------------
  -- Presentation plugins
  {
    "folke/zen-mode.nvim",
    enabled = false,
    cmd = "ZenMode",
    keys = { { "<leader>sZ", "<cmd>ZenMode<cr>", desc = "ZenMode" } },
    opts = {
      window = {
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
        },
      },
      plugins = {
        twilight = { enabled = false },
        tmux = { enabled = true },
        wezterm = { enabled = true, font = "+6" },
        gitsigns = { enabled = true },
      },
    },
  },
  {
    "folke/twilight.nvim",
    enabled = false,
    cmd = "Twilight",
    keys = { { "<leader>sT", "<cmd>Twilight<cr>", desc = "Twilight" } },
    opts = { context = 13 },
  },
  -----------------------------------------------------------------------------
  {
    "folke/which-key.nvim", -- keymap helper for the memory deficient
    -- enabled = false,
    event = "CursorHold",
    config = function()
      require("which-key").setup { icons = { separator = "⮞" } }

      -- Normal mode
      require("which-key").register {
        ["g:"] = "External program operator",
        ["gp"] = { name = "preview" },
        ["<leader>"] = {
          ["<C-l>"] = "Redraw",
          ["<Del>"] = "Delete buffer",
          ["bd"] = "Delete buffer and window",
          ["\\"] = "Vertical split",
          ["-"] = "Horizontal split",
          r = "Replace operator",
          u = "Undotree",
          C = { name = "color" },
          D = { name = "debug" },
          R = { name = "refactor" },
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
          z = { name = "zk" },
          g = {
            name = "git",
            m = { name = "mergetool" },
            t = { name = "toggle options" },
            f = { name = "find" },
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
          r = "Replace operator",
          z = { name = "zk" },
          g = { name = "git", m = { name = "mergetool" } },
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
