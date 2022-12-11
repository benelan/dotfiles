local status_ok, _ = pcall(require, "nvim-treesitter")
local configs_status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not status_ok or not configs_status_ok then return end

treesitter_configs.setup({
  ensure_installed = {
    "bash",
    "css",
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
    "scss",
    "svelte",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vue",
    "yaml"
  },
  ignore_install = { "beancount" }, -- List of parsers to ignore installing
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
  },
  autopairs = {
    enable = true,
  },
  indent = { enable = true, disable = { "markdown_inline", } },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  -- incremental_selection = {
  --   enable = true,
  --   keymaps = {
  --     init_selection = '<c-space>',
  --     node_incremental = '<c-space>',
  --     scope_incremental = '<c-s>',
  --     node_decremental = '<c-backspace>',
  --   },
  -- },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['ai'] = '@conditional.outer',
        ['ii'] = '@conditional.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = { query = '@function.outer', desc = "Start of next function" },
        [']i'] = { query = '@conditional.outer', desc = "Start of next conditional" },
        [']l'] = { query = '@loop.outer', desc = "Start of next loop" },
      },
      goto_next_end = {
        [']M'] = { query = '@function.outer', desc = "End of next function" },
        [']I'] = { query = '@conditional.outer', desc = "End of next conditional" },
        [']L'] = { query = '@loop.outer', desc = "End of next loop" }
      },
      goto_previous_start = {
        ['[m'] = { query = '@function.outer', desc = "Start of previous function" },
        ['[i'] = { query = '@conditional.outer', desc = "Start of previous conditional" },
        ['[l'] = { query = '@loop.outer', desc = "Start of previous loop" },
      },
      goto_previous_end = {
        ['[M'] = { query = '@function.outer', desc = "End of previous function" },
        ['[I'] = { query = '@conditional.outer', desc = "End of previous conditional" },
        ['[L'] = { query = '@loop.outer', desc = "End of previous loop" },
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>Tl'] = { query = '@parameter.inner', desc = "Swap next parameter" },
      },
      swap_previous = {
        ['<leader>Th'] = { query = '@parameter.inner', desc = "Swap previous parameter" },
      },
    },
  }
})
