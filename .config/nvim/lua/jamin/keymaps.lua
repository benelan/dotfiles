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

-- make all keymaps silent by default
local keymap_set = vim.keymap.set
---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  return keymap_set(mode, lhs, rhs, opts)
end

-- Clear search highlight and escape
vim.keymap.set({ "i", "n", "s" }, "<esc>", function()
  vim.cmd.noh()
  vim.cmd.echo()
  vim.snippet.stop()
  return "<esc>"
end, { expr = true, silent = true, noremap = true, desc = "Escape and Clear hlsearch" })

-- don't save empty lines to the default register
vim.keymap.set(
  "n",
  "dd",
  function() return vim.fn.getline(".") == "" and '"_dd' or "dd" end,
  { expr = true }
)

-- Add undo break points
local undo_before_chars = { "[", "(", "{", "<", "," }
for _, char in ipairs(undo_before_chars) do
  vim.keymap.set("i", char, "<C-g>u" .. char)
end

local undo_after_chars = { "?", ".", "!", ";", "]", ")", "}", ">" }
for _, char in ipairs(undo_after_chars) do
  vim.keymap.set("i", char, char .. "<C-g>u")
end

-- Add comment above/below cursor
vim.keymap.set(
  "n",
  "gco",
  "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>",
  { desc = "Add Comment Below" }
)
vim.keymap.set(
  "n",
  "gcO",
  "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>",
  { desc = "Add Comment Above" }
)

-- Delete marks on current line
vim.keymap.set("n", "dm", function()
  local cur_line = vim.fn.line(".")
  -- Delete buffer local mark
  for _, mark in ipairs(vim.fn.getmarklist(0)) do
    if mark.pos[2] == cur_line and mark.mark:match("[a-zA-Z]") then
      vim.api.nvim_buf_del_mark(0, string.sub(mark.mark, 2, #mark.mark))
      return
    end
  end
  -- Delete global marks
  local cur_buf = vim.api.nvim_win_get_buf(vim.api.nvim_get_current_win())
  for _, mark in ipairs(vim.fn.getmarklist()) do
    if mark.pos[1] == cur_buf and mark.pos[2] == cur_line and mark.mark:match("[a-zA-Z]") then
      vim.api.nvim_buf_del_mark(0, string.sub(mark.mark, 2, #mark.mark))
      return
    end
  end
end, { desc = "Mark on Current Line" })

vim.keymap.set("n", "<leader>I", function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input("I")
end, { desc = "Inspect Tree" })

-- Move Lines (accepts count in normal and visual modes)
vim.keymap.set("i", "<A-j>", "<esc><CMD>m .+1<CR>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<esc><CMD>m .-2<CR>==gi", { desc = "Move line up" })
vim.keymap.set("n", "<A-j>", "<CMD>execute 'move .+' . v:count1<CR>==", { desc = "Move line down" })
vim.keymap.set(
  "n",
  "<A-k>",
  "<CMD>execute 'move .-' . (v:count1 + 1)<CR>==",
  { desc = "Move line up" }
)
vim.keymap.set(
  "v",
  "<A-j>",
  ":<C-u>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv",
  { desc = "Move line down" }
)
vim.keymap.set(
  "v",
  "<A-k>",
  ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv",
  { desc = "Move line up" }
)

-- Change quickfix list
vim.keymap.set("n", "<M-i>", "<CMD>cnewer<CR>", { desc = "Next quickfix list" })
vim.keymap.set("n", "<M-o>", "<CMD>colder<CR>", { desc = "Previous quickfix list" })

-- Change quickfix item
vim.keymap.set("n", "<M-n>", "<CMD>cnext<CR>", { desc = "Next quickfix item" })
vim.keymap.set("n", "<M-p>", "<CMD>cprev<CR>", { desc = "Previous quickfix item" })

-- Goto diagnostics error/warning
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end

vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Previous Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Preiousv Warning" })
