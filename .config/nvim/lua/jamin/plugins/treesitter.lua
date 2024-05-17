local res = require("jamin.resources")

return {
  -- split/join treesitter nodes to multiple/single line(s)
  {
    "Wansmer/treesj",
    dependencies = "nvim-treesitter/nvim-treesitter",
    keys = { { "<leader><Tab>", "<CMD>TSJToggle<CR>", desc = "SplitJoin" } },
    cmd = "TSJToggle",
    opts = { use_default_keymaps = false, max_join_length = 420 },
  },

  -----------------------------------------------------------------------------
  -- auto pair tags in html/jsx/vue/etc
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = { "astro", "html", "javascriptreact", "typescriptreact", "svelte", "vue", "xml" },
  },

  -----------------------------------------------------------------------------
  -- more text objects
  { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },

  -----------------------------------------------------------------------------
  -- shows the current scope
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = true,
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
        "<leader>stc",
        function() require("treesitter-context").toggle() end,
        desc = "Toggle treesitter context",
      },
    },
  },

  -----------------------------------------------------------------------------
  -- syntax tree parser/highlighter engine
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    event = "BufReadPost",
    -- https://github.com/LazyVim/LazyVim/blob/ae6d8f1a34fff49f9f1abf9fdd8a559c95b85cf3/lua/lazyvim/plugins/treesitter.lua#L10-L19
    lazy = vim.fn.argc(-1) == 0,
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,

    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        init = function() vim.g.skip_ts_context_commentstring_module = true end,
        opts = { enable_autocmd = false },
        config = function(_, opts)
          require("ts_context_commentstring").setup(opts)
          local get_option = vim.filetype.get_option
          ---@diagnostic disable-next-line: duplicate-set-field
          vim.filetype.get_option = function(filetype, option)
            return option == "commentstring"
                and require("ts_context_commentstring.internal").calculate_commentstring()
              or get_option(filetype, option)
          end
        end,
      },
    },

    opts = function()
      local swap_next, swap_prev = (function()
        local n, p = {}, {}
        local swap_objects = {
          a = "@parameter.inner",
          m = "@function.outer",
          e = "@element",
          v = "@variable",
        }

        for key, obj in pairs(swap_objects) do
          n[string.format("]<M-%s>", key)] = obj
          p[string.format("[<M-%s>", key)] = obj
        end

        return n, p
      end)()

      return {
        ensure_installed = res.treesitter_parsers,
        indent = { enable = true },
        autotag = { enable = true },
        query_linter = { enable = true },

        highlight = {
          enable = true,
          disable = function(lang, buf) ---@diagnostic disable-line: unused-local
            local max_filesize = 420 * 1024 -- 420 KB
            local bufname = vim.api.nvim_buf_get_name(buf)
            local ok, stats = pcall(vim.uv.fs_stat, bufname)
            if ok and stats and stats.size > max_filesize then return true end
          end,
          -- additional_vim_regex_highlighting = { "markdown" },
          -- disable = { "markdown", },
        },

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

    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      vim.schedule(
        function()
          require("lazy").load({
            plugins = { "nvim-treesitter-textobjects", "nvim-treesitter-context" },
          })
        end
      )
    end,
  },
}
