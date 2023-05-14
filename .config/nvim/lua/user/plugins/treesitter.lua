return {
  {
    "nvim-treesitter/nvim-treesitter-context", -- shows the current scope
    "nvim-treesitter/nvim-treesitter-textobjects", -- more text objects
    "RRethy/nvim-treesitter-textsubjects", -- smart text objects
    "JoosepAlviste/nvim-ts-context-commentstring", -- jsx/tsx comments
    event = "VeryLazy",
  },
  {
    "windwp/nvim-ts-autotag", -- auto pair tags in html/jsx/vue/etc
    event = "InsertEnter",
  },
  {
    "Wansmer/treesj",
    keys = { { "<leader><Tab>", "<cmd>TSJToggle<cr>", desc = "JoinToggle" } },
    cmd = "TSJToggle",
    opts = { use_default_keymaps = false, max_join_length = 300 },
  },
  {
    "nvim-treesitter/playground", -- for creating syntax queries
    enabled = false,
    cmd = "TSPlaygroundToggle",
  },
  {
    "nvim-treesitter/nvim-treesitter", -- syntax tree parser/highlighter engine
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
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
          "astro",
          "bash",
          "css",
          "diff",
          "dockerfile",
          "git_rebase",
          "gitcommit",
          "gitignore",
          "go",
          "graphql",
          "html",
          "http",
          "javascript",
          "jsdoc",
          "json",
          "jsonc",
          "latex",
          "lua",
          "luap",
          "markdown",
          "markdown_inline",
          "php",
          "python",
          "query",
          "regex",
          "rust",
          "scss",
          "sql",
          "svelte",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "vue",
          "yaml",
        },
        highlight = {
          enable = true,
          -- additional_vim_regex_highlighting = { "markdown" },
          -- disable = { "markdown", },
        },
        indent = { enable = true },
        autopairs = { enable = true },
        autotag = { enable = true },
        playground = { enable = true },
        context_commentstring = { enable = true, enable_autocmd = false },
        textsubjects = {
          enable = true,
          prev_selection = ",",
          keymaps = {
            [";"] = "textsubjects-smart",
            ["a;"] = "textsubjects-container-outer",
            ["i;"] = "textsubjects-container-inner",
          },
        },
        textobjects = {
          lsp_interop = {
            enable = true,
            border = "solid",
            peek_definition_code = {
              ["gpf"] = "@function.outer",
              ["gpc"] = "@class.outer",
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["aa"] = { query = "@parameter.outer", desc = "parameter" }, -- argument
              ["ia"] = { query = "@parameter.inner", desc = "inner parameter" },
              ["af"] = { query = "@function.outer", desc = "function" },
              ["if"] = { query = "@function.inner", desc = "inner function" },
              ["al"] = { query = "@loop.outer", desc = "loop" },
              ["il"] = { query = "@loop.inner", desc = "inner loop" },
              ["ac"] = { query = "@class.outer", desc = "class" },
              ["ic"] = { query = "@class.inner", desc = "inner class" },
              ["ai"] = { query = "@conditional.outer", desc = "conditional" }, -- if
              ["ii"] = {
                query = "@conditional.inner",
                desc = "inner conditional",
              },
              ["as"] = { query = "@scope", query_group = "locals", "scope" },
              ["is"] = {
                query = "@scope",
                query_group = "locals",
                "inner scope",
              },
              ["agc"] = { query = "@comment.*", desc = "comment" },
              ["igc"] = { query = "@comment.*", desc = "comment" },
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = {
                query = "@function.outer",
                desc = "Next function start",
              },
              ["]i"] = {
                query = "@conditional.outer",
                desc = "Next conditional start",
              },
              ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
              ["]gc"] = { query = "@comment.*", desc = "Next comment start" },
              ["]gs"] = {
                query = "@scope",
                query_group = "locals",
                desc = "Next scope start",
              },
              ["]z"] = {
                query = "@fold",
                query_group = "folds",
                desc = "Next fold start",
              },
            },
            goto_previous_start = {
              ["[f"] = {
                query = "@function.outer",
                desc = "Previous function start",
              },
              ["[i"] = {
                query = "@conditional.outer",
                desc = "Previous conditional start",
              },
              ["[l"] = { query = "@loop.outer", desc = "Previous loop start" },
              ["[gc"] = {
                query = "@comment.*",
                desc = "Previous comment start",
              },
              ["[gs"] = {
                query = "@scope",
                query_group = "locals",
                desc = "Previous scope start",
              },
              ["[z"] = {
                query = "@fold",
                query_group = "folds",
                desc = "Previous fold start",
              },
            },
            goto_next_end = {
              ["]F"] = { query = "@function.outer", desc = "Next function end" },
              ["]I"] = {
                query = "@conditional.outer",
                desc = "Next conditional end",
              },
              ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
              ["]gC"] = { query = "@comment.*", desc = "Next comment end" },
            },
            goto_previous_end = {
              ["[F"] = {
                query = "@function.outer",
                desc = "Previous function end",
              },
              ["[I"] = {
                query = "@conditional.outer",
                desc = "Previous conditional end",
              },
              ["[L"] = { query = "@loop.outer", desc = "Previous loop end" },
              ["[gC"] = { query = "@comment.*", desc = "Previous comment end" },
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
  },
}
