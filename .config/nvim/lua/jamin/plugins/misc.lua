return {
  -- keymaps/autocmds/utils/etc. shared with the vim config
  { dir = "~/.vim", cond = vim.fn.isdirectory "~/.vim", lazy = false },
  -----------------------------------------------------------------------------
  -- tpope plugins
  {
    -- makes a lot more keymaps dot repeatable
    dir = "~/.vim/pack/foo/start/vim-repeat",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/start/vim-repeat",
    event = "CursorHold",
  },
  {
    -- adds keymaps for surrounding text objects with quotes, brackets, etc.
    dir = "~/.vim/pack/foo/start/vim-surround",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/start/vim-surround",
    keys = { "cs", "ds", "ys" },
  },
  {
    -- adds keymap for toggling comments on text objects
    dir = "~/.vim/pack/foo/start/vim-commentary",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/start/vim-commentary",
    keys = { { mode = { "n", "v", "o" }, "gc" } },
    cmd = "Commentary",
  },
  {
    -- adds basic filesystem commands and some shebang utils
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
    -- adds closing brackets only when pressing enter
    dir = "~/.vim/pack/foo/start/vim-closer",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/start/vim-closer",
    init = function()
      -- setup files that can contain javascript
      vim.cmd [[
        au FileType svelte,astro,html,vue
        \ let b:closer = 1 |
        \ let b:closer_flags = '([{;' |
        \ let b:closer_no_semi = '^\s*\(function\|class\|if\|else\)' |
        \ let b:closer_semi_ctx = ')\s*{$'
    ]]
    end,
  },
  -----------------------------------------------------------------------------
  {
    -- helps visualize and navigate the undo tree - see :h undo-tree
    dir = "~/.vim/pack/foo/opt/undotree",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/opt/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<CMD>UndotreeToggle<CR>" } },
    init = function()
      vim.g.undotree_SetFocusWhenToggle = 1

      vim.g.Undotree_CustomMap = function()
        vim.keymap.set("n", "]", "<Plug>UndotreeNextSavedState", {
          desc = "Next saved state",
          silent = true,
          noremap = true,
          buffer = true,
        })

        vim.keymap.set("n", "[", "<Plug>UndotreePreviousSavedState", {
          desc = "Previous saved state",
          silent = true,
          noremap = true,
          buffer = true,
        })
      end
    end,
  },
  -----------------------------------------------------------------------------
  {
    "monaqa/dial.nvim", -- increment/decrement more stuffs
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
  {
    "folke/flash.nvim", -- jump around within buffers
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
  {
    "glacambre/firenvim", -- embed neovim in the browser
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

        -- auto sync changes with the browser
        -- vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        --   callback = function()
        --     if vim.g.started_firenvim_timer == true then return end
        --     vim.g.started_firenvim_timer = true
        --     vim.fn.timer_start(10000, function()
        --       vim.g.started_firenvim_timer = false
        --       vim.cmd "write"
        --     end)
        --   end,
        -- })
      end
    end,
  },
}
