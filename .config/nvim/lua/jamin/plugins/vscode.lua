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
  "lazy.nvim",
  "neogen",
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
    if vim.g.vscode then
      vim.keymap.set("n", "grr", "<CMD>call VSCodeNotify('editor.action.goToReferences')<CR>")
      vim.keymap.set("n", "grn", "<CMD>call VSCodeNotify('editor.action.rename')<CR>")
      vim.keymap.set("n", "grs", "<CMD>VSCodeNotify(workbench.action.gotoSymbol')<CR>")
      vim.keymap.set("n", "<leader>ff", "<CMD>call VSCodeNotify('workbench.action.quickOpen')<CR>")
      vim.keymap.set("n", "<leader>/", "<CMD>call VSCodeNotify('workbench.action.findInFiles')<CR>")
    end
  end,
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
  {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Neogen",
    opts = { snippet_engine = "nvim" },
  },
}
