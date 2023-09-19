-- Toggles a floating terminal window
local function floating_term()
  ---@diagnostic disable: param-type-mismatch
  local term_bufnr = vim.fn.bufnr "term://"
  local term_winnr = vim.fn.bufwinnr "term://"
  local curr_bufnr = vim.fn.bufnr "%"
  ---@diagnostic enable: param-type-mismatch

  local win_count = vim.fn.winnr "$"
  local ui = vim.api.nvim_list_uis()[1]
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

-- Toggle a variety of UI options to reduce noise while presenting or coding
local noise_disabled = false
local function noise_toggle()
  -- toggle options
  -- vim.bo.modifiable = noise_disabled
  vim.opt.relativenumber = noise_disabled
  vim.opt.number = noise_disabled
  vim.opt.spell = noise_disabled
  vim.opt.cursorline = noise_disabled
  vim.opt.ruler = noise_disabled
  vim.opt.showmode = noise_disabled
  vim.opt.signcolumn = noise_disabled and "yes" or "no"
  vim.opt.laststatus = noise_disabled and 3 or 0
  vim.opt.showtabline = noise_disabled and 2 or 0
  vim.opt.fillchars:append("eob:" .. (noise_disabled and "~" or " "))

  -- toggle lsp diagnostics
  vim.schedule(function()
    vim.diagnostic[noise_disabled and "disable" or "enable"](nil)
  end)

  -- toggle matchup popup
  if vim.g.loaded_matchup == 1 then
    vim.g.matchup_matchparen_offscreen = { method = noise_disabled and "popup" or "" }
  end

  -- -- redraw treesitter context which gets messed up
  if vim.fn.exists ":TSContextToggle" then
    vim.cmd "TSContextToggle"
    vim.cmd "TSContextToggle"
  end

  -- toggle eyeliner.nvim highlighting
  if vim.fn.exists ":EyelinerEnable" then
    vim.cmd(noise_disabled and "EyelinerEnable" or "EyelinerDisable")
  end

  noise_disabled = not noise_disabled
end

vim.api.nvim_create_user_command(
  "NoiseToggle",
  noise_toggle,
  { desc = "Toggles a variety of UI options to reduce noise while presenting/coding" }
)

keymap("n", "<leader>su", "<CMD>UIToggle<CR>", "Toggle UI noise")
