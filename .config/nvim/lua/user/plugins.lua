local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Reloads neovim when saving this file
-- vim.cmd [[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerSync
--   augroup end
-- ]]

-- Use a protected call to prevent error on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  snapshot = table.concat({ vim.fn.stdpath "config", "snapshots", "nightly.json" }, "/"),
  snapshot_path = table.concat({ vim.fn.stdpath "config", "snapshots" }, "/"),
  display = {
    open_fn = function()
      return require("packer.util").float { border = "solid" }
    end,
  },
  git = {
    clone_timeout = 300, -- Timeout, in seconds, for git clones
  },
}

-- All the plugins are loaded below
return packer.startup(function(use)
  -- Load these first
  use {
    "wbthomason/packer.nvim", -- packer manages itself
  }
  use {
    "nvim-lua/plenary.nvim", -- useful lua functions required by many plugins
  }

  -----------------------------------------------------------------------------
  ----> UI
  -----------------------------------------------------------------------------
  -- if os.getenv "OG_TERM" == "wezterm" or os.getenv("OG_TERM"):find "kitty" then
    use "nvim-tree/nvim-web-devicons"
  -- end

  use {
    "goolord/alpha-nvim", -- startup page/dashboard
    config = function()
      require "user.setups.alpha"
    end,
  }
  use {
    "unblevable/quick-scope", -- highlight unique letters in words
  }
  use {
    "sainnhe/gruvbox-material", -- gruvbox colorscheme
  }
  use {
    "iamcco/markdown-preview.nvim", -- opens markdown preview in browser
    run = "cd app && npm install",
    event = "BufWinEnter",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  }
  use {
    "lukas-reineke/indent-blankline.nvim", -- visualize indents
    event = "BufWinEnter",
    config = function()
      require "user.setups.indentline"
    end,
  }

  -----------------------------------------------------------------------------
  ----> Utils
  -----------------------------------------------------------------------------
  use {
    "numToStr/Comment.nvim", -- smart comments
    event = "BufWinEnter",
    config = function()
      require "user.setups.comment"
    end,
  }
  use {
    "kylechui/nvim-surround", -- manipulate quotes/brackets/etc
    event = "BufWinEnter",
    tag = "*",
    config = function()
      require("nvim-surround").setup {
        highlight = { duration = 1 },
      }
    end,
  }
  use {
    "AndrewRadev/splitjoin.vim", -- split/join lines on arrays/objects/etc
    event = "BufWinEnter",
    keys = { "gJ", "gS" },
  }
  use {
    "mbbill/undotree", -- Easily go back in undo history
    event = "BufWinEnter",
    config = function()
      vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", {
        silent = true,
        noremap = true,
        desc = "UndoTree",
      })
    end,
  }

  use {
    "rmagatti/session-lens",
    requires = {
      {
        "rmagatti/auto-session",
        config = function()
          require("auto-session").setup {
            -- auto_session_use_git_branch = true,
            bypass_session_save_file_types = require("user.resources").exclude_filetypes,
            auto_session_create_enabled = false,
          }
        end,
      },
      "nvim-telescope/telescope.nvim",
    },
  }

  -----------------------------------------------------------------------------
  ----> Completions
  -----------------------------------------------------------------------------
  use {
    "hrsh7th/nvim-cmp", -- completion engine
    config = function()
      require "user.setups.cmp"
    end,
    requires = {
      {
        "hrsh7th/cmp-buffer", -- buffer completions
      },
      {
        "hrsh7th/cmp-path", -- path completions
      },
      {
        "saadparwaiz1/cmp_luasnip", -- snippet completions
      },
      {
        "hrsh7th/cmp-nvim-lsp", -- lsp completion
      },
      {
        "hrsh7th/cmp-nvim-lua", -- lua language completion
      },
      {
        "hrsh7th/cmp-nvim-lsp-signature-help", -- signature completions
      },
      {
        "hrsh7th/cmp-cmdline", -- commandline completion
      },
      {
        "folke/neodev.nvim", -- NeoVim Lua API info
      },
    },
  }

  -- use {
  --   "Exafunction/codeium.vim",
  --   config = function()
  --     vim.keymap.set("i", "<M-y>", function()
  --       return vim.fn["codeium#Accept"]()
  --     end, { expr = true, noremap = true, silent = true, desc = "Codeium Accept" })
  --     vim.keymap.set("i", "<M-c>", function()
  --       return vim.fn["codeium#Complete"]()
  --     end, {
  --       expr = true,
  --       noremap = true,
  --       silent = true,
  --       desc = "Codeium Complete",
  --     })
  --     vim.keymap.set("i", "<M-n>", function()
  --       return vim.fn["codeium#CycleCompletions"](1)
  --     end, { expr = true, noremap = true, silent = true, desc = "Codeium Next" })
  --     vim.keymap.set("i", "<M-p>", function()
  --       return vim.fn["codeium#CycleCompletions"](-1)
  --     end, {
  --       expr = true,
  --       noremap = true,
  --       silent = true,
  --       desc = "Codeium Previous",
  --     })
  --     vim.keymap.set("i", "<M-e>", function()
  --       return vim.fn["codeium#Clear"]()
  --     end, { expr = true, noremap = true, silent = true, desc = "Codeium Clear" })
  --   end,
  -- }
  --
  -----------------------------------------------------------------------------
  ----> Snippets
  -----------------------------------------------------------------------------
  use {
    "L3MON4D3/LuaSnip", -- snippet engine
    tag = "v1.*",
    requires = {
      "rafamadriz/friendly-snippets", -- a bunch of snippets to use
    },
  }

  -----------------------------------------------------------------------------
  ----> LSP
  -----------------------------------------------------------------------------
  use {
    "neovim/nvim-lspconfig", -- neovim's LSP implementation
    config = function()
      require "user.lsp"
    end,
    requires = {
      {
        "jose-elias-alvarez/null-ls.nvim", -- integrates formatters and linters
      },
      {
        "williamboman/mason.nvim", -- language server installer/manager
      },
      {
        "williamboman/mason-lspconfig.nvim", -- integrates mason and lspconfig
      },
    },
  }
  use {
    "simrat39/inlay-hints.nvim", -- inlay hints
    config = function()
      require "user.lsp.inlays"
    end,
  }
  use {
    "rmagatti/goto-preview", -- open lsp previews in floating window
    config = function()
      require "user.lsp.goto-preview"
    end,
  }
  use {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig",
    config = function()
      require "user.lsp.navic"
    end,
  }

  -----------------------------------------------------------------------------
  ----> Telescope
  -----------------------------------------------------------------------------
  use {
    "nvim-telescope/telescope.nvim", -- fuzzy search tool
    config = function()
      require "user.setups.telescope"
    end,
    requires = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim", -- fzf for telescope
        run = "make",
      },
      {
        "nvim-telescope/telescope-project.nvim", -- project bookmarks
      },
      {
        "nvim-telescope/telescope-file-browser.nvim", -- file browser
      },
      {
        "ThePrimeagen/git-worktree.nvim", -- Git worktree helper for bare repos
        -- config = function() require("git-worktree").setup() end,
      },
    },
  }

  -----------------------------------------------------------------------------
  ----> Treesitter
  -----------------------------------------------------------------------------
  use {
    "nvim-treesitter/nvim-treesitter", -- syntax tree parser/highlighter engine
    run = ":TSUpdate",
    module_pattern = "treesitter.*",
    config = function()
      require "user.setups.treesitter"
    end,
    requires = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects", -- more text objects
        event = "BufWinEnter",
        after = "nvim-treesitter",
      },
      {
        "JoosepAlviste/nvim-ts-context-commentstring", -- jsx/tsx comments
        event = "BufWinEnter",
        after = "nvim-treesitter",
      },
      {
        "windwp/nvim-ts-autotag", -- auto pair tags in html/jsx/vue/etc
        event = "InsertEnter",
        after = "nvim-treesitter",
      },
      -- {
      --   "windwp/nvim-autopairs", -- creates pairs for quotes, brackets, etc.
      --   event = "InsertEnter",
      --   after = "nvim-treesitter",
      --   config = function()
      --     require "user.setups.autopairs"
      --   end,
      -- },
      -- { -- trying out nvim-navic instead
      --   "nvim-treesitter/nvim-treesitter-context", -- shows the current scope
      --   event = "BufWinEnter",
      --   after = "nvim-treesitter",
      -- },
      -- {
      --   "nvim-treesitter/playground", -- for creating syntax queries
      --   event = "BufWinEnter",
      --   after = "nvim-treesitter",
      -- },
    },
  }

  -- use {
  -- }

  -----------------------------------------------------------------------------
  ----> Git
  -----------------------------------------------------------------------------

  use {
    "lewis6991/gitsigns.nvim", -- git change indicators and blame
    config = function()
      require "user.setups.gitsigns"
    end,
  }
  use {
    "sindrets/diffview.nvim", -- diff and history viewer
    config = function()
      require "user.setups.diffview"
    end,
  }
  use {
    "pwntester/octo.nvim", -- GitHub integration - requires https://cli.github.com
    config = function()
      require "user.setups.octo"
    end,
  }
  use {
    "tpope/vim-fugitive", -- Git integration
    requires = {
      "tpope/vim-rhubarb", -- Open file/selection in GitHub repo
    },
  }

  -----------------------------------------------------------------------------
  ----> Debug Adapter
  -----------------------------------------------------------------------------
  use {
    "mfussenegger/nvim-dap",
    module = "dap",
    cmd = {
      "DapContinue",
      "DapLoadLaunchFromJSON",
      "DapToggleBreakpoint",
      "DapToggleRepl",
      "DapShowLog",
    },
    config = function()
      require "user.setups.dap"
    end,
    requires = { "theHamsta/nvim-dap-virtual-text", "rcarriga/nvim-dap-ui" },
  }

  -----------------------------------------------------------------------------
  ----> Note Taking
  -----------------------------------------------------------------------------

  use {
    "mickael-menu/zk-nvim", -- Requires https://github.com/mickael-menu/zk
    requires = {
      "renerocksai/telekasten.nvim",
      requires = { "nvim-telescope/telescope.nvim", "renerocksai/calendar-vim" },
    },
    config = function() --
      require "user.setups.notes"
    end,
  }

  -- NOTE-able mentions for other methods I explored before landing on Zettelkasten
  ---- VimWiki and its Taskwarrior integration
  ------ https://github.com/vimwiki/vimwiki
  ------ https://github.com/tools-life/taskwiki
  ---- Emac's Org Mode clones/iterations for NeoVim
  ------ https://github.com/nvim-neorg/neorg
  ------ https://github.com/nvim-orgmode/orgmode

  -----------------------------------------------------------------------------
  ----> Keymaps
  -----------------------------------------------------------------------------
  use {
    "folke/which-key.nvim", -- keymap helper for the memory deficient
    config = function()
      require "user.setups.which-key"
    end,
  }

  -----------------------------------------------------------------------------
  ----> Local
  -----------------------------------------------------------------------------

  if fn.isdirectory "~/.dotfiles/vendor/fzf" then
    use "~/.dotfiles/vendor/fzf" -- use the local fzf plugin if it's installed
  end

  -----------------------------------------------------------------------------

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
