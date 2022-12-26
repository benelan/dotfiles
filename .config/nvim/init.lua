if vim.g.vscode == 1 then return end
-- My NeoVim setup was originally forked from
-- https://github.com/LunarVim/nvim-basic-ide

require "user.globals"
require "user.options"
require "user.keymaps"
require "user.plugins"
require "user.autocommands"
require "user.setups.lsp"
