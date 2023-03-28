return {
  "nvim-treesitter/nvim-treesitter", -- syntax tree parser/highlighter engine
  version = false,
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects", -- more text objects
      event = "VeryLazy",
    },
    { "RRethy/nvim-treesitter-textsubjects", event = "VeryLazy" },
    {
      "JoosepAlviste/nvim-ts-context-commentstring", -- jsx/tsx comments
      event = "VeryLazy",
    },
    {
      "windwp/nvim-ts-autotag", -- auto pair tags in html/jsx/vue/etc
      event = "InsertEnter",
    },
    {
      "nvim-treesitter/nvim-treesitter-context", -- shows the current scope
      event = "VeryLazy",
    },
    {
      "nvim-treesitter/playground", -- for creating syntax queries
      cmd = "TSPlaygroundToggle",
      enabled = false,
    },
    {
      "Wansmer/treesj",
      keys = { { "<leader><Tab>", "<cmd>TSJToggle<cr>", desc = "Join Toggle" } },
      cmd = "TSJToggle",
      opts = { use_default_keymaps = false, max_join_length = 300 },
    },
  },
  config = function()
    local swap_next, swap_prev = (function()
      local swap_objects = {
        a = "@parameter.inner",
        f = "@function.outer",
        e = "@element",
        -- v = "@variable",
      }
      local n, p = {}, {}
      for key, obj in pairs(swap_objects) do
        n[string.format("]<M-%s>", key)] = obj
        p[string.format("[<M-%s>", key)] = obj
      end
      return n, p
    end)()

    require("nvim-treesitter.configs").setup {
      ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "git_rebase",
        "gitcommit",
        -- "gitignore",
        "go",
        "graphql",
        "help",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rust",
        "scss",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vue",
        "yaml",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown", "mdx" },
      },
      autopairs = { enable = true },
      autotag = { enable = true },
      playground = { enable = true },
      context_commentstring = { enable = true, enable_autocmd = false },
      textsubjects = {
        enable = true,
        prev_selection = ",",
        keymaps = {
          [";"] = "textsubjects-smart",
          ["."] = "textsubjects-container-outer",
          ["i."] = "textsubjects-container-inner",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["aa"] = "@parameter.outer", -- argument
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ai"] = "@conditional.outer", -- if
            ["ii"] = "@conditional.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = {
              query = "@function.outer",
              desc = "Start of next function",
            },
            ["]i"] = {
              query = "@conditional.outer",
              desc = "Start of next conditional",
            },
            ["]l"] = { query = "@loop.outer", desc = "Start of next loop" },
          },
          goto_next_end = {
            ["]M"] = {
              query = "@function.outer",
              desc = "End of next function",
            },
            ["]I"] = {
              query = "@conditional.outer",
              desc = "End of next conditional",
            },
            ["]L"] = { query = "@loop.outer", desc = "End of next loop" },
          },
          goto_previous_start = {
            ["[m"] = {
              query = "@function.outer",
              desc = "Start of previous function",
            },
            ["[i"] = {
              query = "@conditional.outer",
              desc = "Start of previous conditional",
            },
            ["[l"] = { query = "@loop.outer", desc = "Start of previous loop" },
          },
          goto_previous_end = {
            ["[M"] = {
              query = "@function.outer",
              desc = "End of previous function",
            },
            ["[I"] = {
              query = "@conditional.outer",
              desc = "End of previous conditional",
            },
            ["[L"] = { query = "@loop.outer", desc = "End of previous loop" },
          },
        },
        swap = {
          enable = true,
          swap_next = swap_next,
          swap_previous = swap_prev,
        },
      },
    }
  end,
}
