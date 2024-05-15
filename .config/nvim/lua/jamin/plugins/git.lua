local res = require("jamin.resources")

return {
  -- the GOAT git plugin
  {
    dir = "~/.vim/pack/foo/opt/vim-fugitive",
    cond = vim.fn.isdirectory("~/.vim/pack/foo/opt/vim-fugitive"),
    dependencies = "vim-rhubarb",

    keys = {
      { "<leader>gs", "<CMD>tab Git<CR>", desc = "Fugitive status" },
      { "<leader>gc", "<CMD>tab Git commit<CR>", desc = "Fugitive commit" },
      { "<leader>gP", "<CMD>Git pull --rebase<CR>", desc = "Fugitive pull --rebase" },
      { "<leader>gb", "<CMD>Git blame<CR>", desc = "Fugitive blame" },
      { "<leader>gD", "<CMD>Git difftool -y<CR>", desc = "Fugitive difftool" },
      { "<leader>gM", "<CMD>Git mergetool -y<CR>", desc = "Fugitive mergetool" },
      { "<leader>gd", "<CMD>Gvdiffsplit<CR>", desc = "Fugitive diff split" },
      { "<leader>gW", "<CMD>Gwrite<CR>", desc = "Fugitive write" },
      { "<leader>gR", "<CMD>Gread<CR>", desc = "Fugitive read" },
      {
        "<M-w>",
        "<CMD>Gwrite <BAR> if &diff && tabpagenr('$') > 1 <BAR> tabclose <BAR> endif<CR>",
        desc = "Write changes and close fugitive difftool tab",
        mode = { "n" },
      },
      {
        "<M-r>",
        "<CMD>Gread <BAR> write <BAR> if &diff && tabpagenr('$') > 1 <BAR> tabclose <BAR> endif<CR>",
        desc = "Read changes and close fugitive difftool tab",
        mode = { "n" },
      },
      {
        "<leader>gl",
        "<CMD>0Gclog --follow<CR>",
        desc = "Buffer history in quickfix (fugitive)",
        mode = "n",
      },
      { "<leader>gl", ":Gclog<CR>", desc = "History in quickfix (fugitive)", mode = "x" },
    },

    -- stylua: ignore
    cmd = {
      "G", "Git", "GBrowse", "GDelete", "GMove", "GRename", "Gcd", "Gclog",
      "Gdiffsplit", "Gdrop", "Gedit", "Ggrep", "Ghdiffsplit", "Glcd", "Glgrep",
      "Gllog", "Gpedit", "Gread", "Gsplit", "Gtabedit", "Gvdiffsplit",
      "Gvsplit", "Gwq", "Gwrite"
    },

    -- init = function()
    --   vim.g.fugitive_dynamic_colors = 0
    -- end,
  },

  -----------------------------------------------------------------------------
  -- Open file/selection in GitHub repo
  {
    dir = "~/.vim/pack/foo/opt/vim-rhubarb",
    cond = vim.fn.isdirectory("~/.vim/pack/foo/opt/vim-rhubarb"),
    keys = {
      {
        "<leader>go",
        ":GBrowse<CR>",
        desc = "Open git object in browser (fugitive)",
        mode = { "n", "v" },
      },
      {
        "<leader>gy",
        ":GBrowse!<CR>",
        desc = "Yoink git object URL (fugitive)",
        mode = { "n", "v" },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- git change indicators, blame, and hunk utils
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",

    keys = {
      {
        "]c",
        function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() require("gitsigns").next_hunk() end)
          return "<Ignore>"
        end,
        expr = true,
        mode = "n",
        desc = "Next hunk (gitsigns)",
      },
      {
        "[c",
        function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() require("gitsigns").prev_hunk() end)
          return "<Ignore>"
        end,
        expr = true,
        mode = "n",
        desc = "Previous hunk (gitsigns)",
      },
      {
        "]h",
        function() require("gitsigns").next_hunk() end,
        desc = "Next hunk (gitsigns)",
      },
      {
        "[h",
        function() require("gitsigns").prev_hunk() end,
        desc = "Previous hunk (gitsigns)",
      },
      {
        "]H",
        function() require("gitsigns").next_hunk({ wrap = false, preview = true }) end,
        desc = "Next hunk (gitsigns)",
      },
      {
        "[H",
        function() require("gitsigns").prev_hunk({ wrap = false, preview = true }) end,
        desc = "Previous hunk (gitsigns)",
      },
      {
        "ih",
        function() require("gitsigns").select_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
        desc = "inner git hunk (gitsigns)",
        mode = { "o", "x" },
      },
      {
        "<leader>hl",
        function() require("gitsigns").setloclist() end,
        desc = "Hunks to location list (gitsigns)",
      },
      {
        "<leader>hq",
        function() require("gitsigns").setqflist("all") end,
        desc = "Hunks to quickfix list (gitsigns)",
      },
      {
        "<leader>hp",
        function() require("gitsigns").preview_hunk() end,
        desc = "Preview hunk (gitsigns)",
      },
      {
        "<leader>hP",
        function() require("gitsigns").preview_hunk_inline() end,
        desc = "Preview hunk (gitsigns)",
      },
      {
        "<leader>hr",
        function() require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
        desc = "Reset hunk (gitsigns)",
        mode = "v",
      },
      {
        "<leader>hw",
        function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
        desc = "Stage hunk (gitsigns)",
        mode = "v",
      },
      {
        "<leader>hr",
        function() require("gitsigns").reset_hunk() end,
        desc = "Reset hunk (gitsigns)",
        mode = "n",
      },
      {
        "<leader>hw",
        function() require("gitsigns").stage_hunk() end,
        desc = "Stage hunk (gitsigns)",
        mode = "n",
      },
      {
        "<leader>hu",
        function() require("gitsigns").undo_stage_hunk() end,
        desc = "Unstage hunk (gitsigns)",
      },
      {
        "<leader>hR",
        function() require("gitsigns").reset_buffer() end,
        desc = "Reset buffer (gitsigns)",
      },
      {
        "<leader>hW",
        function() require("gitsigns").stage_buffer() end,
        desc = "Stage buffer (gitsigns)",
      },
      {
        "<leader>hb",
        function() require("gitsigns").blame_line({ full = true }) end,
        desc = "Git blame line (gitsigns)",
      },
      {
        "<leader>htb",
        function() require("gitsigns").toggle_current_line_blame() end,
        desc = "Toggle blame (gitsigns)",
      },
      {
        "<leader>hts",
        function() require("gitsigns").toggle_signs() end,
        desc = "Toggle signs (gitsigns)",
      },
      {
        "<leader>htd",
        function() require("gitsigns").toggle_deleted() end,
        desc = "Toggle deleted line display (gitsigns)",
      },
      {
        "<leader>htw",
        function() require("gitsigns").toggle_word_diff() end,
        desc = "Toggle word diff (gitsigns)",
      },
      {
        "<leader>hth",
        function() require("gitsigns").toggle_linehl() end,
        desc = "Toggle line highlight (gitsigns)",
      },
      {
        "<leader>htn",
        function() require("gitsigns").toggle_numhl() end,
        desc = "Toggle number highlight (gitsigns)",
      },
    },

    opts = {
      current_line_blame_formatter = ' <author> (<author_time:%R>) - "<summary>" : <abbrev_sha>',
      current_line_blame_opts = { virt_text_pos = "right_align", ignore_whitespace = true },
      preview_config = { border = res.icons.border },
      worktrees = { { toplevel = vim.env.HOME, gitdir = vim.env.HOME .. "/.git" } },
    },
  },
}
