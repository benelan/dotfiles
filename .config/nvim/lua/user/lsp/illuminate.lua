local status_ok, illuminate = pcall(require, "illuminate")
local res_status_ok, res = pcall(require, "user.resources")
if not status_ok or not res_status_ok then return end

illuminate.configure {
  providers = {
    "lsp",
    "treesitter",
  },
  delay = 200,
  filetypes_denylist = res.exclude_filetypes,
}

-- Keymaps
vim.api.nvim_set_keymap('n', '<M-n>',
  '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>',
  { noremap = true })

vim.api.nvim_set_keymap('n', '<M-p>',
  '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
  { noremap = true })


vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my-illumination", {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    require("illuminate").on_attach(client)
  end,
})
