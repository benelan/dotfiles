---Toggles a persistent floating terminal window
local function floating_term()
  local term_bufnr = vim.fn.bufnr "term://"
  local term_winnr = vim.fn.bufwinnr "term://"
  local curr_bufnr = vim.fn.bufnr "%"

  local win_count = vim.fn.winnr "$"
  local ui = vim.api.nvim_list_uis()[1]

  -- window dimensions are proportional to the editor size
  -- positioned in the bottom right corner of the editor
  local winopts = {
    relative = "editor",
    width = math.floor(ui.width / 3),
    height = math.floor(ui.height / 4),
    col = ui.width - 1,
    row = ui.height - 3,
    anchor = "SE",
    style = "minimal",
    border = "solid",
  }

  if term_winnr > 0 and win_count > 1 then
    vim.fn.execute(term_winnr .. "wincmd c")
  elseif term_bufnr and term_bufnr > 0 and term_bufnr ~= curr_bufnr then
    vim.api.nvim_open_win(term_bufnr, true, winopts)
    vim.fn.execute "startinsert"
  else
    vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, winopts)

    vim.fn.execute "term"
    vim.cmd "set winfixheight nobuflisted"
    vim.fn.execute "startinsert"
  end
end

vim.api.nvim_create_user_command("TermToggle", floating_term, { desc = "Toggle floating terminal" })

keymap("n", "<M-t>", "<CMD>TermToggle<CR>", "Open floating terminal")
keymap("t", "<M-t>", "<CMD>TermToggle<CR>", "Close floating terminal")

-----------------------------------------------------------------------------

---Toggles between the default and maximized height of the floating terminal
local function toggle_term_height()
  local ui = vim.api.nvim_list_uis()[1]
  local default_size = math.floor(ui.height / 4)

  if vim.api.nvim_win_get_height(0) == default_size then
    vim.api.nvim_win_set_height(0, ui.height - 7)
  else
    vim.api.nvim_win_set_height(0, default_size)
  end
end

keymap("t", "<M-m>", toggle_term_height, "Toggle floating terminal height")

-----------------------------------------------------------------------------

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

  vim.schedule(function()
    vim.diagnostic[cmd](event.bang and nil or 0)
  end)
end

vim.api.nvim_create_user_command("DiagnosticToggle", diagnostic_toggle, {
  bang = true,
  desc = "Toggles diagnostics for the current buffer, or globally if called with a bang",
})

keymap("n", "<leader>sd", "<CMD>DiagnosticToggle<CR>", "Toggle buffer diagnostics")
keymap("n", "<leader>sD", "<CMD>DiagnosticToggle!<CR>", "Toggle global diagnostics")

-----------------------------------------------------------------------------

local ui_disabled = false

---Toggle a variety of UI options to reduce noise while presenting or coding
local function ui_toggle()
  -- toggle options
  vim.opt.relativenumber = ui_disabled
  vim.opt.number = ui_disabled
  vim.opt.spell = ui_disabled
  vim.opt.cursorline = ui_disabled
  vim.opt.ruler = ui_disabled
  vim.opt.showmode = ui_disabled
  -- vim.bo.modifiable = ui_disabled

  vim.opt.signcolumn = ui_disabled and "yes" or "no"
  vim.opt.laststatus = ui_disabled and 3 or 0
  vim.opt.showtabline = ui_disabled and 2 or 0

  vim.opt.fillchars:append(
    "eob:" .. (ui_disabled and require("jamin.resources").icons.ui.fill_shade or " ")
  )

  -- toggle lsp diagnostics
  vim.schedule(function()
    vim.diagnostic[ui_disabled and "disable" or "enable"](nil)
  end)

  -- toggle matchup popup
  if vim.g.loaded_matchup == 1 then
    vim.g.matchup_matchparen_offscreen = { method = ui_disabled and "popup" or "" }
  end

  -- redraw treesitter context which gets messed up
  if vim.fn.exists ":TSContextToggle" then
    vim.cmd "TSContextToggle"
    vim.cmd "TSContextToggle"
  end

  -- toggle eyeliner.nvim highlighting
  if vim.fn.exists ":EyelinerEnable" then
    vim.cmd(ui_disabled and "EyelinerEnable" or "EyelinerDisable")
  end

  ui_disabled = not ui_disabled
end

vim.api.nvim_create_user_command(
  "UIToggle",
  ui_toggle,
  { desc = "Toggles a variety of UI options to reduce noise while presenting/coding" }
)

keymap("n", "<leader>su", "<CMD>UIToggle<CR>", "Toggle UI noise")
