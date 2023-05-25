return {
  {
    "tpope/vim-rhubarb", -- Open file/selection in GitHub repo
    keys = {
      {
        "<leader>go",
        "<cmd>GBrowse<cr>",
        desc = "Open in Browser",
        mode = "n",
      },
      {
        "<leader>go",
        ":'<,'>GBrowse<cr>",
        desc = "Open in Browser",
        mode = "v",
      },
      { "<leader>gy", "<cmd>GBrowse!<cr>", desc = "Yank URL", mode = "n" },
      { "<leader>gy", ":'<,'>GBrowse!<cr>", desc = "Yank URL", mode = "v" },
    },
  },
  -----------------------------------------------------------------------------
  {
    "pwntester/octo.nvim", -- GitHub integration, requires https://cli.github.com
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Octo",
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
      {
        "<leader>opc",
        "<cmd>Octo pr create<CR>",
        desc = "Create pull request",
      },
      {
        "<leader>ops",
        "<cmd>Octo pr search<CR>",
        desc = "Search pull request",
      },

      -- Reviews
      { "<leader>oprr", "<cmd>Octo review resume<CR>", desc = "Resume review" },
      { "<leader>oprs", "<cmd>Octo review start<CR>", desc = "Start review" },
      { "<leader>oprf", "<cmd>Octo review submit<CR>", desc = "Finish review" },

      -- My stuff
      {
        "<leader>omia",
        "<cmd>Octo issue list assignee=benelan state=OPEN<CR>",
        desc = "List my assigned issues",
      },
      {
        "<leader>omic",
        "<cmd>Octo issue list createdBy=benelan state=OPEN<CR>",
        desc = "List my created issues",
      },
      { "<leader>omr", "<cmd>Octo repo list<CR>", desc = "List my repos" },
      { "<leader>omg", "<cmd>Octo gist list<CR>", desc = "List my gists" },
      {
        "<leader>ompc",
        "<cmd>Octo search is:open is:pr author:benelan sort:updated<CR>",
        "desc = List my created pull requests",
      },
      {
        "<leader>ompa",
        "<cmd>Octo search is:open is:pr assignee:benelan sort:updated<CR>",
        "desc = List my assigned pull requests",
      },
    },
    opts = {
      pull_requests = {
        order_by = { field = "UPDATED_AT", direction = "DESC" },
      },
      file_panel = { use_icons = vim.g.use_devicons == true },
      right_bubble_delimiter = "█",
      left_bubble_delimiter = "█",
      mappings = {
        issue = {
          copy_url = { lhs = "<leader>oU", desc = "Copy url" },
          open_in_browser = { lhs = "<leader>oB", desc = "Open in browser" },
          reload = { lhs = "<leader>oR", desc = "Reload" },
          close_issue = { lhs = "<leader>oiC", desc = "Close issue" },
          reopen_issue = { lhs = "<leader>oiO", desc = "Reopen issue" },
          list_issues = { lhs = "<leader>oil", desc = "List open issues" },
          add_assignee = { lhs = "<leader>oiaa", desc = "Add assignee" },
          remove_assignee = { lhs = "<leader>oiDa", desc = "Remove assignee" },
          create_label = { lhs = nil, desc = "Create new label" },
          add_label = { lhs = "<leader>oial", desc = "Add label" },
          remove_label = { lhs = "<leader>oiDl", desc = "Remove label" },
          goto_issue = { lhs = "<leader>oig", desc = "Go to issue" },
          add_comment = { lhs = "<leader>oiac", desc = "Ddd comment" },
          delete_comment = { lhs = "<leader>oidc", desc = "Delete comment" },
          next_comment = { lhs = "]c", desc = "Next comment" },
          prev_comment = { lhs = "[c", desc = "Previous comment" },
          react_hooray = { lhs = "<leader>orp", desc = "add/remove 🎉" },
          react_heart = { lhs = "<leader>orh", desc = "add/remove ❤️ " },
          react_eyes = { lhs = "<leader>or", desc = "add/remove 👀" },
          react_thumbs_up = { lhs = "<leader>or+", desc = "add/remove 👍" },
          react_thumbs_down = { lhs = "<leader>or-", desc = "add/remove 👎" },
          react_rocket = { lhs = "<leader>orr", desc = "add/remove 🚀" },
          react_laugh = { lhs = "<leader>orl", desc = "add/remove 😄" },
          react_confused = { lhs = "<leader>orc", desc = "add/remove 😕" },
        },
        pull_request = {
          copy_url = { lhs = "<leader>oU", desc = "Copy url" },
          open_in_browser = { lhs = "<leader>oB", desc = "Open in browser" },
          reload = { lhs = "<leader>oR", desc = "Reload" },
          merge_pr = { lhs = "<leader>opM", desc = "Merge commit" },
          squash_and_merge_pr = {
            lhs = "<leader>opS",
            desc = "Squash and merge",
          },
          close_issue = { lhs = "<leader>opC", desc = "Close PR" },
          reopen_issue = { lhs = "<leader>opO", desc = "Reopen PR" },
          checkout_pr = { lhs = "<leader>opL", desc = "Checkout (l)ocally" },
          goto_issue = { lhs = "<leader>opI", desc = "Go to issue" },
          goto_file = { lhs = "opF", desc = "Go to file" },
          list_commits = { lhs = "<leader>opc", desc = "List commits" },
          list_changed_files = {
            lhs = "<leader>opf",
            desc = "List changed files",
          },
          show_pr_diff = { lhs = "<leader>opd", desc = "Show diff" },
          add_reviewer = { lhs = "<leader>opar", desc = "Add reviewer" },
          remove_reviewer = {
            lhs = "<leader>opDr",
            desc = "Remove reviewer request",
          },
          add_assignee = { lhs = "<leader>opaa", desc = "Add assignee" },
          remove_assignee = { lhs = "<leader>opDa", desc = "Remove assignee" },
          create_label = { lhs = nil, desc = "Create label" },
          add_label = { lhs = "<leader>opal", desc = "Add label" },
          remove_label = { lhs = "<leader>opDl", desc = "Remove label" },
          add_comment = { lhs = "<leader>opac", desc = "Add comment" },
          delete_comment = { lhs = "<leader>opDc", desc = "Delete comment" },
          next_comment = { lhs = "]c", desc = "Next comment" },
          prev_comment = { lhs = "[c", desc = "Previous comment" },
          react_hooray = { lhs = "<leader>orp", desc = "add/remove 🎉" },
          react_heart = { lhs = "<leader>orh", desc = "add/remove ❤️ " },
          react_eyes = { lhs = "<leader>or", desc = "add/remove 👀" },
          react_thumbs_up = { lhs = "<leader>or+", desc = "add/remove 👍" },
          react_thumbs_down = { lhs = "<leader>or-", desc = "add/remove 👎" },
          react_rocket = { lhs = "<leader>orr", desc = "add/remove 🚀" },
          react_laugh = { lhs = "<leader>orl", desc = "add/remove 😄" },
          react_confused = { lhs = "<leader>orc", desc = "add/remove 😕" },
        },
        review_thread = {
          goto_issue = { lhs = "<leader>opgi", desc = "Go to issue" },
          add_comment = { lhs = "<leader>opac", desc = "Add comment" },
          add_suggestion = { lhs = "<leader>opas", desc = "Add suggestion" },
          delete_comment = { lhs = "<leader>opDc", desc = "Delete comment" },
          next_comment = { lhs = "]c", desc = "Next comment" },
          prev_comment = { lhs = "[c", desc = "Previous comment" },
          select_next_entry = { lhs = "]q", desc = "Previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "Next changed file" },
          close_review_tab = { lhs = "<leader>oC", desc = "Close review tab" },
          react_hooray = {
            lhs = "<leader>orp",
            desc = "add/remove 🎉 reaction",
          },
          react_heart = {
            lhs = "<leader>orh",
            desc = "add/remove ❤️ reaction",
          },
          react_eyes = { lhs = "<leader>or", desc = "add/remove 👀 reaction" },
          react_thumbs_up = {
            lhs = "<leader>or+",
            desc = "add/remove 👍 reaction",
          },
          react_thumbs_down = {
            lhs = "<leader>or-",
            desc = "add/remove 👎 reaction",
          },
          react_rocket = {
            lhs = "<leader>orr",
            desc = "add/remove 🚀 reaction",
          },
          react_laugh = {
            lhs = "<leader>orl",
            desc = "add/remove 😄 reaction",
          },
          react_confused = {
            lhs = "<leader>orc",
            desc = "add/remove 😕 reaction",
          },
        },
        submit_win = {
          approve_review = { lhs = "<leader>orA", desc = "Approve review" },
          comment_review = { lhs = "<leader>orC", desc = "Comment review" },
          request_changes = {
            lhs = "<leader>orR",
            desc = "Request changes review",
          },
          close_review_tab = { lhs = "<leader>oC", desc = "Close review tab" },
        },
        review_diff = {
          add_review_comment = {
            lhs = "<leader>opac",
            desc = "Add review comment",
          },
          add_review_suggestion = {
            lhs = "<leader>opas",
            desc = "Add review suggestion",
          },
          focus_files = {
            lhs = "<leader>of",
            desc = "Focus changed files panel",
          },
          toggle_files = {
            lhs = "<leader>ot",
            desc = "Toggle changed files panel",
          },
          next_thread = { lhs = "]c", desc = "Next thread" },
          prev_thread = { lhs = "[c", desc = "Previous thread" },
          select_next_entry = { lhs = "]q", desc = "Previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "Next changed file" },
          close_review_tab = { lhs = "<leader>oC", desc = "Close review tab" },
          toggle_viewed = { lhs = "<leader>ov", desc = "Toggle viewed changes" },
        },
        file_panel = {
          next_entry = { lhs = "j", desc = "Next changed file" },
          prev_entry = { lhs = "k", desc = "Previous changed file" },
          select_entry = {
            lhs = "<cr>",
            desc = "Show selected changed file diffs",
          },
          refresh_files = {
            lhs = "<leader>or",
            desc = "Refresh changed files panel",
          },
          focus_files = {
            lhs = "<leader>of",
            desc = "Focus to changed files panel",
          },
          toggle_files = {
            lhs = "<leader>ot",
            desc = "Toggle changed files panel",
          },
          select_next_entry = { lhs = "]]", desc = "Previous changed file" },
          select_prev_entry = { lhs = "[[", desc = "Next changed file" },
          close_review_tab = { lhs = "<leader>oC", desc = "Close review tab" },
          toggle_viewed = { lhs = "<leader>ov", desc = "Toggle viewed changes" },
        },
      },
    },
    config = function(_, opts)
      require("octo").setup(opts)
      vim.treesitter.language.register("markdown", "octo")
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "octo",
        group = vim.api.nvim_create_augroup(
          "jamin_octo_settings",
          { clear = true }
        ),
        callback = function()
          vim.keymap.set(
            "i",
            "@",
            "@<C-x><C-o>",
            { silent = true, buffer = true }
          )
          vim.keymap.set(
            "i",
            "#",
            "#<C-x><C-o>",
            { silent = true, buffer = true }
          )
        end,
      })
    end,
  },
}
