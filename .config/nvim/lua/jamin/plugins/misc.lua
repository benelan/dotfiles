return {
  -- keymaps/autocmds/utils/etc. shared with the vim config
  {
    dir = "~/.vim",
    priority = 420,
    cond = vim.fn.isdirectory "~/.vim",
    lazy = false,
  },
  -----------------------------------------------------------------------------
  -- tpope plugins
  -- makes a lot more keymaps dot repeatable
  {
    dir = "~/.vim/pack/foo/start/vim-repeat",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/start/vim-repeat",
    event = "CursorHold",
  },
  -----------------------------------------------------------------------------
  -- readline mappings for insert and command modes
  {
    "tpope/vim-rsi",
    keys = {
      { "<C-x><C-a>", mode = { "c", "i" } },
      { "<C-a>", mode = { "c", "i" } },
      { "<C-b>", mode = { "c", "i" } },
      { "<C-d>", mode = { "c", "i" } },
      { "<C-f>", mode = { "c", "i" } },
      { "<M-b>", mode = { "c", "i" } },
      { "<M-d>", mode = { "c", "i" } },
      { "<M-f>", mode = { "c", "i" } },
      { "<M-n>", mode = { "c", "i" } },
      { "<M-p>", mode = { "c", "i" } },
      { "<M-BS>", mode = { "c", "i" } },
      { "<C-e>", mode = { "i" } },
      { "<C-y>", mode = { "c" } },
      { "<C-u>", mode = { "c" } },
      { "<C-t>", mode = { "c" } },
    },
  },
  -----------------------------------------------------------------------------
  -- adds keymaps for surrounding text objects with quotes, brackets, etc.
  {
    dir = "~/.vim/pack/foo/start/vim-surround",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/start/vim-surround",
    config = function()
      vim.cmd [[
        let g:surround_{char2nr('8')} = "/* \r */"
        let g:surround_{char2nr('e')} = "\r\n}"
      ]]
    end,
    keys = { "cs", "ds", "ys" },
  },
  -----------------------------------------------------------------------------
  -- adds keymap for toggling comments on text objects
  {
    dir = "~/.vim/pack/foo/start/vim-commentary",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/start/vim-commentary",
    keys = { { mode = { "n", "v", "o" }, "gc" } },
    cmd = "Commentary",
  },
  -----------------------------------------------------------------------------
  -- adds basic filesystem commands and some shebang utils
  {
    dir = "~/.vim/pack/foo/start/vim-eunuch",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/start/vim-eunuch",
    event = "BufNewFile",
    -- stylua: ignore
    cmd = {
      "Cfind", "Chmod", "Clocate", "Delete", "Lfind", "Llocate",
      "Mkdir", "Move", "Remove", "Rename", "SudoEdit", "SudoWrite", "Wall"
    },
  },
  -----------------------------------------------------------------------------
  {
    "tpope/vim-projectionist",
    lazy = false,
    init = function()
      vim.g.projectionist_heuristics = {
        ["/.git/"] = { ["README.md"] = { type = "docs" } },
        ["/.github/workflows/"] = { ["/.github/workflows/*.yml"] = { type = "ci" } },
        ["package.json"] = { ["package.json"] = { type = "run" } },
        ["Makefile"] = { ["Makefile"] = { type = "run" } },
        ["Cargo.toml"] = { ["Cargo.toml"] = { type = "run" } },
      }
    end,
    keys = {
      { "<leader>a", "<CMD>A<CR>", desc = "Alternate (projectionist)" },
      { "<M-a>", "<CMD>A<CR>", desc = "Alternate (projectionist)" },
      { "<leader>ac", "<CMD>Eci<CR>", desc = "Related: ci (projectionist)" },
      { "<leader>ad", "<CMD>Edocs<CR>", desc = "Related: docs (projectionist)" },
      { "<leader>ae", "<CMD>Eexample<CR>", desc = "Related: example (projectionist)" },
      { "<leader>am", "<CMD>Emain<CR>", desc = "Related: main (projectionist)" },
      { "<leader>as", "<CMD>Estyle<CR>", desc = "Related: style (projectionist)" },
      { "<leader>at", "<CMD>Etest<CR>", desc = "Related: test (projectionist)" },
      { "<leader>ar", "<CMD>Erun<CR>", desc = "Related: run (projectionist)" },
      {
        "<leader>a<CR>",
        "<CMD>Console<CR><C-w><C-w>",
        desc = "Console (projectionist)",
        silent = true,
      },
    },
  },
  -----------------------------------------------------------------------------
  {
    -- adds closing brackets only when pressing enter
    dir = "~/.vim/pack/foo/start/vim-closer",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/start/vim-closer",
    config = function()
      -- setup files that can contain javascript which aren't included by default
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("jamin_closer_javascript", { clear = true }),
        pattern = { "svelte", "astro", "html" },
        callback = function()
          vim.b.closer = 1
          vim.b.closer_flags = "([{;"
          vim.b.closer_no_semi = "^\\s*\\(function\\|class\\|if\\|else\\)"
          vim.b.closer_semi_ctx = ")\\s*{$"
        end,
      })
    end,
  },
  -----------------------------------------------------------------------------
  -- helps visualize and navigate the undo tree - see :h undo-tree
  {
    dir = "~/.vim/pack/foo/opt/undotree",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/opt/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<CMD>UndotreeToggle<CR>" } },
    init = function() vim.g.undotree_SetFocusWhenToggle = 1 end,
  },
  -----------------------------------------------------------------------------
  -- quickfix/location list helper
  {
    "stevearc/qf_helper.nvim",
    cmd = { "QFToggle", "LLToggle", "QNext", "QPrev", "Cclear", "Lclear", "Keep", "Reject" },
    opts = { quickfix = { default_bindings = false }, loclist = { default_bindings = false } },
    keys = {
      { "<M-n>", "<CMD>QNext<CR>", mode = "n", desc = "Next quickfix/location list item" },
      { "<M-p>", "<CMD>QPrev<CR>", mode = "n", desc = "Previous quickfix/location list item" },
      { "<C-q>", "<CMD>QFToggle!<CR>", mode = "n", desc = "Toggle quickfix" },
      { "<M-q>", "<CMD>LLToggle!<CR>", mode = "n", desc = "Toggle location" },
    },
  },
  -----------------------------------------------------------------------------
  -- increment/decrement more stuffs
  {
    "monaqa/dial.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local augend = require "dial.augend"
      require("dial.config").augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%m/%d/%y"],
          augend.date.alias["%m/%d/%Y"],
          augend.date.alias["%-m/%-d"],
          augend.date.alias["%H:%M"],
          augend.semver.alias.semver,
          augend.constant.alias.bool,
          augend.constant.new { elements = { "let", "const" } },
          augend.constant.new { elements = { "function()", "()=>" } },
          augend.constant.alias.alpha,
          augend.constant.alias.Alpha,
        },
      }
    end,
    -- stylua: ignore
    keys = {
      { "<C-a>", function() require("dial.map").manipulate("increment", "normal") end, mode = "n", desc = "Increment" },
      { "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end, mode = "n", desc = "Decrement" },
      { "<C-a>", function() require("dial.map").manipulate("increment", "visual") end, mode = "v", desc = "Increment" },
      { "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end, mode = "v", desc = "Decrement" },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, mode = "n", desc = "Increment" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, mode = "n", desc = "Decrement" },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, mode = "v", desc = "Increment" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, mode = "v", desc = "Decrement" },
    },
  },
  -----------------------------------------------------------------------------
  -- jump around within buffers
  {
    "folke/flash.nvim",
    -- enabled = false,
    opts = {
      exclude = require("jamin.resources").filetypes.excluded,
      modes = { search = { enabled = false }, char = { enabled = false } },
    },
    keys = {
      -- default options: exact mode, multi window, all directions, with a backdrop
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Flash remote" },
      {
        "S",
        mode = { "n", "o", "x" },
        function() require("flash").treesitter { label = { rainbow = { enabled = true } } } end,
        desc = "Flash treesitter",
      },
      {
        "R",
        mode = { "n", "o", "x" },
        -- show labeled treesitter nodes around the search matches
        function() require("flash").treesitter_search { label = { rainbow = { enabled = true } } } end,
        desc = "Flash treesitter search",
      },
      {
        "<C-s>",
        mode = "c",
        function() require("flash").toggle() end,
        desc = "Toggle flash search",
      },
    },
  },
  -----------------------------------------------------------------------------
  -- embed neovim in the browser
  {
    "glacambre/firenvim",
    lazy = not vim.g.started_by_firenvim,
    build = function() vim.fn["firenvim#install"](0) end,
    init = function()
      vim.g.firenvim_config = {
        globalSettings = { cmdlineTimeout = 420 },
        localSettings = { [".*"] = { takeover = "never" } },
      }
    end,
    config = function()
      -- settings for neovim embedded in the browser
      if vim.g.started_by_firenvim then
        keymap("n", "<Esc><Esc>", "<Cmd>call firenvim#focus_page()<CR>")
        keymap("n", "<C-z>", "<Cmd>call firenvim#hide_frame()<CR>")

        -- turn off some UI options
        vim.opt.showtabline = 0
        vim.opt.laststatus = 0
        vim.opt.showmode = false
        vim.opt.ruler = false
        vim.opt.fillchars:append "eob: "
        vim.opt.shortmess:append "aoW"
      end
    end,
  },
}
