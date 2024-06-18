local res = require("jamin.resources")

return {
  -- the GOAT git plugin
  {
    dir = "~/.vim/pack/foo/opt/vim-fugitive",
    enabled = vim.fn.isdirectory("~/.vim/pack/foo/opt/vim-fugitive"),
    dependencies = "vim-rhubarb",
    event = { { event = "BufReadCmd", pattern = "fugitive://*" } },

    keys = {
      { "<leader>gs", "<CMD>tab Git<CR>", desc = "Fugitive status" },
      { "<leader>gc", "<CMD>tab Git commit -vv<CR>", desc = "Fugitive commit" },
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
    config = function()
      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = { "LazyInstall", "LazyUpdate", "LazySync", "GitSignsUpdate" },
        group = vim.api.nvim_create_augroup("jamin_fugitive_reload_status", {}),
        callback = function(args)
          if vim.g.loaded_fugitive and vim.fn.exists("*FugitiveDidChange") then
            vim.fn["FugitiveDidChange"](args.data and args.data.buffer or nil)
          end
        end,
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- Open file/selection in GitHub repo
  {
    dir = "~/.vim/pack/foo/opt/vim-rhubarb",
    enabled = vim.fn.isdirectory("~/.vim/pack/foo/opt/vim-rhubarb"),
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
  -- [F]ugitive extension for viewing commit history [log]
  {
    "rbong/vim-flog",
    dependencies = "vim-fugitive",
    cmd = { "Flog", "Flogsplit", "Floggit" },
    keys = {
      {
        "<leader>gh",
        "<CMD>Flogsplit -path=%<CR>",
        desc = "Git buffer history (flog)",
        mode = "n",
      },
      { "<leader>gH", "<CMD>Flog<CR>", desc = "Git history (flog)", mode = "n" },
      { "<leader>gh", ":Flog<CR>", desc = "Git history (flog)", mode = "v" },
      {
        "<leader>gH",
        ":<C-u>call VisualSelection('pcre')<CR>:<C-R>=@/<CR><C-b>Flog -patch-search=<CR>",
        desc = "Find selected text in git patch history (flog)",
        mode = "v",
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
          vim.schedule(function() require("gitsigns").nav_hunk("next") end)
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
          vim.schedule(function() require("gitsigns").nav_hunk("prev") end)
          return "<Ignore>"
        end,
        expr = true,
        mode = "n",
        desc = "Previous hunk (gitsigns)",
      },
      {
        "]h",
        function()
          require("gitsigns").nav_hunk("next", { wrap = false, preview = true, target = "all" })
        end,
        desc = "Next hunk (gitsigns)",
      },
      {
        "[h",
        function()
          require("gitsigns").nav_hunk("prev", { wrap = false, preview = true, target = "all" })
        end,
        desc = "Previous hunk (gitsigns)",
      },
      {
        "]H",
        function()
          require("gitsigns").nav_hunk("last", { wrap = false, preview = true, target = "all" })
        end,
        desc = "Last hunk (gitsigns)",
      },
      {
        "[H",
        function()
          require("gitsigns").nav_hunk("first", { wrap = false, preview = true, target = "all" })
        end,
        desc = "First hunk (gitsigns)",
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
      signs = {
        add = { text = res.icons.git.status },
        change = { text = res.icons.git.status },
        untracked = { text = res.icons.git.status },
      },
      signs_staged = {
        add = { text = res.icons.git.status },
        change = { text = res.icons.git.status },
        untracked = { text = res.icons.git.status },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- GitHub integration, requires https://cli.github.com
  {
    "pwntester/octo.nvim",
    -- dev = true,
    enabled = vim.fn.executable("gh") == 1,
    cmd = "Octo",
    event = { { event = "BufReadCmd", pattern = "octo://*" } },

    opts = {
      enable_builtin = true,
      default_merge_method = "squash",
      default_to_projects_v2 = true,
      suppress_missing_scope = { projects_v2 = true },
      pull_requests = { order_by = { field = "UPDATED_AT", direction = "DESC" } },
      issues = { order_by = { field = "UPDATED_AT", direction = "DESC" } },
      file_panel = { use_icons = vim.g.use_devicons },
      outdated_icon = res.i(nil, res.icons.ui.clock),
      resolved_icon = res.i(nil, res.icons.ui.checkmark),
      reaction_viewer_hint_icon = res.i(nil, res.icons.ui.circle),
      repo_icon = res.i(nil, res.icons.ui.storage),
      user_icon = res.i(nil, res.icons.ui.user),
      timeline_marker = res.i(nil, res.icons.ui.prompt),
      right_bubble_delimiter = res.i(nil, res.icons.ui.fill_solid),
      left_bubble_delimiter = res.i(nil, res.icons.ui.fill_solid),
      picker_config = {
        mappings = {
          open_in_browser = { lhs = "<C-o>" },
          checkout_pr = { lhs = "<M-o>" },
        },
      },
      mappings = {
        issue = {
          open_in_browser = { lhs = "<C-o>", desc = "open issue in browser" },
        },
        pull_requests = {
          open_in_browser = { lhs = "<C-o>", desc = "open PR in browser" },
        },
      },
    },

    config = function(_, opts)
      require("octo").setup(opts)

      vim.treesitter.language.register("markdown", "octo")
      vim.api.nvim_set_hl(0, "OctoBubble", { link = "CursorLine" })
    end,

    keys = {
      -- Find possible actions
      { "<leader>o", "<CMD>Octo actions<CR>", desc = "Actions (octo)" },

      -- Search using GitHub's qualifiers
      -- https://docs.github.com/en/search-github/searching-on-github/searching-issues-and-pull-requests
      -- https://docs.github.com/en/search-github/getting-started-with-searching-on-github/understanding-the-search-syntax
      { "<leader>os", "<CMD>Octo search<CR>", desc = "Search (octo)" },

      -- Issues
      { "<leader>oiC", "<CMD>Octo issue create<CR>", desc = "Create issue (octo)" },
      { "<leader>oil", "<CMD>Octo issue list<CR>", desc = "List issues (octo)" },
      {
        "<leader>oia",
        "<CMD>Octo issue list assignee=benelan state=OPEN<CR>",
        desc = "List my assigned issues (octo)",
      },
      {
        "<leader>oic",
        "<CMD>Octo issue list createdBy=benelan state=OPEN<CR>",
        desc = "List my created issues (octo)",
      },

      -- Pull requests
      { "<leader>op", "<CMD>Octo pr<CR>", desc = "Open pull request for current branch (octo)" },
      { "<leader>opC", "<CMD>Octo pr create<CR>", desc = "Create pull request (octo)" },
      { "<leader>opl", "<CMD>Octo pr list<CR>", desc = "List pull requests" },
      {
        "<leader>opa",
        "<CMD>Octo search is:open is:pr assignee:benelan<CR>",
        desc = "List my assigned pull requests (octo)",
      },
      {
        "<leader>opc",
        "<CMD>Octo search is:open is:pr author:benelan<CR>",
        desc = "List my created pull requests (octo)",
      },

      -- My repos and gists
      { "<leader>or", "<CMD>Octo repo list<CR>", desc = "List my repos (octo)" },
      { "<leader>og", "<CMD>Octo gist list<CR>", desc = "List my gists (octo)" },

      -- Octo buffer keymaps
      {
        "<leader>pC",
        "<CMD>Octo pr checks<CR>",
        desc = "Show pull request checks (octo)",
        ft = "octo",
      },
      {
        "<leader>vo",
        "<CMD>Octo review comments<CR>",
        desc = "Show pending PR review comments (octo)",
        ft = "octo",
      },

      {
        "<leader>tr",
        "<CMD>Octo thread resolve<CR>",
        desc = "Resolve pull request review thread (octo)",
        ft = "octo",
      },
      {
        "<leader>tu",
        "<CMD>Octo thread unresolve<CR>",
        desc = "Unresolve pull request review thread (octo)",
        ft = "octo",
      },

      -- { "@", "@<C-x><C-o>", mode = "i", ft = "octo" },
      -- { "#", "#<C-x><C-o>", mode = "i", ft = "octo" },
    },
  },
}
