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
    if not vim.g.vscode then return end

    local vscode = require("vscode") ---@diagnostic disable-line: different-requires
    local function action(cmd)
      return function() vscode.action(cmd) end
    end

    vim.opt.clipboard = "unnamedplus"

    vim.keymap.set("n", "u", action("undo"))
    vim.keymap.set("n", "<C-r>", action("redo"))

    vim.keymap.set("n", "[t", action("workbench.action.previousEditor"))
    vim.keymap.set("n", "]t", action("workbench.action.nextEditor"))
    vim.keymap.set("n", "]c", action("workbench.action.editor.nextChange"))
    vim.keymap.set("n", "[c", action("workbench.action.editor.previousChange"))
    vim.keymap.set("n", "]d", action("editor.action.marker.next"))
    vim.keymap.set("n", "[d", action("editor.action.marker.prev"))

    vim.keymap.set("n", "<leader>F", action("editor.action.formatDocument"))
    vim.keymap.set("v", "<leader>F", action("editor.action.formatSelection"))

    vim.keymap.set("n", "<leader>ls", action("workbench.action.gotoSymbol"))
    vim.keymap.set("n", "<leader>ff", action("workbench.action.quickOpen"))
    vim.keymap.set("n", "<leader>fb", action("workbench.action.showAllEditors"))
    vim.keymap.set("n", "<leader>fg", action("workbench.action.findInFiles"))
    vim.keymap.set("n", "<leader>/", action("workbench.action.findInFiles"))
  end,
})

---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
}
