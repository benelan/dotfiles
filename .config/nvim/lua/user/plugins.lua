-- Automatically install packer
local install_path = vim.fn.stdpath "data"
  .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = vim.fn.system {
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

-- Use a protected call to prevent error on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

packer.init {
  -- use snapshot as a semi-lockfile
  snapshot = table.concat(
    { vim.fn.stdpath "config", "snapshots", "nightly.json" },
    "/"
  ),
  snapshot_path = table.concat({ vim.fn.stdpath "config", "snapshots" }, "/"),
  display = {
    open_fn = function()
      return require("packer.util").float { border = "solid" }
    end,
  },
  git = { clone_timeout = 300 }, -- timeout is in seconds
}

-- All the plugins are loaded below
return packer.startup(function(use)
  use "wbthomason/packer.nvim" -- packer manages itself

  -----------------------------------------------------------------------------
  ----> General
  -----------------------------------------------------------------------------
  use { "vifm/vifm.vim", event = "BufWinEnter" } -- integrates vifm (file explorer)
  use { "unblevable/quick-scope", event = "BufWinEnter" } -- horiz motion highlights

  -- wezterm has built in nerd font glyphs, so no patched fonts are required
  if vim.g.use_devicons == true then
    use "nvim-tree/nvim-web-devicons"
  end

  -- use the local fzf plugin if it's installed
  if vim.fn.isdirectory(os.getenv "HOME" .. "/.dotfiles/vendor/fzf/") then
    use { "~/.dotfiles/vendor/fzf", cmd = "FZF" }
  end

  -----------------------------------------------------------------------------
  ----> Completion/Snippets
  -----------------------------------------------------------------------------
  use {
    "hrsh7th/nvim-cmp", -- completion engine
    config = function()
      require "user.setups.cmp"
    end,
    requires = {
      "hrsh7th/cmp-buffer", -- buffer completions
      "hrsh7th/cmp-cmdline", -- commandline completion
      "hrsh7th/cmp-nvim-lsp", -- lsp completion
      "hrsh7th/cmp-nvim-lsp-signature-help", -- signature completions
      "hrsh7th/cmp-nvim-lua", -- lua language completion
      "hrsh7th/cmp-path", -- path completions
      "saadparwaiz1/cmp_luasnip", -- snippet completions
      --   "folke/neodev.nvim", -- NeoVim Lua API info
      {
        "L3MON4D3/LuaSnip", -- snippet engine
        tag = "v1.*",
        requires = {
          "rafamadriz/friendly-snippets", -- a bunch of snippets to use
        },
      },
    },
  }

  -- use "Exafunction/codeium.vim"

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
        requires = { "nvim-lua/plenary.nvim" },
      },
      {
        "williamboman/mason.nvim", -- language server installer/manager
        "williamboman/mason-lspconfig.nvim", -- integrates mason and lspconfig
      },
    },
  }

  use {
    "rmagatti/goto-preview", -- open lsp previews in floating window
    module = "goto-preview",
    config = function()
      require("goto-preview").setup {}
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
      --   "ThePrimeagen/git-worktree.nvim", -- Git worktree helper for bare repos
    },
  }

  -----------------------------------------------------------------------------
  ----> Treesitter
  -----------------------------------------------------------------------------
  use {
    "nvim-treesitter/nvim-treesitter", -- syntax tree parser/highlighter engine
    run = ":TSUpdate",
    config = function()
      require "user.setups.treesitter"
    end,
  }
  use {
    {
      "nvim-treesitter/nvim-treesitter-textobjects", -- more text objects
      event = "BufWinEnter",
      after = "nvim-treesitter",
    },
    {
      "RRethy/nvim-treesitter-textsubjects",
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
    {
      "nvim-treesitter/nvim-treesitter-context", -- shows the current scope
      event = "BufWinEnter",
      after = "nvim-treesitter",
    },
    -- {
    --   "nvim-treesitter/playground", -- for creating syntax queries
    --   event = "BufWinEnter",
    --   after = "nvim-treesitter",
    -- },
    {
      "Wansmer/treesj",
      after = "nvim-treesitter",
      cmd = { "TSJToggle" },
      config = function()
        require("treesj").setup {
          use_default_keymaps = false,
        }
      end,
    },
  }

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
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require "user.setups.diffview"
    end,
  }
  use {
    "pwntester/octo.nvim", -- GitHub integration - requires https://cli.github.com
    requires = { "nvim-lua/plenary.nvim" },
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
  -- use {
  --   "mfussenegger/nvim-dap",
  --   module = "dap",
  --   cmd = {
  --     "DapContinue",
  --     "DapLoadLaunchFromJSON",
  --     "DapToggleBreakpoint",
  --     "DapToggleRepl",
  --     "DapShowLog",
  --   },
  --   config = function()
  --     require "user.setups.dap"
  --   end,
  --   requires = { "theHamsta/nvim-dap-virtual-text", "rcarriga/nvim-dap-ui" },
  -- }

  -----------------------------------------------------------------------------
  ----> Notes/Writing
  -----------------------------------------------------------------------------
  use {
    "mickael-menu/zk-nvim", -- Requires https://github.com/mickael-menu/zk
    config = function() --
      require("zk").setup { picker = "telescope" }
    end,
  }

  use {
    "iamcco/markdown-preview.nvim", -- opens markdown preview in browser
    run = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    cmd = { "MarkdownPreviewToggle" },
    ft = { "markdown" },
  }

  -----------------------------------------------------------------------------

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
