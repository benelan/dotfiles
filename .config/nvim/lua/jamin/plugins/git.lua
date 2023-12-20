local res = require "jamin.resources"

return {
  {
    dir = "~/.vim/pack/foo/opt/vim-fugitive", -- the GOAT git plugin
    keys = {
      { "<leader>g", "<CMD>Git<CR>", desc = "Fugitive status" },
      { "<leader>gg", "<CMD>Git<CR>", desc = "Fugitive status" },
      { "<leader>gc", "<CMD>Git commit<CR>", desc = "Fugitive commit" },
      { "<leader>gP", "<CMD>Git pull --rebase<CR>", desc = "Fugitive pull --rebase" },
      { "<leader>gB", "<CMD>Git blame<CR>", desc = "Fugitive blame" },
      { "<leader>gD", "<CMD>Git difftool -y<CR>", desc = "Fugitive difftool" },
      { "<leader>gM", "<CMD>Git mergetool -y<CR>", desc = "Fugitive mergetool" },
      { "<leader>gd", "<CMD>Gdiffsplit<CR>", desc = "Fugitive diff" },
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
        "<leader>gQ",
        [[ <CMD>execute 'bdelete '.join(filter(range(1, bufnr('$')), 'buflisted(v:val) && bufname(v:val) =~ "^fugitive://.*"'), ' ')<CR> ]],
        desc = "Delete all fugitive buffers",
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
      "G", "Git", "GDelete", "GMove", "GRename", "Gdrop", "Gcd", "Glcd", "Gclog", "Gllog",
      "Gedit", "Gtabedit", "Gpedit", "Ggrep", "Glgrep", "Gread", "Gwrite", "Gwq",
      "Gdiffsplit", "Gvdiffsplit", "Ghdiffsplit", "Gsplit", "Gvsplit",
    },
    -- init = function()
    --   vim.g.fugitive_dynamic_colors = 0
    -- end,
  },
  -----------------------------------------------------------------------------
  {
    dir = "~/.vim/pack/foo/opt/vim-rhubarb", -- Open file/selection in GitHub repo
    cmd = "GBrowse",
    dependencies = "vim-fugitive",
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
  {
    "rbong/vim-flog", -- [F]ugitive extension for viewing commit history [log]
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
        ":<C-u>call VisualSelection('')<CR>:<C-R>=@/<CR><C-b>Flog -patch-search=<CR>",
        desc = "Find selected text in git patch history (flog)",
        mode = "v",
      },
    },
  },
  -----------------------------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim", -- git change indicators, blame, and hunk utils
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "ih", function() require("gitsigns").select_hunk { vim.fn.line ".", vim.fn.line "v" } end, desc = "inner git hunk (gitsigns)", mode = { "o", "x" } },
      { "]h", function() require("gitsigns").next_hunk() end, desc = "Next hunk (gitsigns)" },
      { "[h", function() require("gitsigns").prev_hunk() end, desc = "Previous hunk (gitsigns)" },
      { "<leader>hp", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk (gitsigns)" },
      { "<leader>hw", function() require("gitsigns").stage_hunk { vim.fn.line ".", vim.fn.line "v" } end, desc = "Stage hunk (gitsigns)", mode = "v" },
      { "<leader>hr", function() require("gitsigns").reset_hunk { vim.fn.line ".", vim.fn.line "v" } end, desc = "Reset hunk (gitsigns)", mode = "v" },
      { "<leader>hr", function() require("gitsigns").reset_hunk() end, desc = "Reset hun (gitsigns)k" },
      { "<leader>hw", function() require("gitsigns").stage_hunk() end, desc = "Stage hunk (gitsigns)" },
      { "<leader>hu", function() require("gitsigns").undo_stage_hunk() end, desc = "Unstage hunk (gitsigns)" },
      { "<leader>gtb", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle blame (gitsigns)" },
      { "<leader>gts", function() require("gitsigns").toggle_signs() end, desc = "Toggle signs (gitsigns)" },
      { "<leader>gtd", function() require("gitsigns").toggle_deleted() end, desc = "Toggle deleted line display (gitsigns)" },
      { "<leader>gtw", function() require("gitsigns").toggle_word_diff() end, desc = "Toggle word diff (gitsigns)" },
      { "<leader>gth", function() require("gitsigns").toggle_linehl() end, desc = "Toggle line highlight (gitsigns)" },
      { "<leader>gtn", function() require("gitsigns").toggle_numhl() end, desc = "Toggle number highlight (gitsigns)" },
      { "<leader>gb", function() require("gitsigns").blame_line { full = true } end, desc = "Git blame line (gitsigns)" },
    },
    opts = {
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = true,
      },
    },
  },
  -----------------------------------------------------------------------------
  {
    "pwntester/octo.nvim", -- GitHub integration, requires https://cli.github.com
    -- dev = true,
    cond = vim.fn.executable "gh" == 1,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    cmd = "Octo",
    opts = {
      enable_builtin = true,
      pull_requests = { order_by = { field = "UPDATED_AT", direction = "DESC" } },
      file_panel = { use_icons = vim.g.use_devicons },
      -- right_bubble_delimiter = res.icons.ui.block,
      -- left_bubble_delimiter = res.icons.ui.block,
      reaction_viewer_hint_icon = res.icons.ui.circle,
      timeline_marker = res.icons.ui.prompt,
      user_icon = vim.g.use_devicons and res.icons.lsp_kind.Copilot or res.icons.ui.speech_bubble,
      picker_config = {
        mappings = { open_in_browser = { lhs = "<C-o>" }, checkout_pr = { lhs = "<M-o>" } },
      },
      mappings = {
        issue = { open_in_browser = { lhs = "<C-o>", desc = "open issue in browser" } },
        pull_requests = { open_in_browser = { lhs = "<C-o>", desc = "open PR in browser" } },
      },
    },
    config = function(_, opts)
      require("octo").setup(opts)

      vim.treesitter.language.register("markdown", "octo")
      vim.api.nvim_set_hl(0, "OctoBubble", { link = "TabLineFill" })

      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "octo",
        group = vim.api.nvim_create_augroup("jamin_octo_settings", { clear = true }),
        callback = function()
          vim.keymap.set(
            "n",
            "<leader>pC",
            "<CD>Octo pr checks<CR>",
            { desc = "Show pull request checks (octo)", silent = true, buffer = true }
          )

          vim.keymap.set(
            "n",
            "<leader>t<CR>",
            "<CD>Octo thread resolve<CR>",
            { desc = "Resolve pull request review thread (octo)", silent = true, buffer = true }
          )

          vim.keymap.set(
            "n",
            "<leader>t<Backspace>",
            "<CD>Octo thread unresolve<CR>",
            { desc = "Unresolve pull request review thread (octo)", silent = true, buffer = true }
          )

          vim.keymap.set("n", "<leader>vc", "<CD>Octo review comments<CR>", {
            desc = "Show pending pull request review comments (octo)",
            silent = true,
            buffer = true,
          })

          vim.keymap.set(
            "n",
            "<leader>vr",
            "<CD>Octo review resume<CR>",
            { desc = "Resume pull request review (octo)", silent = true, buffer = true }
          )

          vim.keymap.set(
            "n",
            "<leader>vs",
            "<CD>Octo review start<CR>",
            { desc = "Start pull request review (octo)", silent = true, buffer = true }
          )

          vim.keymap.set(
            "n",
            "<leader>v<CR>",
            "<CD>Octo review submit<CR>",
            { desc = "Submit pull request review (octo)", silent = true, buffer = true }
          )

          vim.keymap.set(
            "n",
            "<leader>v<Delete>",
            "<CD>Octo review discard<CR>",
            { desc = "Discard pull request review (octo)", silent = true, buffer = true }
          )

          -- Add issue number and user completion to octo buffers
          vim.keymap.set("i", "@", "@<C-x><C-o>", { silent = true, buffer = true })
          vim.keymap.set("i", "#", "#<C-x><C-o>", { silent = true, buffer = true })
        end,
      })
    end,
    -- stylua: ignore
    keys = {
      -- Find possible actions
      { "<leader>o", "<CMD>Octo actions<CR>", desc = "Actions (octo)" },

      -- Search using GitHub's qualifiers
      -- https://docs.github.com/en/search-github/searching-on-github/searching-issues-and-pull-requests
      -- https://docs.github.com/en/search-github/getting-started-with-searching-on-github/understanding-the-search-syntax
      { "<leader>os", "<CMD>Octo search<CR>", desc = "Search (octo)" },

      -- Issues
      { "<leader>oi<CR>", "<CMD>Octo issue create<CR>", desc = "Create issue (octo)" },
      { "<leader>oil", "<CMD>Octo issue list<CR>", desc = "List issues (octo)" },
      { "<leader>oia", "<CMD>Octo issue list assignee=benelan state=OPEN<CR>", desc = "List assigned issues (octo)" },
      { "<leader>oic", "<CMD>Octo issue list createdBy=benelan state=OPEN<CR>", desc = "List created issues (octo)" },

      -- Pull requests
      {
        "<leader>op",
        function()
          local number = vim.fn.system "gh pr view --json number --jq .number"
          if number and not string.match(number, "request") then
            vim.cmd("Octo pr edit " .. number)
          else
            print "No pull request found for current branch"
          end
        end,
        desc = "Open pull request for current branch (octo)",
      },
      { "<leader>op<CR>", "<CMD>Octo pr create<CR>", desc = "Create pull request (octo)" },
      { "<leader>opl", "<CMD>Octo pr list<CR>", desc = "List pull requests" },
      { "<leader>opa", "<CMD>Octo search is:open is:pr assignee:benelan<CR>", desc = "List assigned pull requests (octo)" },
      { "<leader>opc", "<CMD>Octo search is:open is:pr author:benelan<CR>", desc = "List created pull requests (octo)" },

      -- My repos and gists
      { "<leader>or", "<CMD>Octo repo list<CR>", desc = "List my repos (octo)" },
      { "<leader>og", "<CMD>Octo gist list<CR>", desc = "List my gists (octo)" },
    },
  },
  -----------------------------------------------------------------------------
  {
    "sindrets/diffview.nvim", -- diff and history viewer
    dependencies = { "lewis6991/gitsigns.nvim", "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gvd", "<CMD>DiffviewOpen<CR>", { "n", "x" }, desc = "Git difftool (diffview)" },
      {
        "<leader>gvs",
        -- https://github.com/sindrets/diffview.nvim/blob/main/USAGE.md#inspecting-diffs-for-stashes
        "<CMD>DiffviewFileHistory --walk-reflogs --range=stash<CR>",
        desc = "Stash git history (diffview)",
        mode = "n",
      },
      {
        "<leader>gvH",
        "<CMD>DiffviewFileHistory --max-count=1000<CR>",
        { "n", "x" },
        desc = "Files git history (diffview)",
      },
      {
        "<leader>gvh",
        ":DiffviewFileHistory % --max-count=1000<CR>",
        desc = "Buffer git history (diffview)",
        mode = { "n", "x" },
      },
    },
    opts = {
      enhanced_diff_hl = true,
      use_icons = vim.g.use_devicons,
      icons = { folder_closed = "", folder_open = "" },
      signs = {
        fold_closed = res.icons.ui.collapsed,
        fold_open = res.icons.ui.expanded,
        done = res.icons.ui.checkmark,
      },
      default_args = {
        DiffviewOpen = { "--imply-local" },
        DiffviewFileHistory = { "--follow" },
      },
    },
  },
}
