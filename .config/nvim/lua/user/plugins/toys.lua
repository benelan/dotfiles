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
    "petertriho/nvim-scrollbar",
    enabled = false,
    event = "VeryLazy",
    dependencies = { "lewis6991/gitsigns.nvim" },
    opts = {
      max_lines = 10000,
      hide_if_all_visible = true,
      marks = {
        Error = { highlight = "DiagnosticSignError" },
        Warn = { highlight = "DiagnosticSignWarn" },
        Info = { highlight = "DiagnosticSignInfo" },
        Hint = { highlight = "DiagnosticSignHint" },
        Misc = { highlight = "Purple" },
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true,
        handle = true,
      },
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
