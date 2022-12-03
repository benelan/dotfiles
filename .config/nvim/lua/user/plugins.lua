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
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call to prevent error on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then return end

-- Have packer use a popup window
packer.init {
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
    commit = "6afb67460283f0e990d35d229fd38fdc04063e0a"
  }
  use {
    "nvim-lua/plenary.nvim", -- useful lua functions required by many plugins
    commit = "4b7e52044bbb84242158d977a50c4cbcd85070c7"
  }
  use {
    "lewis6991/impatient.nvim", -- improves performance
    commit = "d3dd30ff0b811756e735eb9020609fa315bfbbcc",
    config = function() require("impatient") end -- load ASAP
  }

  -----------------------------------------------------------------------------
  -- UI
  -----------------------------------------------------------------------------
  use {
    "goolord/alpha-nvim", -- startup page/dashboard
    commit = "0bb6fc0646bcd1cdb4639737a1cee8d6e08bcc31"
  }
  use {
    "kyazdani42/nvim-web-devicons", -- icons used by many plugins
    commit = "563f3635c2d8a7be7933b9e547f7c178ba0d4352"
  }
  use {
    "kyazdani42/nvim-tree.lua", -- tree-like file explorer
    commit = "be2ccd4b1a6077b53f8bfabf1e5c1775ca6dfbdc"
  }
  use {
    "akinsho/bufferline.nvim", -- good lookin' bufferline
    commit = "83bf4dc7bff642e145c8b4547aa596803a8b4dc4"
  }
  use {
    "nvim-lualine/lualine.nvim", -- extensible statusline
    commit = "a52f078026b27694d2290e34efa61a6e4a690621"
  }
  use {
    "akinsho/toggleterm.nvim", -- opens an integrated terminal
    commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda"
  }
  use {
    "sainnhe/gruvbox-material", -- gruvbox colorscheme
    commit = "2807579bd0a9981575dbb518aa65d3206f04ea02"
  }

  -----------------------------------------------------------------------------
  -- Utils
  -----------------------------------------------------------------------------
  use {
    "windwp/nvim-autopairs", -- creates pairs for quotes, brackets, etc.
    commit = "4fc96c8f3df89b6d23e5092d31c866c53a346347"
  }
  use {
    "numToStr/Comment.nvim", -- smart comments
    commit = "97a188a98b5a3a6f9b1b850799ac078faa17ab67"
  }
  -- use {
  -- "ahmedkhalf/project.nvim",
  -- commit = "628de7e433dd503e782831fe150bb750e56e55d6"
  -- }
  use {
    "lukas-reineke/indent-blankline.nvim", -- correctly indents blank lines
    commit = "db7cbcb40cc00fc5d6074d7569fb37197705e7f6"
  }
  use {
    "folke/which-key.nvim", -- keymap helper for the memory deficient
    commit = "61553aeb3d5ca8c11eea8be6eadf478062982ac9"
  }
  use {
    "kevinhwang91/nvim-ufo", -- better code folds
    requires = "kevinhwang91/promise-async",
    commit = "5da70eb121a890df8a5b25e6cc30d88665af97b8"
  }

  -----------------------------------------------------------------------------
  -- Completions
  -----------------------------------------------------------------------------
  use {
    "hrsh7th/nvim-cmp", -- completion engine
    commit = "b0dff0ec4f2748626aae13f011d1a47071fe9abc",
    requires = {
      {
        "hrsh7th/cmp-buffer", -- buffer completions
        commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa"
      },
      {
        "hrsh7th/cmp-path", -- path completions
        commit = "447c87cdd6e6d6a1d2488b1d43108bfa217f56e1"
      },
      {
        "saadparwaiz1/cmp_luasnip", -- snippet completions
        commit = "a9de941bcbda508d0a45d28ae366bb3f08db2e36"
      },
      {
        "hrsh7th/cmp-nvim-lsp", -- lsp completion
        commit = "affe808a5c56b71630f17aa7c38e15c59fd648a8"
      },
      {
        "hrsh7th/cmp-nvim-lua", -- lua language completion
        commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21"
      }
    }
  }
  -----------------------------------------------------------------------------
  -- Snippets
  -----------------------------------------------------------------------------
  use {
    "L3MON4D3/LuaSnip", -- snippet engine
    commit = "8f8d493e7836f2697df878ef9c128337cbf2bb84"
  }
  use {
    "rafamadriz/friendly-snippets", -- a bunch of snippets to use
    commit = "2be79d8a9b03d4175ba6b3d14b082680de1b31b1"
  }

  -----------------------------------------------------------------------------
  -- LSP
  -----------------------------------------------------------------------------
  use {
    "neovim/nvim-lspconfig", -- neovim's LSP implementation
    commit = "f11fdff7e8b5b415e5ef1837bdcdd37ea6764dda"
  }
  use {
    "williamboman/mason.nvim", -- language server installer/manager
    commit = "c2002d7a6b5a72ba02388548cfaf420b864fbc12"
  }
  use {
    "williamboman/mason-lspconfig.nvim", -- integrates mason and lspconfig
    commit = "0eb7cfefbd3a87308c1875c05c3f3abac22d367c"
  }
  use {
    "jose-elias-alvarez/null-ls.nvim", -- integrates formatters and linters
    commit = "c0c19f32b614b3921e17886c541c13a72748d450"
  }
  use {
    "RRethy/vim-illuminate", -- highlights hovered code blocks
    commit = "a2e8476af3f3e993bb0d6477438aad3096512e42"
  }

  -----------------------------------------------------------------------------
  -- Telescope
  -----------------------------------------------------------------------------
  use {
    "nvim-telescope/telescope.nvim", -- fuzzy search tool
    commit = "76ea9a898d3307244dce3573392dcf2cc38f340f",
    requires = {
      {
        "nvim-telescope/telescope-fzf-native.nvim", -- fzf for telescope
        commit = "65c0ee3d4bb9cb696e262bca1ea5e9af3938fc90",
        run = "make",
      },
      {
        "nvim-telescope/telescope-project.nvim", -- project bookmarks
        commit = "ff4d3cea905383a67d1a47b9dd210c4907d858c2",
      },
      -- {
      --   "nvim-telescope/telescope-frecency.nvim",
      --   commit = "10771fdb7b4c4b59f2b5c1e8757b0379e1314659",
      --   requires = {
      --     "kkharji/sqlite.lua",
      --     commit = "47685f0adb89928fc1b2a9b812418680f29aaf27"
      --   }
      -- }
    }
  }

  -----------------------------------------------------------------------------
  -- Treesitter
  -----------------------------------------------------------------------------
  use {
    "nvim-treesitter/nvim-treesitter", -- no explanation needed 🏆
    commit = "8e763332b7bf7b3a426fd8707b7f5aa85823a5ac",
    requires = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring", -- jsx/tsx comments
        commit = "32d9627123321db65a4f158b72b757bcaef1a3f4",
        after = "nvim-treesitter",
      },
      { -- Additional text objects
        "nvim-treesitter/nvim-treesitter-textobjects", -- more text objects
        after = "nvim-treesitter",
      }
    }
  }

  -----------------------------------------------------------------------------
  -- Git
  -----------------------------------------------------------------------------
  use {
    "lewis6991/gitsigns.nvim", -- git change indicators and blame
    commit = "f98c85e7c3d65a51f45863a34feb4849c82f240f",
  }
  use {
    "sindrets/diffview.nvim", -- diff and history viewer
    commit = "6a82dfcb59f0af1e814f34bf8344d68afe8618ec"
  }
  use {
    "pwntester/octo.nvim", -- GitHub integration - requires https://cli.github.com
    commit = "cde10054abcce9eb8d53347c88f7645888df19ea",
  }


  -----------------------------------------------------------------------------
  -- Debugger Adapter
  -----------------------------------------------------------------------------
  use {
    "mfussenegger/nvim-dap",
    commit = "8f396b7836b9bbda9edd9f655f12ca377ae97676",
    requires = {
      {
        "theHamsta/nvim-dap-virtual-text",
        commit = "2971ce3e89b1711cc26e27f73d3f854b559a77d4"
      },
      {
        "rcarriga/nvim-dap-ui",
        commit = "54365d2eb4cb9cfab0371306c6a76c913c5a67e3"
      },
    }
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
