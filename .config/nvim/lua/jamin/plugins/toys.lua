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
    "folke/which-key.nvim",
    -- enabled = false,
    event = "CursorHold",
    config = function()
      require("which-key").setup {
        icons = { separator = require("jamin.resources").icons.ui.select },
      }

      -- Normal mode
      require("which-key").register {
        ["g:"] = "Command operator",
        ["gc"] = "Comment operator",
        ["gs"] = "Substitute operator",
        ["]S"] = "Fix next misspelled word",
        ["[S"] = "Fix previous misspelled word",
        ["]x"] = "Next git conflict marker",
        ["[x"] = "Previous git conflict marker",
        ["<leader>"] = {
          ["<C-l>"] = "Redraw",
          ["<Del>"] = "Delete buffer",
          E = {
            name = "ex",
            R = "Replace word under cursor",
            r = "Edit register",
            g = "Execute vimgrep",
          },
          R = { name = "refactor" },
          Y = "Copy to clipboard (EOL)",
          Z = "Zoom buffer",
          d = { name = "docs" },
          f = { name = "find", z = { name = "fzf" } },
          g = { name = "git", t = { name = "toggle options" }, f = { name = "find" } },
          h = { name = "hunks" },
          l = { name = "lsp" },
          m = { name = "mergetool" },
          o = {
            name = "octo (github)",
            m = { name = "my stuff", i = { name = "issues" }, p = { name = "pull requests" } },
          },
          p = "Paste to clipboard",
          s = { name = "settings" },
          t = { name = "tabs" },
          u = "Undotree",
          y = "Copy to clipboard",
          z = { name = "zk" },
        },
      }
      -- Visual mode
      require("which-key").register({
        ["gc"] = "Comment operator",
        ["gs"] = "Substitute operator",
        ["<leader>"] = {
          ["<C-l>"] = "Redraw",
          R = { name = "refactor" },
          d = "Delete to black hole",
          g = { name = "git" },
          h = { name = "hunks" },
          m = { name = "mergetool" },
          p = "Paste from clipboard",
          y = "Copy to clipboard",
          z = { name = "zk" },
        },
      }, { mode = "v" })

      -- Operator mode
      require("which-key").register({ V = "Last selection", B = "Whole buffer" }, { mode = "o" })
    end,
  },
}
