local res = require "jamin.resources"

return {
  {
    "rbong/vim-flog",
    dependencies = "vim-fugitive",
    cmd = { "Flog", "Flogsplit", "Floggit" },
    keys = {
      { "<leader>gh", "<CMD>Flogsplit -path=%<CR>", desc = "History (file)", mode = "n" },
      { "<leader>gH", "<CMD>Flog<CR>", desc = "History", mode = "n" },
      { "<leader>gh", ":Flog<CR>", desc = "History (selected lines)", mode = "v" },
      {
        "<leader>gH",
        ":<C-u>call VisualSelection('')<CR>:<C-R>=@/<CR><C-b>Flog -patch-search=<CR>",
        desc = "History (selected text in patch)",
        mode = "v",
      },
    },
  },
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
      { "<leader>oa", "<cmd>Octo actions<CR>", desc = "Actions" },

      -- Find possible actions
      { "<leader>os", "<cmd>Octo search<CR>", desc = "Search" },

      -- Issues
      { "<leader>oil", "<cmd>Octo issue list<CR>", desc = "List issues" },
      { "<leader>oic", "<cmd>Octo issue create<CR>", desc = "Create issue" },
      { "<leader>ois", "<cmd>Octo issue search<CR>", desc = "Search issues" },

      -- Pull requests
      { "<leader>opl", "<cmd>Octo pr list<CR>", desc = "List pull requests" },
      { "<leader>opc", "<cmd>Octo pr create<CR>", desc = "Create pull request" },
      { "<leader>ops", "<cmd>Octo pr search<CR>", desc = "Search pull request" },

      -- Reviews
      { "<leader>oprr", "<cmd>Octo review resume<CR>", desc = "Resume review" },
      { "<leader>oprs", "<cmd>Octo review start<CR>", desc = "Start review" },
      { "<leader>oprf", "<cmd>Octo review submit<CR>", desc = "Finish review" },

      -- My stuff
      { "<leader>omia", "<cmd>Octo issue list assignee=benelan state=OPEN<CR>", desc = "List my assigned issues" },
      { "<leader>omic", "<cmd>Octo issue list createdBy=benelan state=OPEN<CR>", desc = "List my created issues" },
      { "<leader>omr", "<cmd>Octo repo list<CR>", desc = "List my repos" },
      { "<leader>omg", "<cmd>Octo gist list<CR>", desc = "List my gists" },
      { "<leader>ompc", "<cmd>Octo search is:open is:pr author:benelan<CR>", desc = "List my created pull requests" },
      { "<leader>ompa", "<cmd>Octo search is:open is:pr assignee:benelan<CR>", desc = "List my assigned pull requests" },
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
          vim.keymap.set("i", "@", "@<C-x><C-o>", { silent = true, buffer = true })
          vim.keymap.set("i", "#", "#<C-x><C-o>", { silent = true, buffer = true })
        end,
      })
    end,
  },
}
