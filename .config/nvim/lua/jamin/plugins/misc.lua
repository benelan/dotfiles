return {
  -----------------------------------------------------------------------------
  -- keymaps/autocmds/utils/etc. shared with the vim config
  {
    dir = "~/.vim",
    priority = 420,
    enabled = vim.fn.isdirectory("~/.vim"),
    lazy = false,
  },

  -----------------------------------------------------------------------------
  -- adds closing brackets only when pressing enter
  {
    dir = "~/.vim/pack/foo/start/vim-closer",
    lazy = false,
    enabled = vim.fn.isdirectory("~/.vim/pack/foo/start/vim-closer"),
    config = function()
      -- setup files that can contain javascript which aren't included by default
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("jamin_closer_javascript", {}),
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
    enabled = vim.fn.isdirectory("~/.vim/pack/foo/opt/undotree"),
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<CMD>UndotreeToggle<CR>" } },
    init = function() vim.g.undotree_SetFocusWhenToggle = 1 end,
  },

  -----------------------------------------------------------------------------
  -- makes a lot more keymaps dot repeatable
  {
    dir = "~/.vim/pack/foo/start/vim-repeat",
    enabled = vim.fn.isdirectory("~/.vim/pack/foo/start/vim-repeat"),
    event = "CursorHold",
  },

  -----------------------------------------------------------------------------
  -- adds keymaps for surrounding text objects with quotes, brackets, etc.
  {
    dir = "~/.vim/pack/foo/start/vim-surround",
    enabled = vim.fn.isdirectory("~/.vim/pack/foo/start/vim-surround"),
    config = function()
      vim.cmd([[
        let g:surround_{char2nr('8')} = "/* \r */"
        let g:surround_{char2nr('e')} = "\r\n}"
      ]])
    end,
    keys = { "cs", "ds", "ys" },
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
  { "jamessan/vim-gnupg", lazy = false },

  -----------------------------------------------------------------------------
  -- plugin manager
  {
    "folke/lazy.nvim",
    init = function() keymap("n", "<leader>L", "<CMD>Lazy<CR>", "Lazy.nvim") end,
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
}
