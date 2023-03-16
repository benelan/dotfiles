local utils = require "utils"
local keymaps = require "keymaps"
local options = require "options"
require("right-status").setup()

return utils.merge_tables(keymaps, options)
