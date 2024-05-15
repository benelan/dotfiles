local res = require("jamin.resources")

return {
  -- split/join treesitter nodes to multiple/single line(s)
  {
    "Wansmer/treesj",
    dependencies = "nvim-treesitter/nvim-treesitter",
    cmd = "TSJToggle",
    keys = { { "<leader><Tab>", "<CMD>TSJToggle<CR>", desc = "SplitJoin" } },
    opts = { use_default_keymaps = false, max_join_length = 420 },
  },

  -----------------------------------------------------------------------------
  -- shows the current scope
  {
    "nvim-treesitter/nvim-treesitter-context",
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
        "<leader>C",
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
    event = "BufReadPost",
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,

    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        init = function() vim.g.skip_ts_context_commentstring_module = true end,
        opts = {},
      },
    },

    opts = {
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
    },

    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      vim.schedule(function() require("lazy").load({ plugins = { "nvim-treesitter-context" } }) end)
    end,
  },
}
