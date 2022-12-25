local utils = require("utils")
local keymaps = require("config.keymaps")
local options = require("config.options")
require("config.right-status").setup()

return utils.merge_tables(keymaps, options)
