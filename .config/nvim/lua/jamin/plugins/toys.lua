local res = require "jamin.resources"

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
    "jinh0/eyeliner.nvim",
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
    "folke/trouble.nvim",
    -- enabled = false,
    opts = {
      icons = vim.g.use_devicons == true,
      fold_open = res.icons.ui.expanded,
      fold_closed = res.icons.ui.collapsed,
      indent_lines = false,
      use_diagnostic_signs = true,
    },
    cmd = { "TroubleToggle", "Trouble" },
    -- stylua: ignore
    keys = {
      { "<leader>xx", "<CMD>TroubleToggle document_diagnostics<CR>", desc = "Trouble document diagnostics" },
      { "<leader>xw", "<CMD>TroubleToggle workspace_diagnostics<CR>", desc = "Trouble workspace diagnostics" },
      { "<leader>xr", "<CMD>TroubleToggle lsp_references<CR>", desc = "Trouble LSP references" },
      { "<leader>xt", "<CMD>TroubleToggle lsp_type_definitions<CR>", desc = "Trouble LSP type definitions" },
      { "<leader>xd", "<CMD>TroubleToggle lsp_definitions<CR>", desc = "Trouble LSP definitions" },
      { "<leader>xq", "<CMD>TroubleToggle quickfix<CR>", desc = "Trouble quickfix" },
      { "<leader>xl", "<CMD>TroubleToggle loclist<CR>", desc = "Trouble loclist" },
    },
  },
  -----------------------------------------------------------------------------
  {
    "folke/which-key.nvim",
    -- enabled = false,
    event = "CursorHold",
    config = function()
      require("which-key").setup {
        icons = { separator = require("jamin.resources").icons.ui.prompt },
      }

      -- Normal mode
      require("which-key").register {
        ["g:"] = "External program operator",
        ["gc"] = "Comment operator",
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
          R = { name = "refactor" },
          E = {
            name = "ex",
            R = "Replace word under cursor",
            r = "Edit register",
            g = "Execute vimgrep",
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
            t = { name = "toggle options" },
            f = { name = "find" },
            m = { name = "mergetool" },
          },
          h = { name = "hunks" },
          o = {
            name = "octo (github)",
            r = { name = "reactions" },
            m = { name = "my stuff", i = { name = "issues" }, p = { name = "pull requests" } },
            i = { name = "issues", D = { name = "remove" }, a = { name = "add" } },
            p = {
              name = "pull requests",
              D = { name = "remove" },
              a = { name = "add" },
              r = { name = "reviews" },
            },
          },
        },
      }
      -- Visual mode
      require("which-key").register({
        ["<leader>"] = {
          ["<C-l>"] = "Redraw",
          y = "Copy to clipboard",
          p = "Paste to clipboard",
          d = "Delete to clipboard",
          r = "Replace operator",
          z = { name = "zk" },
          g = { name = "git", h = { name = "hunk" } },
        },
      }, { mode = "v" })

      -- Operator mode
      require("which-key").register({ V = "Last selection", B = "Whole buffer" }, { mode = "o" })
    end,
  },
}
