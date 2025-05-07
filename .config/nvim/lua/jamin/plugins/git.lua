---Plugins for Git and GitHub integration

local res = require("jamin.resources")

---@type LazySpec
return {
  -- the GOAT git plugin
  {
    "tpope/vim-fugitive",
    dependencies = "tpope/vim-rhubarb",
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
    -- config = function()
    --   vim.api.nvim_create_autocmd({ "User" }, {
    --     pattern = { "LazyInstall", "LazyUpdate", "LazySync", "GitSignsUpdate" },
    --     group = vim.api.nvim_create_augroup("jamin_fugitive_reload_status", {}),
    --     callback = function(args)
    --       if vim.g.loaded_fugitive and vim.fn.exists("*FugitiveDidChange") then
    --         vim.fn["FugitiveDidChange"](args.data and args.data.buffer or nil)
    --       end
    --     end,
    --   })
    -- end,
  },

  -----------------------------------------------------------------------------
  -- Open file/selection in GitHub repo
  {
    "tpope/vim-rhubarb",
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
    config = function()
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "floggraph" },
        group = vim.api.nvim_create_augroup("jamin_floggraph_keymaps", {}),
        callback = function(args)
          local opts = { buffer = args.buf, noremap = true }
          vim.keymap.set("n", "<C-f>", "<C-w>p<C-d><C-w>p", opts)
          vim.keymap.set("n", "<C-b>", "<C-w>p<C-u><C-w>p", opts)
        end,
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- git change indicators, blame, and hunk utils
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    keys = {
      {
        "]h",
        function() require("gitsigns").nav_hunk("next", { wrap = true, preview = true }) end,
        desc = "Next hunk (gitsigns)",
      },
      {
        "[h",
        function() require("gitsigns").nav_hunk("prev", { wrap = true, preview = true }) end,
        desc = "Previous hunk (gitsigns)",
      },
      {
        "]H",
        function() require("gitsigns").nav_hunk("last", { wrap = true, preview = true }) end,
        desc = "Last hunk (gitsigns)",
      },
      {
        "[H",
        function() require("gitsigns").nav_hunk("first", { wrap = true, preview = true }) end,
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
        ---@diagnostic disable-next-line: missing-parameter
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
        "<leader>hB",
        function() require("gitsigns").blame() end,
        desc = "Git blame buffer (gitsigns)",
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
      {
        "]c",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            require("gitsigns").nav_hunk("next", { wrap = false, target = "all" })
          end
        end,
        desc = "Next hunk (gitsigns)",
      },
      {
        "[c",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            require("gitsigns").nav_hunk("prev", { wrap = false, target = "all" })
          end
        end,
        desc = "Next hunk (gitsigns)",
      },
    },

    ---@type Gitsigns.Config
    opts = {
      current_line_blame_formatter = ' <author> (<author_time:%R>) - "<summary>" : <abbrev_sha>',
      current_line_blame_opts = { virt_text_pos = "right_align", ignore_whitespace = true },
      preview_config = { border = res.icons.border },
      signs = {
        add = { text = res.icons.git.status },
        change = { text = res.icons.git.status },
        changedelete = { text = res.icons.git.status_changedelete },
        topdelete = { text = res.icons.git.status_topdelete },
        delete = { text = res.icons.git.status_delete },
      },
      signs_staged = {
        add = { text = res.icons.git.status },
        change = { text = res.icons.git.status },
        changedelete = { text = res.icons.git.status_changedelete },
        topdelete = { text = res.icons.git.status_topdelete },
        delete = { text = res.icons.git.status_delete },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- GitHub integration, requires https://cli.github.com
  {
    "pwntester/octo.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    enabled = vim.fn.executable("gh") == 1,
    cmd = "Octo",
    event = { { event = "BufReadCmd", pattern = "octo://*" } },

    ---@type OctoConfig
    opts = {
      enable_builtin = true,
      default_merge_method = "squash",
      default_delete_branch = true,
      default_to_projects_v2 = true,
      suppress_missing_scope = { projects_v2 = true },
      issues = { order_by = { field = "UPDATED_AT", direction = "DESC" } },
      pull_requests = { order_by = { field = "UPDATED_AT", direction = "DESC" } },
      reviews = { auto_show_threads = false },
      file_panel = { use_icons = vim.g.have_nerd_font },
      use_timeline_icons = vim.g.have_nerd_font,
      runs = {
        icons = {
          pending = res.icons.test.pending,
          in_progress = res.icons.test.running,
          failed = res.icons.test.failed,
          succeeded = res.icons.test.passed,
          skipped = res.icons.test.skipped,
          cancelled = res.icons.test.cancelled,
        },
      },
      outdated_icon = res.i(nil, res.icons.ui.clock),
      resolved_icon = res.i(nil, res.icons.ui.checkmark),
      reaction_viewer_hint_icon = res.i(nil, res.icons.ui.circle),
      repo_icon = res.i(nil, res.icons.ui.storage),
      user_icon = res.i(nil, res.icons.ui.user),
      right_bubble_delimiter = res.i(nil, res.icons.ui.fill_solid),
      left_bubble_delimiter = res.i(nil, res.icons.ui.fill_solid),
      timeline_marker = res.i(nil, res.icons.ui.diamond),
      picker_config = {
        mappings = {
          open_in_browser = { lhs = "<C-o>", desc = "open issue in browser" },
          copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
          checkout_pr = { lhs = "<M-o>", desc = "checkout pull request" },
          merge_pr = { lhs = "<M-m>", desc = "merge pull request" },
        },
      },
      mappings = {
        issue = {
          open_in_browser = { lhs = "<C-o>", desc = "open issue in browser" },
        },
        pull_request = {
          open_in_browser = { lhs = "<C-o>", desc = "open PR in browser" },
          resolve_thread = { lhs = "<localleader>tr", desc = "resolve PR thread" },
          unresolve_thread = { lhs = "<localleader>tu", desc = "unresolve PR thread" },
          review_start = { lhs = "<Nop>" },
          review_resume = { lhs = "<Nop>" },
        },
        review_thread = {
          resolve_thread = { lhs = "<localleader>tr", desc = "resolve PR thread" },
          unresolve_thread = { lhs = "<localleader>tu", desc = "unresolve PR thread" },
        },
        submit_win = {
          comment_review = { lhs = "<C-s>", desc = "comment review", mode = { "n", "i" } },
        },
        notification = {
          read = { lhs = "<M-r>", desc = "mark notification as read", mode = { "n", "i" } },
        },
        runs = {
          expand_step = { lhs = "<Tab>", desc = "expand workflow step" },
          open_in_browser = { lhs = "<C-o>", desc = "open workflow run in browser" },
          rerun = { lhs = "<C-a>", desc = "rerun workflow" },
        },
      },
    },

    config = function(_, opts)
      require("octo").setup(opts)

      vim.treesitter.language.register("markdown", "octo")
      vim.api.nvim_set_hl(0, "OctoBubble", { link = "CursorLine" })
      vim.api.nvim_set_hl(0, "OctoStrikethrough", { fg = "#d3869b", strikethrough = true })

      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("jamin_octo_review_keymaps", { clear = true }),
        pattern = { "octo://*", "OctoChangedFiles-*" },
        -- command = "if &diff | set nofoldenable | fi",
        callback = function()
          vim.keymap.set("n", "<M-j>", "]t", { buffer = true, remap = true })
          vim.keymap.set("n", "<M-k>", "[t", { buffer = true, remap = true })
          vim.keymap.set("n", "<M-n>", "]q", { buffer = true, remap = true })
          vim.keymap.set("n", "<M-S-p>", "[q", { buffer = true, remap = true })
          vim.keymap.set("n", "<M-S-n>", "]Q", { buffer = true, remap = true })
          vim.keymap.set("n", "<M-S-p>", "[Q", { buffer = true, remap = true })
          vim.keymap.set("n", "<Tab>", "<localleader><space>]q", { buffer = true, remap = true })
          vim.keymap.set("n", "<S-Tab>", "<localleader><space>[q", { buffer = true, remap = true })
          vim.keymap.set("n", "-", "<localleader>b", { buffer = true, remap = true })
          vim.keymap.set("n", "<localleader>to", "<CMD>Octo review thread<CR>", {
            desc = "Open review thread (octo)",
            buffer = true,
          })
        end,
      })
    end,

    keys = {
      -- Find possible actions
      { "<leader>o", "<CMD>Octo actions<CR>", desc = "Actions (octo)" },

      -- -- native omni-completion alternative to https://github.com/Kaiser-Yang/blink-cmp-git
      -- { "@", "@<C-x><C-o>", mode = "i", ft = "octo" },
      -- { "#", "#<C-x><C-o>", mode = "i", ft = "octo" },

      -- Search using GitHub's qualifiers
      -- https://docs.github.com/en/search-github/searching-on-github/searching-issues-and-pull-requests
      -- https://docs.github.com/en/search-github/getting-started-with-searching-on-github/understanding-the-search-syntax
      { "<leader>os", "<CMD>Octo search<CR>", desc = "Search (octo)" },

      -- Workflow runs
      { "<leader>ow", "<CMD>Octo run list<CR>", desc = "Workflow runs (octo)" },

      -- Issues
      { "<leader>oI", "<CMD>Octo issue create<CR>", desc = "Create issue (octo)" },
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
      { "<leader>oP", "<CMD>Octo pr create<CR>", desc = "Create pull request (octo)" },
      { "<leader>op", "<CMD>Octo pr<CR>", desc = "Open pull request for current branch (octo)" },
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

      -- Milestones
      { "<leader>om", "<CMD>Octo milestone list<CR>", desc = "List milestones (octo)" },

      -- Discussions
      { "<leader>odl", "<CMD>Octo discussion list<CR>", desc = "List discussions (octo)" },
      { "<leader>ods", "<CMD>Octo discussion search<CR>", desc = "Search discussions (octo)" },

      -- My notifications, repos, and gists
      { "<leader>on", "<CMD>Octo notification list<CR>", desc = "List my notifications (octo)" },
      { "<leader>or", "<CMD>Octo repo list<CR>", desc = "List my repos (octo)" },
      { "<leader>og", "<CMD>Octo gist list<CR>", desc = "List my gists (octo)" },

      -- Octo buffer keymaps
      {
        "<localleader>cy",
        "<CMD>Octo comment url<CR>",
        desc = "Copy comment url (octo)",
        ft = "octo",
      },
      {
        "<localleader>pC",
        "<CMD>Octo pr checks<CR>",
        desc = "Show pull request checks (octo)",
        ft = "octo",
      },
      {
        "<localleader>pr",
        "<CMD>Octo pr runs<CR>",
        desc = "Show pull request runs (octo)",
        ft = "octo",
      },
      {
        "<localleader>vo",
        "<CMD>Octo review<CR>",
        desc = "Open PR review (octo)",
        ft = "octo",
      },
      {
        "<localleader>vc",
        "<CMD>Octo review commit<CR>",
        desc = "Review specific commit (octo)",
        ft = "octo",
      },
      {
        "<localleader>vp",
        "<CMD>Octo review comments<CR>",
        desc = "Show pending review comments (octo)",
        ft = "octo",
      },
      {
        "<localleader>ma",
        "<CMD>Octo milestone add<CR>",
        desc = "Add milestone (octo)",
        ft = "octo",
      },
      {
        "<localleader>md",
        "<CMD>Octo milestone remove<CR>",
        desc = "Remove milestone (octo)",
        ft = "octo",
      },
      {
        "<localleader>mc",
        "<CMD>Octo milestone create<CR>",
        desc = "Create milestone (octo)",
        ft = "octo",
      },
    },
  },
}
