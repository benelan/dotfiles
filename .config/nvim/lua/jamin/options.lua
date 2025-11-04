vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamed"
vim.opt.updatetime = 150
vim.opt.confirm = true
vim.opt.mouse = ""
vim.opt.virtualedit:append("block")
vim.opt.nrformats:append("unsigned")
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99
vim.opt.formatoptions:remove("t")

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.suffixes:append(Jamin.path.suffixes)
vim.opt.path = Jamin.path.include
vim.opt.wildignore = Jamin.path.ignore
vim.opt.wildignorecase = true
vim.opt.wildmode = "longest:full,full"
vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert", "popup", "fuzzy" }

-- https://github.com/wez/wezterm/issues/4607
if vim.env.WEZTERM_PANE ~= nil then vim.opt.termsync = false end

local ui = vim.api.nvim_list_uis() or {}
vim.opt.pumheight = #ui > 0 and math.floor(ui[1].height / 2) or 20

vim.opt.showtabline = 2
vim.opt.laststatus = 3
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.termguicolors = true

vim.opt.diffopt = {
  "internal",
  "filler",
  "closeoff",
  "algorithm:histogram",
  "foldcolumn:1",
  "linematch:60",
  "context:8",
  "indent-heuristic",
  "vertical",
}

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 8
vim.opt.linebreak = true
vim.opt.breakindent = true

vim.opt.shiftwidth = 4
vim.opt.softtabstop = -1
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 10000

vim.opt.spelloptions:append("camel")
vim.opt.spellfile:append(vim.fn.stdpath("config") .. "/spell/en.utf-8.add")

if vim.fn.filereadable("/usr/share/dict/words") == 1 then
  vim.opt.dictionary:append("/usr/share/dict/words")
else
  vim.opt.dictionary:append("spell")
end

vim.opt.showbreak = Jamin.icons.ui.linebreak
vim.opt.fillchars = { eob = Jamin.icons.ui.fill_shade, diff = Jamin.icons.ui.fill_slash }

if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --hidden --smart-case"
  vim.opt.grepformat = {
    "%f:%l:%c:%m",
    "%-G%.%#: No such file or directory (os error 2)",
    "%-GNo files were searched\\, which means ripgrep probably applied a filter you didn't expect.%.%#",
    "%-GRunning with --debug will show why files are being skipped.",
  }
end
