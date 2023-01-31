local res = require "user.resources"
local navic = require "nvim-navic"

navic.setup {
    icons = res.icons.kind,
    highlight = true,
    separator = " > ",
    depth_limit = 0,
    depth_limit_indicator = "..",
    safe_output = true
}
vim.opt.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
