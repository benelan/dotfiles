local res = require "jamin.resources"

return {
  {
    dir = "~/.vim/pack/foo/opt/vim-fugitive", -- the GOAT git plugin
    keys = {
      { "<leader>gg", "<CMD>Git<CR>", desc = "Fugitive status" },
      { "<leader>gc", "<CMD>Git commit<CR>", desc = "Git commit" },
      { "<leader>gP", "<CMD>Git pull --rebase<CR>", desc = "Git pull --rebase" },
      { "<leader>gb", "<CMD>Git blame<CR>", desc = "Fugitive blame" },
      { "<leader>gD", "<CMD>Git difftool -y<CR>", desc = "Fugitive difftool" },
      { "<leader>gM", "<CMD>Git mergetool -y<CR>", desc = "Fugitive mergetool" },
      { "<leader>gd", "<CMD>Gdiffsplit<CR>", desc = "Fugitive diff" },
      { "<leader>gW", "<CMD>Gwrite<CR>", desc = "Fugitive write" },
      { "<leader>gR", "<CMD>Gread<CR>", desc = "Fugitive read" },
      {
        "<M-w>",
        "<CMD>Gwrite <BAR> if &diff && tabpagenr('$') > 1 <BAR> tabclose <BAR> endif<CR>",
        desc = "Write changes and close difftool tab",
        mode = { "n" },
      },
      {
        "<M-r>",
        "<CMD>Gread <BAR> write <BAR> if &diff && tabpagenr('$') > 1 <BAR> tabclose <BAR> endif<CR>",
        desc = "Read changes and close difftool tab",
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
        desc = "Fugitive buffer history (qf)",
        mode = "n",
      },
      { "<leader>gl", ":Gclog<CR>", desc = "Fugitive history (qf)", mode = "x" },
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
      { "<leader>go", ":GBrowse<CR>", desc = "Open git object in browser", mode = { "n", "v" } },
      { "<leader>gy", ":GBrowse!<CR>", desc = "Yoink git object URL", mode = { "n", "v" } },
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
        desc = "Git buffer history (Flog)",
        mode = "n",
      },
      { "<leader>gH", "<CMD>Flog<CR>", desc = "Git history (Flog)", mode = "n" },
      { "<leader>gh", ":Flog<CR>", desc = "Git history (Flog)", mode = "v" },
      {
        "<leader>gH",
        ":<C-u>call VisualSelection('')<CR>:<C-R>=@/<CR><C-b>Flog -patch-search=<CR>",
        desc = "Find selected text in git patch history (Flog)",
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
      { "ih", function() require("gitsigns").select_hunk { vim.fn.line ".", vim.fn.line "v" } end, desc = "inner git hunk", mode = { "o", "x" } },
      { "]h", function() require("gitsigns").next_hunk() end, desc = "Next hunk" },
      { "[h", function() require("gitsigns").prev_hunk() end, desc = "Previous hunk" },
      { "<leader>hp", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk" },
      { "<leader>hw", function() require("gitsigns").stage_hunk { vim.fn.line ".", vim.fn.line "v" } end, desc = "Stage hunk", mode = "v" },
      { "<leader>hr", function() require("gitsigns").reset_hunk { vim.fn.line ".", vim.fn.line "v" } end, desc = "Reset hunk", mode = "v" },
      { "<leader>hr", function() require("gitsigns").reset_hunk() end, desc = "Reset hunk" },
      { "<leader>hw", function() require("gitsigns").stage_hunk() end, desc = "Stage hunk" },
      { "<leader>hu", function() require("gitsigns").undo_stage_hunk() end, desc = "Unstage hunk" },
      { "<leader>gtb", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle git blame" },
      { "<leader>gts", function() require("gitsigns").toggle_signs() end, desc = "Toggle git signs" },
      { "<leader>gtd", function() require("gitsigns").toggle_deleted() end, desc = "Toggle git deleted line display" },
      { "<leader>gtw", function() require("gitsigns").toggle_word_diff() end, desc = "Toggle git word diff" },
      { "<leader>gth", function() require("gitsigns").toggle_linehl() end, desc = "Toggle git line highlight" },
      { "<leader>gtn", function() require("gitsigns").toggle_numhl() end, desc = "Toggle git number highlight" },
      { "<leader>gB", function() require("gitsigns").blame_line { full = true } end, desc = "Blame popup" },
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
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Octo",
    -- stylua: ignore
    keys = {
      -- Find possible actions
      { "<leader>oa", "<CMD>Octo actions<CR>", desc = "Actions" },

      -- Search using GitHub's qualifiers
      -- https://docs.github.com/en/search-github/searching-on-github/searching-issues-and-pull-requests
      -- https://docs.github.com/en/search-github/getting-started-with-searching-on-github/understanding-the-search-syntax
      { "<leader>os", "<CMD>Octo search<CR>", desc = "Search" },

      -- Issues
      { "<leader>oil", "<CMD>Octo issue list<CR>", desc = "List issues" },
      { "<leader>oic", "<CMD>Octo issue create<CR>", desc = "Create issue" },

      -- Pull requests
      { "<leader>opl", "<CMD>Octo pr list<CR>", desc = "List pull requests" },
      { "<leader>opc", "<CMD>Octo pr create<CR>", desc = "Create pull request" },

      -- Reviews
      { "<leader>oprr", "<CMD>Octo review resume<CR>", desc = "Resume review" },
      { "<leader>oprs", "<CMD>Octo review start<CR>", desc = "Start review" },
      { "<leader>oprf", "<CMD>Octo review submit<CR>", desc = "Finish review" },

      -- My created/assigned issues and pull requests
      { "<leader>omia", "<CMD>Octo issue list assignee=benelan state=OPEN<CR>", desc = "List my assigned issues" },
      { "<leader>omic", "<CMD>Octo issue list createdBy=benelan state=OPEN<CR>", desc = "List my created issues" },
      { "<leader>ompc", "<CMD>Octo search is:open is:pr author:benelan<CR>", desc = "List my created pull requests" },
      { "<leader>ompa", "<CMD>Octo search is:open is:pr assignee:benelan<CR>", desc = "List my assigned pull requests" },

      -- My created repos and gists
      { "<leader>omr", "<CMD>Octo repo list<CR>", desc = "List my repos" },
      { "<leader>omg", "<CMD>Octo gist list<CR>", desc = "List my gists" },
    },
    opts = {
      enable_builtin = true,
      pull_requests = { order_by = { field = "UPDATED_AT", direction = "DESC" } },
      file_panel = { use_icons = vim.g.use_devicons == true },
      right_bubble_delimiter = res.icons.ui.block,
      left_bubble_delimiter = res.icons.ui.block,
      reaction_viewer_hint_icon = res.icons.ui.circle,
      user_icon = res.icons.lsp_kind.Copilot,
      timeline_marker = res.icons.ui.prompt,
    },
    config = function(_, opts)
      require("octo").setup(opts)

      vim.treesitter.language.register("markdown", "octo")

      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "octo",
        group = vim.api.nvim_create_augroup("jamin_octo_settings", { clear = true }),
        callback = function()
          -- Add issue number and user completion to octo buffers
          vim.keymap.set("i", "@", "@<C-x><C-o>", { silent = true, buffer = true })
          vim.keymap.set("i", "#", "#<C-x><C-o>", { silent = true, buffer = true })
        end,
      })
    end,
  },
}
