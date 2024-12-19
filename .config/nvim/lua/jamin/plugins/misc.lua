---Plugins that don't fit in one of the other categories

local res = require("jamin.resources")

---@type LazySpec
return {
  -----------------------------------------------------------------------------
  -- keymaps/autocmds/utils/etc from my vim config (too lazy to lua-ify everything)
  {
    dir = "~/.vim",
    priority = 90,
    enabled = vim.fn.isdirectory(vim.fs.normalize("~/.vim")) == 1,
    lazy = false,
    vscode = true,
  },

  -----------------------------------------------------------------------------
  -- helps visualize and navigate the undo tree - see :h undo-tree
  {
    dir = "~/.vim/pack/foo/opt/undotree",
    enabled = vim.fn.isdirectory(vim.fs.normalize("~/.vim/pack/foo/opt/undotree")) == 1,
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<CMD>UndotreeToggle<CR>" } },
    init = function() vim.g.undotree_SetFocusWhenToggle = 1 end,
  },

  -----------------------------------------------------------------------------
  -- adds basic filesystem commands and some shebang utils
  {
    dir = "~/.vim/pack/foo/start/vim-eunuch",
    enabled = vim.fn.isdirectory(vim.fs.normalize("~/.vim/pack/foo/start/vim-eunuch")) == 1,
    event = "BufNewFile",
    -- stylua: ignore
    cmd = {
      "Cfind", "Chmod", "Clocate", "Delete", "Lfind", "Llocate", "Mkdir",
      "Move", "Remove", "Rename", "SudoEdit", "SudoWrite", "Wall"
    },
  },

  -----------------------------------------------------------------------------
  -- transparently edit gpg encrypted files
  { "jamessan/vim-gnupg" },

  -----------------------------------------------------------------------------
  -- programming wordlists for vim's builtin spellchecker
  {
    "psliwka/vim-dirtytalk",
    event = "VeryLazy",
    build = {
      ":DirtytalkUpdate",
      string.format(
        "cp -f %s/site/spell/programming.utf-8.spl %s/spell",
        vim.fn.stdpath("data"),
        vim.fn.stdpath("config")
      ),
    },
    config = function() vim.opt.spelllang:append("programming") end,
  },

  -----------------------------------------------------------------------------
  -- plugin manager
  {
    "folke/lazy.nvim",
    init = function() keymap("n", "<leader>L", "<CMD>Lazy<CR>", "Manage plugins (lazy)") end,
  },

  -----------------------------------------------------------------------------
  -- lua utils
  { "nvim-lua/plenary.nvim", lazy = true },

  -----------------------------------------------------------------------------
  -- quickfix/location list helper
  {
    "stevearc/qf_helper.nvim",
    event = "FileType qf",
    cmd = { "QFToggle", "LLToggle", "QNext", "QPrev", "Cclear", "Lclear", "Keep", "Reject" },
    opts = {
      quickfix = { default_bindings = false },
      loclist = { default_bindings = false },
    },
    keys = {
      { "<M-n>", "<CMD>QNext<CR>", mode = "n", desc = "Next quickfix/location list item" },
      { "<M-p>", "<CMD>QPrev<CR>", mode = "n", desc = "Previous quickfix/location list item" },
      { "<C-q>", "<CMD>QFToggle!<CR>", mode = "n", desc = "Toggle quickfix" },
      { "<M-q>", "<CMD>LLToggle!<CR>", mode = "n", desc = "Toggle location" },
    },
  },

  -----------------------------------------------------------------------------
  -- various small QoL improvements
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      words = { enabled = true },
      scope = { enabled = true },
      zen = {
        enabled = false,
        ---@type snacks.win.Config
        win = { wo = { colorcolumn = "0" } },
      },
      dashboard = {
        enabled = vim.g.use_devicons,
        sections = {
          { section = "header" },
          {
            action = ":tab Git",
            key = "s",
            desc = "Git Status",
            icon = res.icons.git.branch,
            cwd = true,
            padding = 1,
          },
          {
            action = ":Flog",
            key = "h",
            desc = "Git History",
            icon = res.icons.git.history,
            cwd = true,
            padding = 1,
          },
          { section = "keys", gap = 1, padding = 1 },
          {
            title = "Recent Files",
            section = "recent_files",
            cwd = true,
            indent = 2,
            -- gap = 1,
            -- padding = 2,
          },
          -- { section = "startup" },
        },
      },
    },

    keys = {
      { "<leader><BS>", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>bD", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },
      { "<leader>gB", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>,", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>sz", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      { "<leader>sZ", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
      -- { "<leader>go", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
      -- {
      --   "<leader>gy",
      --   function()
      --     Snacks.gitbrowse({ notify = false, open = function(url) vim.fn.setreg("+", url) end })
      --   end,
      --   desc = "Git Copy URL",
      --   mode = { "n", "v" },
      -- },
      { "grN", function() Snacks.rename.rename_file() end, desc = "Rename File" },
      { "<leader>sW", function() Snacks.toggle.words():toggle() end, desc = "Toggle lsp words" },
      {
        "<leader>sI",
        function() Snacks.toggle.indent():toggle() end,
        desc = "Toggle indent guides",
      },
      {
        "]]",
        function() Snacks.words.jump(vim.v.count1) end,
        desc = "Next Reference",
        mode = { "n", "t" },
      },
      {
        "[[",
        function() Snacks.words.jump(-vim.v.count1) end,
        desc = "Prev Reference",
        mode = { "n", "t" },
      },
    },

    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...) Snacks.debug.inspect(...) end
          _G.bt = function() Snacks.debug.backtrace() end
          vim.print = _G.dd -- Override print to use snacks for `:=` command
        end,
      })
    end,
  },
}
