---------->             Mapping  Modes                  <----------
-------------------------------------------------------------------
-->    <Space>     Normal, Visual, Select and Operator-pending    |
-->          n     Normal                                         |
-->          v     Visual and Select                              |
-->          s     Select                                         |
-->          x     Visual                                         |
-->          o     Operator-pending                               |
-->          !     Insert and Command-line                        |
-->          i     Insert                                         |
-->          l     Insert, Command-line and LanArg                |
-->          c     Command-line                                   |
-->          t     Terminal-Job                                   |
-------------------->  :h map-listing  <---------------------------

-- Clear search highlight and escape
keymap({ "i", "n" }, "<ESC>", "<CMD>noh<CR><esc>", "Clear hls and escape")

-- Add undo break points
local undo_before_chars = { "[", "(", "{", "<", "," }
for _, char in ipairs(undo_before_chars) do
  keymap("i", char, "<C-g>u" .. char)
end

local undo_after_chars = { "?", ".", "!", ";", "]", ")", "}", ">" }
for _, char in ipairs(undo_after_chars) do
  keymap("i", char, char .. "<C-g>u")
end

-- Move Lines
keymap("n", "<M-j>", "<CMD>m .+1<CR>==", "Move line down")
keymap("n", "<M-k>", "<CMD>m .-2<CR>==", "Move line up")
keymap("i", "<M-j>", "<esc><CMD>m .+1<CR>==gi", "Move line down")
keymap("i", "<M-k>", "<esc><CMD>m .-2<CR>==gi", "Move line up")
keymap("v", "<M-j>", ":m '>+1<CR>gv=gv", "Move line down")
keymap("v", "<M-k>", ":m '<-2<CR>gv=gv", "Move line up")

-- Switch quickfix list
keymap("n", "<M-o>", "<CMD>colder<CR>", "Previous quickfix list")
keymap("n", "<M-i>", "<CMD>cnewer<CR>", "Next quickfix list")

-- Goto diagnostics error/warning
keymap(
  "n",
  "]e",
  function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, float = true }) end,
  "Next diagnostic error"
)

keymap(
  "n",
  "[e",
  function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, float = true }) end,
  "Previous diagnostic error"
)

keymap(
  "n",
  "]w",
  function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN, float = true }) end,
  "Next diagnostic warning"
)

keymap(
  "n",
  "[w",
  function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN, float = true }) end,
  "Previous diagnostic warning"
)

-- toggle treesitter highlighting
keymap("n", "<leader>sth", function()
  if vim.b.ts_highlight then
    vim.treesitter.stop()
    print("treesitter highlighting stopped")
  else
    vim.treesitter.start()
    print("treesitter highlighting started")
  end
end, "Toggle treesitter highlighting")

---Toggles diagnostics for the current buffer, or globally if called with a bang
---@param event table The event that triggered the command. If event.bang is true
local function diagnostic_toggle(event)
  local vars = event.bang and vim.g or vim.b
  vars.diagnostics_disabled = not vars.diagnostics_disabled

  local cmd = vars.diagnostics_disabled and "disable" or "enable"

  vim.api.nvim_echo({
    {
      string.format("%s diagnostics %sd", event.bang and "Global" or "Buffer", cmd),
    },
  }, false, {})

  vim.schedule(function() vim.diagnostic[cmd](event.bang and nil or 0) end)
end

vim.api.nvim_create_user_command("DiagnosticToggle", diagnostic_toggle, {
  bang = true,
  desc = "Toggles diagnostics for the current buffer, or globally if called with a bang",
})

keymap("n", "<leader>sd", "<CMD>DiagnosticToggle<CR>", "Toggle buffer diagnostics")
keymap("n", "<leader>sD", "<CMD>DiagnosticToggle!<CR>", "Toggle global diagnostics")
