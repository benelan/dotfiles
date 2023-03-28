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
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
    opts = {
      char = "┊",
      show_trailing_blankline_indent = false,
      use_treesitter = true,
      show_current_context = true,
    },
  },
  {
    "jinh0/eyeliner.nvim",
    enabled = false,
    opts = { highlight_on_key = false, dim = true },
  },
  {
    "kosayoda/nvim-lightbulb",
    enabled = false,
    event = "VeryLazy",
    opts = { autocmd = { enabled = true } },
    init = function()
      vim.fn.sign_define("LightBulbSign", {
        text = "",
        texthl = "Yellow",
      })
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    enabled = false,
    dependencies = { "lewis6991/gitsigns.nvim" },
    opts = {
      max_lines = 10000,
      hide_if_all_visible = true,
      marks = {
        Error = { highlight = "DiagnosticSignError" },
        Warn = { highlight = "DiagnosticSignWarn" },
        Info = { highlight = "DiagnosticSignInfo" },
        Hint = { highlight = "DiagnosticSignHint" },
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
  {
    "lvimuser/lsp-inlayhints.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      inlay_hints = {
        only_current_line = true,
        max_len_align = true,
        highlight = "Comment",
      },
    },
    init = function()
      vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
      vim.api.nvim_create_autocmd("LspAttach", {
        group = "LspAttach_inlayhints",
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end

          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("lsp-inlayhints").on_attach(client, bufnr)
        end,
      })
    end,
  },
  {
    "folke/which-key.nvim", -- keymap helper for the memory deficient
    enabled = true,
    event = "VeryLazy",
    opts = {},
    config = function()
      -- Normal mode
      require("which-key").register({
        ["gP"] = { name = "Preview" },
        ["<leader>"] = {
          b = { name = "Buffers" },
          c = {
            name = "Cheat",
            q = { name = "Questions" },
            a = { name = "Answers" },
            h = { name = "History" },
            s = { name = "See also" },
          },
          -- d = { name = "Debug" },
          f = { name = "Find" },
          l = { name = "LSP" },
          s = { name = "Settings" },
          t = { name = "Tabs" },
          z = { name = "Zk" },
          g = {
            name = "Git",
            m = { name = "Mergetool" },
            t = { name = "Toggle options" },
            -- w = { name = "Worktree" },
          },
          o = {
            name = "Octo (GitHub)",
            i = { name = "Issues", D = { name = "Remove" }, a = { name = "Add" } },
            m = {
              name = "My stuff",
              i = { name = "Issues" },
              p = { name = "Pull requests" },
            },
            p = {
              name = "Pull requests",
              D = { name = "Remove" },
              a = { name = "Add" },
              r = { name = "Reviews" },
            },
            r = { name = "Reactions" },
          },
        },
      }, { mode = "n" })

      -- Visual mode
      require("which-key").register({
        ["<leader>"] = {
          g = { name = "Git", m = { name = "Mergetool" } },
          z = { name = "Zk" },
        },
      }, { mode = "x" })
    end,
  },
}
