local status_ok, octo = pcall(require, "octo")
if not status_ok then return end

octo.setup({
  pull_requests = {
    order_by = {
      field = "UPDATED_AT",
      direction = "DESC"
    },
  },
  mappings = {
    issue = {
      close_issue = { lhs = "<leader>oiD", desc = "close issue" },
      reopen_issue = { lhs = "<leader>oiO", desc = "reopen issue" },
      list_issues = { lhs = "<leader>oil", desc = "list open issues on same repo" },
      reload = { lhs = "<C-r>", desc = "reload issue" },
      open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
      copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
      add_assignee = { lhs = "<leader>oiaa", desc = "add assignee" },
      remove_assignee = { lhs = "<leader>oida", desc = "remove assignee" },
      create_label = { lhs = "<leader>oi+l", desc = "make new label" },
      add_label = { lhs = "<leader>oial", desc = "add label" },
      remove_label = { lhs = "<leader>oidl", desc = "remove label" },
      goto_issue = { lhs = "<leader>oig", desc = "navigate to a local repo issue" },
      add_comment = { lhs = "<leader>oiac", desc = "add comment" },
      delete_comment = { lhs = "<leader>oidc", desc = "delete comment" },
      next_comment = { lhs = "]c", desc = "go to next comment" },
      prev_comment = { lhs = "[c", desc = "go to previous comment" },
      react_hooray = { lhs = "<leader>orp", desc = "add/remove 🎉 reaction" },
      react_heart = { lhs = "<leader>orh", desc = "add/remove ❤️ reaction" },
      react_eyes = { lhs = "<leader>ore", desc = "add/remove 👀 reaction" },
      react_thumbs_up = { lhs = "<leader>or+", desc = "add/remove 👍 reaction" },
      react_thumbs_down = { lhs = "<leader>or-", desc = "add/remove 👎 reaction" },
      react_rocket = { lhs = "<leader>orr", desc = "add/remove 🚀 reaction" },
      react_laugh = { lhs = "<leader>orl", desc = "add/remove 😄 reaction" },
      react_confused = { lhs = "<leader>orc", desc = "add/remove 😕 reaction" },
    },
    pull_request = {
      checkout_pr = { lhs = "<C-o>", desc = "checkout PR" },
      merge_pr = { lhs = "<leader>opM", desc = "merge commit PR" },
      squash_and_merge_pr = { lhs = "<leader>opS", desc = "squash and merge PR" },
      list_commits = { lhs = "<leader>opc", desc = "list PR commits" },
      list_changed_files = { lhs = "<leader>opf", desc = "list PR changed files" },
      show_pr_diff = { lhs = "<leader>opd", desc = "show PR diff" },
      add_reviewer = { lhs = "<leader>opar", desc = "add reviewer" },
      remove_reviewer = { lhs = "<leader>opdr", desc = "remove reviewer request" },
      close_issue = { lhs = "<leader>opD", desc = "close PR" },
      reopen_issue = { lhs = "<leader>opO", desc = "reopen PR" },
      reload = { lhs = "<C-r>", desc = "reload PR" },
      open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
      copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
      goto_file = { lhs = "opgf", desc = "go to file" },
      add_assignee = { lhs = "<leader>opaa", desc = "add assignee" },
      remove_assignee = { lhs = "<leader>opda", desc = "remove assignee" },
      create_label = { lhs = "<leader>op+l", desc = "create label" },
      add_label = { lhs = "<leader>opal", desc = "add label" },
      remove_label = { lhs = "<leader>opdl", desc = "remove label" },
      goto_issue = { lhs = "<leader>opgi", desc = "navigate to a local repo issue" },
      add_comment = { lhs = "<leader>opac", desc = "add comment" },
      delete_comment = { lhs = "<leader>opdc", desc = "delete comment" },
      next_comment = { lhs = "]c", desc = "go to next comment" },
      prev_comment = { lhs = "[c", desc = "go to previous comment" },
      react_hooray = { lhs = "<leader>orp", desc = "add/remove 🎉 reaction" },
      react_heart = { lhs = "<leader>orh", desc = "add/remove ❤️ reaction" },
      react_eyes = { lhs = "<leader>ore", desc = "add/remove 👀 reaction" },
      react_thumbs_up = { lhs = "<leader>or+", desc = "add/remove 👍 reaction" },
      react_thumbs_down = { lhs = "<leader>or-", desc = "add/remove 👎 reaction" },
      react_rocket = { lhs = "<leader>orr", desc = "add/remove 🚀 reaction" },
      react_laugh = { lhs = "<leader>orl", desc = "add/remove 😄 reaction" },
      react_confused = { lhs = "<leader>orc", desc = "add/remove 😕 reaction" },
    },
    review_thread = {
      goto_issue = { lhs = "<leader>opgi", desc = "navigate to a local repo issue" },
      add_comment = { lhs = "<leader>opac", desc = "add comment" },
      add_suggestion = { lhs = "<leader>opas", desc = "add suggestion" },
      delete_comment = { lhs = "<leader>opDc", desc = "delete comment" },
      next_comment = { lhs = "]c", desc = "go to next comment" },
      prev_comment = { lhs = "[c", desc = "go to previous comment" },
      select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
      select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
      close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
      react_hooray = { lhs = "<leader>orp", desc = "add/remove 🎉 reaction" },
      react_heart = { lhs = "<leader>orh", desc = "add/remove ❤️ reaction" },
      react_eyes = { lhs = "<leader>ore", desc = "add/remove 👀 reaction" },
      react_thumbs_up = { lhs = "<leader>or+", desc = "add/remove 👍 reaction" },
      react_thumbs_down = { lhs = "<leader>or-", desc = "add/remove 👎 reaction" },
      react_rocket = { lhs = "<leader>orr", desc = "add/remove 🚀 reaction" },
      react_laugh = { lhs = "<leader>orl", desc = "add/remove 😄 reaction" },
      react_confused = { lhs = "<leader>orc", desc = "add/remove 😕 reaction" },
    },
    submit_win = {
      approve_review = { lhs = "<leader>orA", desc = "approve review" },
      comment_review = { lhs = "<leader>orC", desc = "comment review" },
      request_changes = { lhs = "<leader>orR", desc = "request changes review" },
      close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
    },
    review_diff = {
      add_review_comment = { lhs = "<leader>opac", desc = "add a new review comment" },
      add_review_suggestion = { lhs = "<leader>opas", desc = "add a new review suggestion" },
      focus_files = { lhs = "<leader>of", desc = "move focus to changed file panel" },
      toggle_files = { lhs = "<leader>ot", desc = "hide/show changed files panel" },
      next_thread = { lhs = "]t", desc = "move to next thread" },
      prev_thread = { lhs = "[t", desc = "move to previous thread" },
      select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
      select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
      close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
      toggle_viewed = { lhs = "<leader>ov", desc = "toggle viewer viewed state" },
    },
    file_panel = {
      next_entry = { lhs = "j", desc = "move to next changed file" },
      prev_entry = { lhs = "k", desc = "move to previous changed file" },
      select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
      refresh_files = { lhs = "R", desc = "refresh changed files panel" },
      focus_files = { lhs = "<leader>of", desc = "move focus to changed file panel" },
      toggle_files = { lhs = "<leader>ot", desc = "hide/show changed files panel" },
      select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
      select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
      close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
      toggle_viewed = { lhs = "<leader>ov", desc = "toggle viewer viewed state" },
    }
  }
})

