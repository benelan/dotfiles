---Plugins that don't fit in one of the other categories

local res = require("jamin.resources")

local ui = vim.api.nvim_list_uis() or {}

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
    "benelan/vim-dirtytalk",
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
    init = function()
      vim.keymap.set("n", "<leader>L", "<CMD>Lazy<CR>", { desc = "Manage plugins (lazy)" })
    end,
  },

  -----------------------------------------------------------------------------
  -- lua utils
  { "nvim-lua/plenary.nvim", lazy = true },

  -----------------------------------------------------------------------------
  -- schweet treats from folke
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    init = function()
      vim.g.snacks_animate = false
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

    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      words = { enabled = true },
      scope = { enabled = true },
      zen = {
        enabled = false,
        ---@type snacks.win.Config
        win = { wo = { colorcolumn = "", cursorline = false, cursorcolumn = false } },
      },
      dashboard = {
        enabled = vim.g.use_devicons,
        width = #ui > 0 and math.max(60, math.floor(ui[1].width / 1.75)) or 60,
        sections = {
          {
            section = "header",
            padding = 1,
          },
          {
            action = ":tab Git",
            key = "s",
            desc = "Git Status",
            icon = res.icons.git.diff,
            cwd = true,
            padding = 1,
            enabled = function() return Snacks.git.get_root() ~= nil end,
          },
          {
            action = ":Flog",
            key = "h",
            desc = "Git History",
            icon = res.icons.git.log,
            cwd = true,
            padding = 1,
            enabled = function() return Snacks.git.get_root() ~= nil end,
          },
          {
            section = "keys",
            gap = 1,
            padding = 1,
          },
          {
            title = "Recent Files",
            section = "recent_files",
            cwd = true,
            indent = 2,
            -- gap = 1,
            padding = 1,
            -- icon = res.icons.ui.pin,
            filter = function(file)
              return not vim.tbl_contains(
                { "COMMIT_EDITMSG", "package-lock.json" },
                vim.fs.basename(file)
              )
            end,
          },
          {
            title = "GitHub Notifications",
            action = ":silent Octo notification",
            cmd = "gh notify -sn3",
            section = "terminal",
            enabled = #ui > 0 and (ui[1].height or 0) >= 39,
            key = "o",
            -- icon = res.icons.ui.alert,
            height = 3,
            indent = 2,
            -- padding = 1,
            -- pane = 2,
            ttl = 5 * 60,
          },
          {
            title = "GitHub Issues",
            action = ":silent Octo issue list",
            cmd = "GH_PAGER=cat GH_FORCE_TTY=true gh issue list -L 3 | tail -n3",
            section = "terminal",
            key = "i",
            height = 3,
            indent = 2,
            padding = 1,
            pane = 2,
            ttl = 5 * 60,
            enabled = false,
          },
          {
            title = "GitHub PRs",
            action = ":silent Octo pr list",
            cmd = "GH_PAGER=cat GH_FORCE_TTY=true gh pr list -L 3 | tail -n3",
            section = "terminal",
            key = "p",
            height = 3,
            indent = 2,
            pane = 2,
            ttl = 5 * 60,
            enabled = false,
          },
          -- { section = "startup" },
        },
      },
    },

    -- stylua: ignore
    keys = {
      -- buffer
      { "<leader><BS>", function() Snacks.bufdelete() end, desc = "Delete Buffer (snacks)" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer (snacks)" },
      { "<leader>bD", function() Snacks.bufdelete.all() end, desc = "Delete All Buffers (snacks)" },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers (snacks)" },
      { "<leader>bs", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer (snacks)" },
      { "<leader>bS", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer (snacks)" },

      -- ui
      { "<leader>sz", function() Snacks.zen() end, desc = "Toggle Zen Mode (snacks)" },
      { "<leader>sZ", function() Snacks.zen.zoom() end, desc = "Toggle Zoom (snacks)" },
      { "<leader>sI", function() Snacks.toggle.indent():toggle() end, desc = "Toggle indent guides (snacks)" },

      -- lsp
      { "<leader>sW", function() Snacks.toggle.words():toggle() end, desc = "Toggle lsp words (snacks)" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference (snacks)", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference (snacks)", mode = { "n", "t" } },
      { "cp", function() Snacks.rename.rename_file() end, desc = "Change file's path via lsp (snacks)" },
      { "<leader>ld", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition (snacks picker)" },

      -- git
      { "<leader>gB", function() Snacks.git.blame_line() end, desc = "Git Blame Line (snacks)" },
      -- { "<leader>go", function() Snacks.gitbrowse() end, desc = "Git Browse (snacks)", mode = { "n", "v" } },
      -- { "<leader>gy", function() Snacks.gitbrowse({ notify = false, open = function(url) vim.fn.setreg("+", url) end }) end, desc = "Git Copy URL (snacks)", mode = { "n", "v" } },
      { "<leader>gfL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line (snacks picker)" },
      { "<leader>gfl", function() Snacks.picker.git_log_file() end, desc = "Git Log File (snacks picker)" },

      -- explorer
      { "<leader>fe", function() Snacks.picker.explorer({ cwd = Snacks.git.get_root() }) end, desc = "Explorer - root (snacks)" },
      { "<leader>fE", function() Snacks.picker.explorer() end, desc = "Explorer - cwd (snacks)" },

      -- picker
      { "<leader>fs", function() Snacks.picker.smart() end, desc = "Smart (snacks picker)" },
      { "<leader>fB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers (snacks picker)" },
      { "<leader>fu", function() Snacks.picker.undo() end, desc = "Undo History (snacks picker)" },
      { "<leader>fy", function() Snacks.picker.cliphist() end, desc = "Clipboard History (snacks picker)" },
      { "<leader>fz", function() Snacks.picker.spelling() end, desc = "Spelling (snacks picker)" },
    },
  },
}
