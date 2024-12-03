---Plugins that don't fit in one of the other categories

local res = require("jamin.resources")

return {
  -----------------------------------------------------------------------------
  -- keymaps/autocmds/utils/etc from my vim config (too lazy to lua-ify everything)
  {
    dir = "~/.vim",
    priority = 90,
    enabled = vim.fn.isdirectory("~/.vim"),
    lazy = false,
    vscode = true,
  },

  -----------------------------------------------------------------------------
  -- helps visualize and navigate the undo tree - see :h undo-tree
  {
    dir = "~/.vim/pack/foo/opt/undotree",
    enabled = vim.fn.isdirectory("~/.vim/pack/foo/opt/undotree"),
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<CMD>UndotreeToggle<CR>" } },
    init = function() vim.g.undotree_SetFocusWhenToggle = 1 end,
  },

  -----------------------------------------------------------------------------
  -- adds basic filesystem commands and some shebang utils
  {
    dir = "~/.vim/pack/foo/start/vim-eunuch",
    enabled = vim.fn.isdirectory("~/.vim/pack/foo/start/vim-eunuch"),
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
      statuscolumn = { enabled = true },
      notifier = { enabled = false },
    },
    keys = {
      { "<leader><BS>", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>bD", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },
      { "<leader>gB", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
      { "<leader>go", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
      {
        "<leader>gy",
        function()
          Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end })
        end,
        desc = "Git Copy URL",
        mode = { "n", "v" },
      },
      { "grN", function() Snacks.rename.rename_file() end, desc = "Rename File" },
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
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
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

          -- Create some toggle mappings
          Snacks.toggle.diagnostics():map("<leader>sd")
          Snacks.toggle.treesitter():map("<leader>sh")
          Snacks.toggle.inlay_hints():map("<leader>si")

          Snacks.toggle.option("list", { name = "List Characters" }):map("<leader>sl")
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ss")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>sw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>sn")
          Snacks.toggle.option("cursorline", { name = "Cursor Line" }):map("<leader>sx")
          Snacks.toggle.option("cursorcolumn", { name = "Cursor Column" }):map("<leader>sy")
          Snacks.toggle.option("colorcolumn", { name = "Color Column" }):map("<leader>s|")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>sc")
        end,
      })
    end,
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
}
