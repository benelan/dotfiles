vim.opt.clipboard = "unnamed"
vim.opt.updatetime = 200
vim.opt.confirm = true
vim.opt.modeline = false
vim.opt.virtualedit:append "block"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99

if vim.fn.executable "rg" == 1 then
  vim.opt.grepprg = "rg --vimgrep --hidden --no-heading --glob '!{.git,node_modules}'"
  vim.opt.grepformat = {
    "%f:%l:%c:%m",
    "%-GNo files were searched\\, which means ripgrep probably applied a filter you didn't expect. Try running again with --debug.",
    "%-GNo files were searched\\, which means ripgrep probably applied a filter you didn't expect.",
    "%-GRunning with --debug will show why files are being skipped.",
  }
end

vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.wildignorecase = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append(
  ".git/*,node_modules/*,dist/*,build/*"
    .. "*.7z,*.avi,*.db,*.docx,*.filepart,*.flac,"
    .. "*.gif,*.gifv,*.gpg,*.gz,*.ico,*.iso,*.jpeg,*.jpg,"
    .. "*.m4a,*.mkv,*.mp3,*.mp4,*.min.*,*.odt,*.ogg,"
    .. "*.pbm,*.pdf,*.png,*.ppt,*.psd,*.pyc,*.rar,"
    .. "*.sqlite*,*.swp,*.tar,*.tga,*.ttf,*.wav,*.webm,"
    .. "*.xbm,*.xcf,*.xls,*.xlsx,*.xpm,*.xz,*.zip"
)
vim.opt.path = ".,./src/**,./api/**,./lua/**,./utils/**,./static,./config,,"
vim.opt.completeopt = { "menu", "menuone", "noselect" }

local ui = vim.api.nvim_list_uis()
vim.opt.pumheight = #ui > 0 and math.floor(ui[1].height / 2) or 20

vim.opt.showtabline = 2
vim.opt.laststatus = 3
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

vim.opt.diffopt:append "algorithm:patience,indent-heuristic"
vim.opt.linebreak = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.tabstop = 2
vim.opt.softtabstop = -1
vim.opt.shiftwidth = 0
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.spelloptions:append "camel"
vim.opt.spellfile:append(vim.fn.stdpath "config" .. "/spell/en.utf-8.add")

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.o.switchbuf = "useopen,uselast"

vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.backupskip:append "/dev/shm/*,/usr/tmp/*,/var/tmp/*,*/systemd/user/*"

local has_res, res = pcall(require, "jamin.resources")
if has_res then
  vim.opt.fillchars = { diff = res.icons.ui.fill_slash }
  vim.opt.listchars = {
    extends = res.icons.ui.extends,
    precedes = res.icons.ui.precedes,
    trail = res.icons.ui.fill_dot,
    lead = res.icons.ui.fill_dot,
    leadmultispace = res.icons.ui.separator
      .. string.rep(" ", vim.api.nvim_get_option_value("shiftwidth", {}) / 2),
    nbsp = res.icons.ui.nbsp,
    eol = res.icons.ui.eol,
  }
end
