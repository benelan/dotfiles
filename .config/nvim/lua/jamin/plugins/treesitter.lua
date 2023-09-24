return {
  {
    "ThePrimeagen/refactoring.nvim", -- common refactor actions and automated debug print statement generation
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    --stylua: ignore
    keys = {
      { "<leader>Rf", function() require("refactoring").refactor "Extract Function" end, desc = "Extract function", mode = "v" },
      { "<leader>RF", function() require("refactoring").refactor "Extract Function To File" end, desc = "Extract function to file", mode = "v" },
      { "<leader>Rv", function() require("refactoring").refactor "Extract Variable" end, desc = "Extract variable", mode = "v" },
      { "<leader>Ri", function() require("refactoring").refactor "Inline Variable" end, desc = "Inline variable", mode = "v" },
      { "<leader>Rb", function() require("refactoring").refactor "Extract Block" end, desc = "Extract block" },
      { "<leader>RB", function() require("refactoring").refactor "Extract Block To File" end, desc = "Extract block to file" },
      { "<leader>Ri", function() require("refactoring").refactor "Inline Variable" end, desc = "Inline variable" },
      { "<leader>Rr", function() require("refactoring").select_refactor { } end, desc = "Select refactor", mode = "v" },
      { "<leader>RP", function() require("refactoring").debug.printf { below = false } end, desc = "Print scope" },
      { "<leader>Rp", function() require("refactoring").debug.print_var { normal = true } end, desc = "Print variable" },
      { "<leader>Rp", function() require("refactoring").debug.print_var { } end, desc = "Print variable", mode = "v" },
      { "<leader>RC", function() require("refactoring").debug.cleanup { } end, desc = "Cleanup prints" },
    },
    opts = {
      prompt_func_return_type = { go = true },
      prompt_func_param_type = { go = true },
    },
  },
  -----------------------------------------------------------------------------
  {
    "Wansmer/treesj", -- split/join treesitter nodes to multiple/single line(s)
    dependencies = "nvim-treesitter/nvim-treesitter",
    keys = { { "<leader><Tab>", "<CMD>TSJToggle<CR>", desc = "SplitJoin" } },
    cmd = "TSJToggle",
    opts = { use_default_keymaps = false, max_join_length = 420 },
  },
  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter", -- syntax tree parser/highlighter engine
    version = false,
    build = ":TSUpdate",
    event = "VimEnter",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" }, -- more text objects
      { "JoosepAlviste/nvim-ts-context-commentstring" }, -- sets commentstring
      {
        "nvim-treesitter/nvim-treesitter-context", -- shows the current scope
        opts = {
          multiline_threshold = 5,
          mode = "cursor",
          -- separator = "─",
        },
        keys = {
          {
            "[C",
            function() require("treesitter-context").go_to_context() end,
            desc = "Treesitter context",
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
        ensure_installed = require("jamin.resources").treesitter_parsers,
        highlight = {
          enable = true,
          -- additional_vim_regex_highlighting = { "markdown" },
          -- disable = { "markdown", },
        },
        indent = { enable = true },
        query_linter = { enable = true },
        context_commentstring = { enable = true },
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
              ["ii"] = { query = "@conditional.inner", desc = "inner conditional" },
              ["as"] = { query = "@scope", query_group = "locals", "scope" },
              ["is"] = { query = "@scope", query_group = "locals", "inner scope" },
              ["agc"] = { query = "@comment.*", desc = "comment" },
              ["igc"] = { query = "@comment.*", desc = "comment" },
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = { query = "@function.outer", desc = "Next function start" },
              ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
              ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
              ["]gc"] = { query = "@comment.*", desc = "Next comment start" },
              ["]gs"] = { query = "@scope", query_group = "locals", desc = "Next scope start" },
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold start" },
            },
            goto_previous_start = {
              ["[f"] = { query = "@function.outer", desc = "Previous function start" },
              ["[i"] = { query = "@conditional.outer", desc = "Previous conditional start" },
              ["[l"] = { query = "@loop.outer", desc = "Previous loop start" },
              ["[gc"] = { query = "@comment.*", desc = "Previous comment start" },
              ["[gs"] = { query = "@scope", query_group = "locals", desc = "Previous scope start" },
              ["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold start" },
            },
            goto_next_end = {
              ["]F"] = { query = "@function.outer", desc = "Next function end" },
              ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
              ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
              ["]gC"] = { query = "@comment.*", desc = "Next comment end" },
            },
            goto_previous_end = {
              ["[F"] = { query = "@function.outer", desc = "Previous function end" },
              ["[I"] = { query = "@conditional.outer", desc = "Previous conditional end" },
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
