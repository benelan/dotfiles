local res = require "jamin.resources"

return {
  {
    "Wansmer/treesj", -- split/join treesitter nodes to multiple/single line(s)
    dependencies = "nvim-treesitter/nvim-treesitter",
    keys = { { "<leader><Tab>", "<CMD>TSJToggle<CR>", desc = "SplitJoin" } },
    cmd = "TSJToggle",
    opts = { use_default_keymaps = false, max_join_length = 420 },
  },
  -----------------------------------------------------------------------------
  {
    "windwp/nvim-ts-autotag", -- auto pair tags in html/jsx/vue/etc
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = { "astro", "html", "javascriptreact", "typescriptreact", "svelte", "vue", "xml" },
  },
  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter", -- syntax tree parser/highlighter engine
    version = false,
    build = ":TSUpdate",
    event = "BufReadPost",
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require "nvim-treesitter.query_predicates"
    end,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" }, -- more text objects
      {
        "JoosepAlviste/nvim-ts-context-commentstring", -- sets commentstring
        dependencies = "vim-commentary",
        init = function() vim.g.skip_ts_context_commentstring_module = true end,
        opts = {},
      },
      {
        "nvim-treesitter/nvim-treesitter-context", -- shows the current scope
        opts = {
          multiline_threshold = 1,
          max_lines = 6,
          mode = "cursor",
          -- separator = "─",
        },
        config = function(_, opts)
          require("treesitter-context").setup(opts)

          vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Normal" })
          vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "Normal" })
          vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { link = "Folded" })
        end,
        keys = {
          {
            "<leader>T",
            function() require("treesitter-context").go_to_context() end,
            desc = "Treesitter context",
          },
          {
            "<leader>sT",
            function() require("treesitter-context").toggle() end,
            desc = "Toggle treesitter context",
          },
        },
      },
    },
    config = function()
      local swap_next, swap_prev = (function()
        local swap_objects = {
          a = "@parameter.inner",
          f = "@function.outer",
          e = "@element",
          v = "@variable",
        }
        local n, p = {}, {}
        for key, obj in pairs(swap_objects) do
          n[string.format("]<M-%s>", key)] = obj
          p[string.format("[<M-%s>", key)] = obj
        end
        return n, p
      end)()

      require("nvim-treesitter.configs").setup {
        ensure_installed = res.treesitter_parsers,
        highlight = {
          enable = true,
          disable = function(lang, buf)
            local max_filesize = 420 * 1024 -- 420 KB
            local bufname = vim.api.nvim_buf_get_name(buf)
            local ok, stats = pcall(vim.uv.fs_stat, bufname) ---@diagnostic disable-line: undefined-field
            if ok and stats and stats.size > max_filesize then return true end
          end,
          -- additional_vim_regex_highlighting = { "markdown" },
          -- disable = { "markdown", },
        },
        indent = { enable = true },
        autotag = { enable = true },
        query_linter = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-n>", -- normal mode; the rest are visual
            node_incremental = "<C-n>",
            scope_incremental = "<C-s>",
            node_decremental = "<C-p>",
          },
        },
        textobjects = {
          lsp_interop = {
            enable = true,
            border = res.icons.border,
            peek_definition_code = {
              ["<leader>vf"] = "@function.outer",
              ["<leader>vc"] = "@class.outer",
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["aa"] = { query = "@parameter.outer", desc = "parameter" }, -- argument
              ["ia"] = { query = "@parameter.inner", desc = "inner parameter" },
              ["ac"] = { query = "@class.outer", desc = "class" },
              ["ic"] = { query = "@class.inner", desc = "inner class" },
              ["am"] = { query = "@function.outer", desc = "function" },
              ["im"] = { query = "@function.inner", desc = "inner function" },
              ["ao"] = { query = "@loop.outer", desc = "loop" },
              ["io"] = { query = "@loop.inner", desc = "inner loop" },
              ["ay"] = { query = "@conditional.outer", desc = "conditional" },
              ["iy"] = { query = "@conditional.inner", desc = "inner conditional" },
              ["agc"] = { query = "@comment.*", desc = "comment" },
              ["igc"] = { query = "@comment.*", desc = "comment" },
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = { query = "@function.outer", desc = "Next function start" },
              ["]y"] = { query = "@conditional.outer", desc = "Next conditional start" },
              ["]o"] = { query = "@loop.outer", desc = "Next loop start" },
              ["]gc"] = { query = "@comment.*", desc = "Next comment start" },
              ["]Z"] = { query = "@fold", query_group = "folds", desc = "Next fold start" },
            },
            goto_previous_start = {
              ["[m"] = { query = "@function.outer", desc = "Previous function start" },
              ["[y"] = { query = "@conditional.outer", desc = "Previous conditional start" },
              ["[o"] = { query = "@loop.outer", desc = "Previous loop start" },
              ["[gc"] = { query = "@comment.*", desc = "Previous comment start" },
              ["[Z"] = { query = "@fold", query_group = "folds", desc = "Previous fold start" },
            },
            goto_next_end = {
              ["]M"] = { query = "@function.outer", desc = "Next function end" },
              ["]Y"] = { query = "@conditional.outer", desc = "Next conditional end" },
              ["]O"] = { query = "@loop.outer", desc = "Next loop end" },
              ["]gC"] = { query = "@comment.*", desc = "Next comment end" },
            },
            goto_previous_end = {
              ["[M"] = { query = "@function.outer", desc = "Previous function end" },
              ["[Y"] = { query = "@conditional.outer", desc = "Previous conditional end" },
              ["[O"] = { query = "@loop.outer", desc = "Previous loop end" },
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
