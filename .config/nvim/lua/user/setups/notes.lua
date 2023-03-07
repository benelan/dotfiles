local notes_dir = os.getenv "ZK_NOTEBOOK_DIR" or vim.fn.expand "~/notes"

vim.g.calendar_no_mappings = true
require("telekasten").setup {
  take_over_my_home = false,
  sort = "modified",
  home = notes_dir .. "/void",
  dailies = notes_dir .. "/journal/daily",
  weeklies = notes_dir .. "/journal/weekly",
  templates = notes_dir .. "/.telekasten/templates",
  image_subdir = notes_dir .. "/.telekasten/img",
  template_new_note = notes_dir .. "/.telekasten/templates/new_note.md",
  template_new_daily = notes_dir .. "/.telekasten/templates/daily.md",
  template_new_weekly = notes_dir .. "/.telekasten/templates/weekly.md",
  calendar_opts = { weeknm = 1 },
}

-- Launch panel if nothing is typed after <leader>z
-- keymap("n", "<leader>z", "<cmd>Telekasten panel<CR>")
keymap("n", "<leader>Zn", "<cmd>Telekasten new_note<CR>", "New note")
keymap("n", "<leader>Zc", "<cmd>Telekasten show_calendar<CR>", "Calendar")
keymap("n", "<leader>Zf", "<cmd>Telekasten find_notes<CR>", "Find note")
keymap("n", "<leader>ZF", "<cmd>Telekasten find_friends<CR>", "Find friends")
keymap("n", "<leader>Zt", "<cmd>Telekasten show_tags<CR>", "Tags")
keymap("n", "<leader>Zg", "<cmd>Telekasten search_notes<CR>", "Grep notes")
keymap("n", "<leader>Zd", "<cmd>Telekasten goto_today<CR>", "Today")
keymap("n", "<leader>ZD", "<cmd>Telekasten find_daily_notes<CR>", "Find daily notes")
keymap("n", "<leader>Zw", "<cmd>Telekasten goto_thisweek<CR>", "This week")
keymap("n", "<leader>ZW", "<cmd>Telekasten find_weekly_notes<CR>", "Find weekly notes")

keymap("n", "<leader>Zz", "<cmd>Telekasten follow_link<CR>", "Follow link")
keymap("n", "<leader>Zb", "<cmd>Telekasten show_backlinks<CR>", "Backlints")
keymap("n", "<leader>ZI", "<cmd>Telekasten insert_link<CR>", "Insert link")
keymap("v", "<leader>ZI", "<cmd>Telekasten insert_link { v = true }<CR>", "Insert link")
keymap("n", "<leader>Z<Tab>", ":Telekasten toggle_todo<CR>", "Toggle todo")

keymap("i", "<M-[>", "<cmd>Telekasten insert_link<CR>")

require("zk").setup { picker = "telescope" }

-- Create a new note after asking for its title.
keymap("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", "New note")
-- Open notes.
keymap("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", "Open notes")
-- Open notes associated with the selected tags.
keymap("n", "<leader>zt", "<Cmd>ZkTags<CR>", "Tags")
-- Search for the notes matching a given query.
keymap(
  "n",
  "<leader>zf",
  "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
  "Find notes"
)
-- Search for the notes matching the current visual selection.
keymap("v", "<leader>zf", ":'<,'>ZkMatch<CR>", "Find notes")
