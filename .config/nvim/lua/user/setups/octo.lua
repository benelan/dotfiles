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
      react_eyes = { lhs = "<leader>ore", desc = "add/remove 👀" },
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
      squash_and_merge_pr = { lhs = "<leader>opS", desc = "Squash and merge" },
      close_issue = { lhs = "<leader>opC", desc = "Close PR" },
      reopen_issue = { lhs = "<leader>opO", desc = "Reopen PR" },
      checkout_pr = { lhs = "<leader>opL", desc = "Checkout (l)ocally" },
      goto_issue = { lhs = "<leader>opI", desc = "Go to issue" },
      goto_file = { lhs = "opF", desc = "Go to file" },
      list_commits = { lhs = "<leader>opc", desc = "List commits" },
      list_changed_files = { lhs = "<leader>opf", desc = "List changed files" },
      show_pr_diff = { lhs = "<leader>opd", desc = "Show diff" },
      add_reviewer = { lhs = "<leader>opar", desc = "Add reviewer" },
      remove_reviewer = { lhs = "<leader>opDr", desc = "Remove reviewer request" },
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
      react_eyes = { lhs = "<leader>ore", desc = "add/remove 👀" },
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
      approve_review = { lhs = "<leader>orA", desc = "Approve review" },
      comment_review = { lhs = "<leader>orC", desc = "Comment review" },
      request_changes = { lhs = "<leader>orR", desc = "Request changes review" },
      close_review_tab = { lhs = "<leader>oC", desc = "Close review tab" },
    },
    review_diff = {
      add_review_comment = { lhs = "<leader>opac", desc = "Add review comment" },
      add_review_suggestion = { lhs = "<leader>opas", desc = "Add review suggestion" },
      focus_files = { lhs = "<leader>of", desc = "Focus changed files panel" },
      toggle_files = { lhs = "<leader>ot", desc = "Toggle changed files panel" },
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
      select_entry = { lhs = "<cr>", desc = "Show selected changed file diffs" },
      refresh_files = { lhs = "<leader>or", desc = "Refresh changed files panel" },
      focus_files = { lhs = "<leader>of", desc = "Focus to changed files panel" },
      toggle_files = { lhs = "<leader>ot", desc = "Toggle changed files panel" },
      select_next_entry = { lhs = "]q", desc = "Previous changed file" },
      select_prev_entry = { lhs = "[q", desc = "Next changed file" },
      close_review_tab = { lhs = "<leader>oC", desc = "Close review tab" },
      toggle_viewed = { lhs = "<leader>ov", desc = "Toggle viewed changes" },
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

vim.keymap.set("n", "<leader>oprf", "<cmd>Octo review submit<CR>",
  vim.list_extend({ desc = "Finish review" }, opts))


-- My stuff
vim.keymap.set("n", "<leader>omia", "<cmd>Octo issue list assignee=benelan state=OPEN<CR>",
  vim.list_extend({ desc = "List my assigned issues" }, opts))

vim.keymap.set("n", "<leader>omic", "<cmd>Octo issue list createdBy=benelan state=OPEN<CR>",
  vim.list_extend({ desc = "List my created issues" }, opts))

vim.keymap.set("n", "<leader>ompc", "<cmd>Octo search is:open is:pr author:benelan sort:updated<CR>",
  vim.list_extend({ desc = "List my created pull requests" }, opts))

vim.keymap.set("n", "<leader>ompa", "<cmd>Octo search is:open is:pr assignee:benelan sort:updated<CR>",
  vim.list_extend({ desc = "List my assigned pull requests" }, opts))

vim.keymap.set("n", "<leader>omr", "<cmd>Octo repo list<CR>",
  vim.list_extend({ desc = "List my repos" }, opts))

vim.keymap.set("n", "<leader>omg", "<cmd>Octo gist list<CR>",
  vim.list_extend({ desc = "List my gists" }, opts))
