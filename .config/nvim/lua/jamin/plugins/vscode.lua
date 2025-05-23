-- requires the VSCode Neovim extension:
-- https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim
--
-- lazy spec yoinked from LazyVim:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/vscode.lua

if not vim.g.vscode then return {} end

local enabled = {
  "bullets.vim",
  "debugprint.nvim",
  "dial.nvim",
  "flash.nvim",
  "lazy.nvim",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "nvim-ts-autotag",
  "treesj",
  "ts-comments.nvim",
  "vim-closer",
  "vim-repeat",
  "vim-surround",
  "vim-table-mode",
}

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
  ---@diagnostic disable-next-line: undefined-field
  return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
end

-- Add some vscode specific keymaps
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- stylua: ignore
    if vim.g.vscode then
      vim.keymap.set("n", "u", "<CMD>lua require('vscode').action('undo')<CR>")
      vim.keymap.set("n", "<C-r>", "<CMD>lua require('vscode').action('redo')<CR>")

      vim.keymap.set("n", "gr", "<CMD>lua require('vscode').action('editor.action.goToReferences')<CR>")
      vim.keymap.set("n", "cd", "<CMD>lua require('vscode').action('editor.action.rename')<CR>")
      vim.keymap.set("n", "gS", "<CMD>lua require('vscode').action('workbench.action.gotoSymbol')<CR>")

      vim.keymap.set("n", "<leader>ff", "<CMD>lua require('vscode').action('workbench.action.quickOpen')<CR>")
      vim.keymap.set("n", "<leader>/", "<CMD>lua require('vscode').action('workbench.action.findInFiles')<CR>")

      vim.keymap.set("n", "[t", "<CMD>lua require('vscode').action('workbench.action.previousEditor')<CR>")
      vim.keymap.set("n", "]t", "<CMD>lua require('vscode').action('workbench.action.nextEditor')<CR>")
    end
  end,
})

---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
}
