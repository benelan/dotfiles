local status_ok, lualine = pcall(require, "lualine")
if not status_ok then return end

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local lsp = {
  function()
    local msg = "LSP Inactive"
    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = " ",
  color = { gui = "bold" },
  component_separators = { left = "▎", right = "▎" },
  cond = conditions.buffer_not_empty
}

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn", "info" },
  symbols = { error = " ", warn = " ", info = " " },
  colored = true,
  always_visible = true,
}

local diff = {
  "diff",
  colored = true,
  symbols = { added = " ", modified = " ", removed = " " },
  cond = conditions.hide_in_width,
}

local filetype = {
  "filetype",
  icon_only = true,
  cond = conditions.buffer_not_empty
}

local fileformat = {
  "fileformat",
  padding_left = 1,
  cond = conditions.buffer_not_empty
}

-- local spaces = function()
--   return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
-- end

lualine.setup {
  options = {
    globalstatus = true,
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "dashboard", "NvimTree", "TelescopePrompt" },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { lsp, diff },
    lualine_x = { diagnostics },
    lualine_y = { fileformat, filetype, "encoding", "filesize" },
    lualine_z = { "location", "progress" },
  },
}

