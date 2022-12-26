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
if not status_ok then return end

-- Have packer use a popup window
packer.init {
  snapshot = table.concat({ vim.fn.stdpath "config", "snapshots", "nightly.json" }, "/"),
  snapshot_path = table.concat({ vim.fn.stdpath "config", "snapshots" }, "/"),
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
  git = {
    clone_timeout = 300, -- Timeout, in seconds, for git clones
  },
}


-- All the plugins are loaded below
-- The commits are hardcoded for stability
return packer.startup(function(use)
  -- Load these first
  use {
    "wbthomason/packer.nvim", -- packer manages itself
  }
  use {
    "nvim-lua/plenary.nvim", -- useful lua functions required by many plugins
  }
  use {
    "lewis6991/impatient.nvim", -- improves performance
    config = function() require "impatient" end -- load ASAP
  }

  -----------------------------------------------------------------------------
  -- UI
  -----------------------------------------------------------------------------
  use {
    "goolord/alpha-nvim", -- startup page/dashboard
    config = function() require "user.setups.alpha" end,
  }
  use {
    "kyazdani42/nvim-web-devicons", -- icons used by many plugins
  }
  use {
    "unblevable/quick-scope", -- highlight unique letters in words
  }
  use {
    "sainnhe/gruvbox-material", -- gruvbox colorscheme
    lock = true
  }
  use {
    "kyazdani42/nvim-tree.lua", -- tree-like file explorer
    event = "BufWinEnter",
    config = function() require "user.setups.nvim-tree" end,
    tag = "nightly"
  }
  use {
    "akinsho/bufferline.nvim", -- good lookin' bufferline
    event = "BufWinEnter",
    config = function() require "user.setups.bufferline" end
  }
  use {
    "nvim-lualine/lualine.nvim", -- extensible statusline
    event = "BufWinEnter",
    config = function() require "user.setups.lualine" end
  }
  use {
    "akinsho/toggleterm.nvim", -- opens an integrated terminal
    event = "BufWinEnter",
    config = function() require "user.setups.toggleterm" end
  }
  use {
    "iamcco/markdown-preview.nvim", -- opens markdown preview in browser
    run = "cd app && npm install",
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
  }
  use {
    "petertriho/nvim-scrollbar", -- adds scrollbar with lsp/git info
    event = "BufWinEnter",
    config = function() require "user.setups.scrollbar" end
  }

  -----------------------------------------------------------------------------
  -- Utils
  -----------------------------------------------------------------------------
  use {
    "windwp/nvim-autopairs", -- creates pairs for quotes, brackets, etc.
    event = "BufWinEnter",
    config = function() require "user.setups.autopairs" end
  }
  use {
    "numToStr/Comment.nvim", -- smart comments
    event = "BufWinEnter",
    config = function() require "user.setups.comment" end
  }
  -- use {
  -- "ahmedkhalf/project.nvim",
  -- }
  use {
    "lukas-reineke/indent-blankline.nvim", -- correctly indents blank lines
    event = "BufWinEnter",
    config = function() require "user.setups.indentline" end
  }
  use {
    "kylechui/nvim-surround", -- manipulate quotes/brackets/etc
    event = "BufWinEnter",
    tag = "*",
    config = function()
      require("nvim-surround").setup({
        highlight = {
          duration = 1
        }
      })
    end
  }
  use {
    "folke/which-key.nvim", -- keymap helper for the memory deficient
    event = "BufWinEnter",
    config = function() require "user.setups.which-key" end
  }
  use {
    "kevinhwang91/nvim-ufo", -- better code folds
    requires = "kevinhwang91/promise-async",
    event = "BufWinEnter",
    config = function() require "user.setups.ufo" end
  }
  use {
    "AndrewRadev/splitjoin.vim",
    event = "BufWinEnter",
    keys = { "gJ", "gS" },
  }

  -----------------------------------------------------------------------------
  -- Completions
  -----------------------------------------------------------------------------
  use {
    "hrsh7th/nvim-cmp", -- completion engine
    config = function() require "user.setups.cmp" end,
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
      }
    }
  }
  -----------------------------------------------------------------------------
  -- Snippets
  -----------------------------------------------------------------------------
  use {
    "L3MON4D3/LuaSnip", -- snippet engine
    tag = "v<CurrentMajor>.*",
    requires = {
      "rafamadriz/friendly-snippets", -- a bunch of snippets to use
    }
  }

  -----------------------------------------------------------------------------
  -- LSP
  -----------------------------------------------------------------------------
  use {
    "neovim/nvim-lspconfig", -- neovim's LSP implementation
    tag = "*",
  }
  use {
    "williamboman/mason.nvim", -- language server installer/manager
  }
  use {
    "williamboman/mason-lspconfig.nvim", -- integrates mason and lspconfig
  }
  use {
    "jose-elias-alvarez/null-ls.nvim", -- integrates formatters and linters
  }
  use { -- inlay hints
    "simrat39/inlay-hints.nvim",
    event = "BufWinEnter",
    config = function() require "user.setups.lsp.inlays" end
  }
  use {
    "RRethy/vim-illuminate", -- highlights hovered code blocks
    event = "BufWinEnter",
    config = function() require "user.setups.illuminate" end
  }
  use {
    "rmagatti/goto-preview", -- open lsp previews in floating window
    event = "BufWinEnter",
    config = function() require "user.setups.goto-preview" end
  }

  -----------------------------------------------------------------------------
  -- Telescope
  -----------------------------------------------------------------------------
  use {
    "nvim-telescope/telescope.nvim", -- fuzzy search tool
    event = "BufWinEnter",
    config = function() require "user.setups.telescope" end,
    requires = {
      {
        "nvim-telescope/telescope-fzf-native.nvim", -- fzf for telescope
        run = "make",
      },
      {
        "nvim-telescope/telescope-project.nvim", -- project bookmarks
      },
      -- {
      --   "nvim-telescope/telescope-frecency.nvim",
      --   requires = {
      --     "kkharji/sqlite.lua",
      --   }
      -- }
    }
  }

  -----------------------------------------------------------------------------
  -- Treesitter
  -----------------------------------------------------------------------------
  use {
    "nvim-treesitter/nvim-treesitter", -- no explanation needed 🏆
    event = "BufWinEnter",
    config = function() require "user.setups.treesitter" end,
    requires = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring", -- jsx/tsx comments
      },
      {
        "nvim-treesitter/nvim-treesitter-textobjects", -- more text objects
      }
    }
  }

  -----------------------------------------------------------------------------
  -- Git
  -----------------------------------------------------------------------------
  use {
    "lewis6991/gitsigns.nvim", -- git change indicators and blame
    event = "BufWinEnter",
    config = function() require "user.setups.gitsigns" end
  }
  use {
    "sindrets/diffview.nvim", -- diff and history viewer
    event = "BufWinEnter",
    config = function() require "user.setups.diffview" end
  }
  use {
    "pwntester/octo.nvim", -- GitHub integration - requires https://cli.github.com
    event = "BufWinEnter",
    config = function() require "user.setups.octo" end
  }
  use {
    "ruifm/gitlinker.nvim", -- Get GitHub/Gitlab/etc link for current line
    requires = "nvim-lua/plenary.nvim",
    config = function() require("gitlinker").setup() end,
  }

  -----------------------------------------------------------------------------
  -- Debugger Adapter
  -----------------------------------------------------------------------------
  use {
    "mfussenegger/nvim-dap",
    event = "BufWinEnter",
    config = function() require "user.setups.dap" end,
    requires = {
      {
        "theHamsta/nvim-dap-virtual-text",
      },
      {
        "rcarriga/nvim-dap-ui",
      },
    }
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
