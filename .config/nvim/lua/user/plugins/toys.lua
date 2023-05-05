return {
  {
    "Eandrju/cellular-automaton.nvim",
    enabled = false,
    cmd = "CellularAutomaton",
    keys = {
      {
        "<leader>s!",
        "<cmd>CellularAutomaton make_it_rain<cr>",
        "Make it rain",
      },
      {
        "<leader>s~",
        "<cmd>CellularAutomaton game_of_life<cr>",
        "Game of life",
      },
    },
  },
  -----------------------------------------------------------------------------
  {
    "uga-rosa/ccc.nvim",
    -- enabled = false,
    cmd = { "CccPick", "CccConvert", "CccHighlighterToggle" },
    opts = {
      save_on_quit = true,
      highlighter = {
        auto_enable = true,
        filetypes = { "css", "scss", "sass", "json" },
      },
    },
  },
  -----------------------------------------------------------------------------
  {
    "jinh0/eyeliner.nvim",
    -- enabled = false,
    event = "VeryLazy",
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
        text = require("user.resources").icons.ui.Light,
        texthl = "Yellow",
      })
    end,
  },
  -----------------------------------------------------------------------------
  {
    "simrat39/symbols-outline.nvim",
    enabled = false,
    keys = {
      { "<leader>O", "<cmd>SymbolsOutline<cr>", desc = "SymbolsOutlineToggle" }
    },
    opts = {
      keymaps = {
        hover_symbol = "K",
        toggle_preview = "p",
      },
      fold_markers = {
        require("user.resources").icons.ui.Collapsed,
        require("user.resources").icons.ui.Expanded,
      },
      symbols = {
        File = {
          icon = require("user.resources").icons.kind.File,
          hl = "@text.uri",
        },
        Module = {
          icon = require("user.resources").icons.kind.Module,
          hl = "@namespace",
        },
        Namespace = {
          icon = require("user.resources").icons.kind.Namespace,
          hl = "@namespace",
        },
        Package = {
          icon = require("user.resources").icons.kind.Package,
          hl = "@namespace",
        },
        Class = {
          icon = require("user.resources").icons.kind.Class,
          hl = "@type",
        },
        Method = {
          icon = require("user.resources").icons.kind.Method,
          hl = "@method",
        },
        Property = {
          icon = require("user.resources").icons.kind.Property,
          hl = "@method",
        },
        Field = {
          icon = require("user.resources").icons.kind.Field,
          hl = "@field",
        },
        Constructor = {
          icon = require("user.resources").icons.kind.Constructor,
          hl = "@constructor",
        },
        Enum = {
          icon = require("user.resources").icons.kind.Enum,
          hl = "@type",
        },
        Interface = {
          icon = require("user.resources").icons.kind.Interface,
          hl = "@type",
        },
        Function = {
          icon = require("user.resources").icons.kind.Function,
          hl = "@function",
        },
        Variable = {
          icon = require("user.resources").icons.kind.Variable,
          hl = "@constant",
        },
        Constant = {
          icon = require("user.resources").icons.kind.Constant,
          hl = "@constant",
        },
        String = {
          icon = require("user.resources").icons.kind.String,
          hl = "@string",
        },
        Number = {
          icon = require("user.resources").icons.kind.Number,
          hl = "@number",
        },
        Boolean = {
          icon = require("user.resources").icons.kind.Boolean,
          hl = "@boolean",
        },
        Array = {
          icon = require("user.resources").icons.kind.Array,
          hl = "@constant",
        },
        Object = {
          icon = require("user.resources").icons.kind.Object,
          hl = "@type",
        },
        Key = { icon = require("user.resources").icons.kind.Key, hl = "@type" },
        Null = {
          icon = require("user.resources").icons.kind.Null,
          hl = "@type",
        },
        EnumMember = {
          icon = require("user.resources").icons.kind.EnumMember,
          hl = "@field",
        },
        Struct = {
          icon = require("user.resources").icons.kind.Struct,
          hl = "@type",
        },
        Event = {
          icon = require("user.resources").icons.kind.Event,
          hl = "@type",
        },
        Operator = {
          icon = require("user.resources").icons.kind.Operator,
          hl = "@operator",
        },
        TypeParameter = {
          icon = require("user.resources").icons.kind.TypeParameter,
          hl = "@parameter",
        },
        Component = {
          icon = require("user.resources").icons.kind.Component,
          hl = "@function",
        },
        Fragment = {
          icon = require("user.resources").icons.kind.Fragment,
          hl = "@constant",
        },
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
      excluded_filetypes = require("user.resources").exclude_filetypes,
    },
    config = function(_, opts)
      require("scrollbar").setup(opts)
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },
  -----------------------------------------------------------------------------
  {
    "lvimuser/lsp-inlayhints.nvim",
    enabled = false,
    event = "LspAttach",
    opts = {
      inlay_hints = {
        only_current_line = true,
        max_len_align = true,
        highlight = "Comment",
      },
    },
    config = function(_, opts)
      require("lsp-inlayhints").setup(opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {}),
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
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
    event = "BufWinEnter",
    opts = {
      char = require("user.resources").icons.ui.Separator,
      indent_blankline_filetype_exclude = require("user.resources").exclude_filetypes,
      show_trailing_blankline_indent = false,
      use_treesitter = true,
      show_current_context = true,
    },
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
        ["gP"] = { name = "preview" },
        ["<leader>"] = {
          b = { name = "buffers" },
          c = {
            name = "cheat",
            q = { name = "questions" },
            a = { name = "answers" },
            h = { name = "history" },
            s = { name = "see also" },
          },
          -- d = { name = "Debug" },
          E = { name = "ex" },
          f = { name = "find", z = { name = "fzf" } },
          l = { name = "lsp" },
          s = { name = "settings" },
          t = { name = "tabs" },
          z = { name = "zk" },
          g = {
            name = "git",
            m = { name = "mergetool" },
            t = { name = "toggle options" },
            w = { name = "worktree" },
          },
          o = {
            name = "octo (github)",
            i = {
              name = "issues",
              D = { name = "remove" },
              a = { name = "add" },
            },
            m = {
              name = "my stuff",
              i = { name = "issues" },
              p = { name = "pull requests" },
            },
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
          c = {
            name = "cheat",
            q = { name = "questions" },
            a = { name = "answers" },
            h = { name = "history" },
            s = { name = "see also" },
          },
          g = { name = "git", m = { name = "mergetool" } },
          z = { name = "zk" },
        },
      }, { mode = "x" })
    end,
  },
}
