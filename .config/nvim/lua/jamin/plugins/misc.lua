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
    init = function() keymap("n", "<leader>L", "<CMD>Lazy<CR>", "Manage plugins (lazy)") end,
  },

  -----------------------------------------------------------------------------
  -- lua utils
  { "nvim-lua/plenary.nvim", lazy = true },

  -----------------------------------------------------------------------------
  -- various QoL improvements
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
        win = { wo = { colorcolumn = "" } },
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
            enabled = function() return Snacks.git.get_root() ~= nil end,
          },
          {
            action = ":Flog",
            key = "h",
            desc = "Git History",
            icon = res.icons.git.history,
            cwd = true,
            padding = 1,
            enabled = function() return Snacks.git.get_root() ~= nil end,
          },
          { section = "keys", gap = 1, padding = 1 },
          {
            title = "Recent Files",
            section = "recent_files",
            cwd = true,
            indent = 2,
            -- gap = 1,
            -- padding = 2,
            filter = function(file)
              return not vim.tbl_contains(
                { "COMMIT_EDITMSG", "package-lock.json" },
                vim.fs.basename(file)
              )
            end,
          },
          -- { section = "startup" },
        },
      },
    },

    -- stylua: ignore
    keys = {
      { "<leader><BS>", function() Snacks.bufdelete() end, desc = "Delete Buffer (snacks)" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer (snacks)" },
      { "<leader>bD", function() Snacks.bufdelete.all() end, desc = "Delete All Buffers (snacks)" },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers (snacks)" },
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer (snacks)" },
      { "<leader>?", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer (snacks)" },
      { "<leader>sz", function() Snacks.zen() end, desc = "Toggle Zen Mode (snacks)" },
      { "<leader>sZ", function() Snacks.zen.zoom() end, desc = "Toggle Zoom (snacks)" },
      { "<leader>gB", function() Snacks.git.blame_line() end, desc = "Git Blame Line (snacks)" },
      -- { "<leader>go", function() Snacks.gitbrowse() end, desc = "Git Browse (snacks)", mode = { "n", "v" } },
      -- { "<leader>gy", function() Snacks.gitbrowse({ notify = false, open = function(url) vim.fn.setreg("+", url) end }) end, desc = "Git Copy URL (snacks)", mode = { "n", "v" } },
      { "grN", function() Snacks.rename.rename_file() end, desc = "Rename File (snacks)" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference (snacks)", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference (snacks)", mode = { "n", "t" } },
      { "<leader>sW", function() Snacks.toggle.words():toggle() end, desc = "Toggle lsp words (snacks)" },
      { "<leader>sI", function() Snacks.toggle.indent():toggle() end, desc = "Toggle indent guides (snacks)" },

      -- picker
      { "<C-p>", function() Snacks.picker.smart() end, desc = "Find Files (snacks picker)" }, ---@diagnostic disable-line: undefined-field
      { "<leader>;", function() Snacks.picker.buffers() end, desc = "Buffers (snacks picker)" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers (snacks picker)" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files (snacks picker)" },
      { "<leader>fo", function() Snacks.picker.recent() end, desc = "Oldfiles (snacks picker)" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent (snacks picker)" },
      { "<leader>fs", function() Snacks.picker.smart() end, desc = "Smart (snacks picker)" }, ---@diagnostic disable-line: undefined-field
      -- git
      { "<C-g>", function() Snacks.picker.git_files() end, desc = "Find Git Files (snacks picker)" },
      { "<leader>gfL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line (snacks picker)" },
      { "<leader>gfS", function() Snacks.picker.git_stash() end, desc = "Git Stash (snacks picker)" },
      { "<leader>gfb", function() Snacks.picker.git_branches() end, desc = "Git Branches (snacks picker)" },
      { "<leader>gfh", function() Snacks.picker.git_log() end, desc = "Git Log (snacks picker)" },
      { "<leader>gfl", function() Snacks.picker.git_log_file() end, desc = "Git Log File (snacks picker)" },
      { "<leader>gfs", function() Snacks.picker.git_status() end, desc = "Git Status (snacks picker)" },
      -- grep
      { "<C-\\>", function() Snacks.picker.grep() end, desc = "Grep (snacks picker)" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep (snacks picker)" },
      { "<leader>fB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers (snacks picker)" },
      { "<leader>fL", function() Snacks.picker.lines() end, desc = "Buffer Lines (snacks picker)" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep (snacks picker)" },
      { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word (snacks picker)", mode = { "n", "x" } },
      -- search
      { "<leader>f", function() Snacks.picker.pickers() end, desc = "Pickers (snacks picker)" },
      { "<leader>f.", function() Snacks.picker.resume() end, desc = "Resume (snacks picker)" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History (snacks picker)" },
      { "<leader>f:", function() Snacks.picker.command_history() end, desc = "Command History (snacks picker)" },
      { "<leader>fD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics (snacks picker)" }, ---@diagnostic disable-line: undefined-field
      { "<leader>fH", function() Snacks.picker.highlights() end, desc = "Highlights (snacks picker)" },
      { "<leader>fM", function() Snacks.picker.man() end, desc = "Man Pages (snacks picker)" },
      { "<leader>fa", function() Snacks.picker.autocmds() end, desc = "Autocmds (snacks picker)" },
      { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics (snacks picker)" },
      { "<leader>fc", function() Snacks.picker.commands() end, desc = "Commands (snacks picker)" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Pages (snacks picker)" },
      { "<leader>fj", function() Snacks.picker.jumps() end, desc = "Jumps (snacks picker)" },
      { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps (snacks picker)" },
      { "<leader>fl", function() Snacks.picker.loclist() end, desc = "Location List (snacks picker)" },
      { "<leader>fm", function() Snacks.picker.marks() end, desc = "Marks (snacks picker)" },
      { "<leader>fq", function() Snacks.picker.qflist() end, desc = "Quickfix List (snacks picker)" },
      { "<leader>fu", function() Snacks.picker.undo() end, desc = "Undo History (snacks picker)" }, ---@diagnostic disable-line: undefined-field
      { "<leader>fy", function() Snacks.picker.cliphist() end, desc = "Clipboard History (snacks picker)" },
      { "<leader>fz", function() Snacks.picker.spelling() end, desc = "Spelling (snacks picker)" }, ---@diagnostic disable-line: undefined-field
      { '<leader>f"', function() Snacks.picker.registers() end, desc = "Registers (snacks picker)" },
      -- LSP
      { "<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols (snacks picker)" }, ---@diagnostic disable-line: undefined-field
      { "<leader>ld", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition (snacks picker)" },
      { "<leader>li", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation (snacks picker)" },
      { "<leader>lr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References (snacks picker)" },
      { "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols (snacks picker)" },
      { "<leader>ly", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition (snacks picker)" },
    },
  },
}