local opts = { silent = true, noremap = true }


-- Find possible actions
vim.keymap.set("n", "<leader>oa", "<cmd>Octo actions<CR>",
  vim.list_extend({ desc = "Actions" }, opts))

-- Find possible actions
vim.keymap.set("n", "<leader>os", "<cmd>Octo search<CR>",
  vim.list_extend({ desc = "Search" }, opts))

-- Issues
vim.keymap.set("n", "<leader>oil", "<cmd>Octo issue list<CR>",
  vim.list_extend({ desc = "List issues" }, opts))

vim.keymap.set("n", "<leader>oic", "<cmd>Octo issue create<CR>",
  vim.list_extend({ desc = "Create issue" }, opts))

vim.keymap.set("n", "<leader>ois", "<cmd>Octo issue search<CR>",
  vim.list_extend({ desc = "Search issues" }, opts))

-- Pull requests
vim.keymap.set("n", "<leader>opl", "<cmd>Octo pr list<CR>",
  vim.list_extend({ desc = "List pull requests" }, opts))


vim.keymap.set("n", "<leader>opc", "<cmd>Octo pr create<CR>",
  vim.list_extend({ desc = "Create pull request" }, opts))

vim.keymap.set("n", "<leader>ops", "<cmd>Octo pr search<CR>",
  vim.list_extend({ desc = "Search pull request" }, opts))

-- Reviews
vim.keymap.set("n", "<leader>oprr", "<cmd>Octo review resume<CR>",
  vim.list_extend({ desc = "Resume review" }, opts))

vim.keymap.set("n", "<leader>oprs", "<cmd>Octo review start<CR>",
  vim.list_extend({ desc = "Start review" }, opts))
