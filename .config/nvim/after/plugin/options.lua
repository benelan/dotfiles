vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.guifont = "Iosevka,Ubuntu_Mono,monospace:h12"
vim.opt.updatetime = 200
vim.opt.confirm = true
vim.opt.virtualedit:append "block"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

if vim.fn.executable "rg" == 1 then
  vim.opt.grepprg = "rg --vimgrep --hidden --glob '!.git'"
end
vim.opt.hlsearch = false
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
vim.opt.pumheight = math.floor(vim.api.nvim_list_uis()[1].height / 2) or 20

vim.opt.showcmd = false
vim.opt.showtabline = 2
vim.opt.laststatus = 3
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

vim.opt.diffopt:append "algorithm:patience,indent-heuristic"
vim.opt.fillchars = "diff:╱" -- the default looks too much like a fold
vim.opt.listchars:append "extends:»,precedes:«"
vim.opt.linebreak = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.tabstop = 2
vim.opt.softtabstop = -1

vim.opt.spelloptions:append "camel"
vim.opt.spellfile:append(vim.fn.stdpath "config" .. "/spell/en.utf-8.add")

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.backupskip:append "/dev/shm/*,/usr/tmp/*,/var/tmp/*,*/systemd/user/*"
