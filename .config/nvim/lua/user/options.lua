vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.guifont = "Iosevka,Ubuntu_Mono,monospace:h12"
vim.opt.updatetime = 100
vim.opt.confirm = true
vim.opt.pastetoggle = "<Leader><C-v>"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

if vim.fn.executable "rg" == 1 then
  vim.opt.grepprg = "rg --vimgrep --hidden --glob '!.git'"
end
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.path:append "src/**,api/**,lua/**,utils/**,static,config"
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true
vim.opt.wildignore:append(
  "*~,#*#,*.7z,.DS_Store,.git/*,.hg,.svn,"
    .. "*.a,*.adf,*.asc,*.au,*.aup,*.avi,*.bmp,*.bz2,"
    .. "*.class,*.db,*.dbm,*.djvu,*.docx,*.exe,*.filepart,*.flac,*.gd2,"
    .. "*.gif,*.gifv,*.gmo,*.gpg,*.gz,*.hdf,*.ico,*.iso,*.jar,*.jpeg,*.jpg,"
    .. "*.m4a,*.mid,*.mkv,*.mp3,*.mp4,*.o,*.odp,*.ods,*.odt,*.ogg,*.ogv,*.opus,"
    .. "*.pbm,*.pdf,*.png,*.ppt,*.psd,*.pyc,*.rar,*.rm,"
    .. "*.s3m,*.sdbm,*.sqlite,*.swf,*.swp,*.tar,*.tga,*.ttf,*.wav,*.webm,"
    .. "*.xbm,*.xcf,*.xls,*.xlsx,*.xpm,*.xz,*.zip,"
    .. "*/node_modules/*,*/dist/*,*/build/*"
)

vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.laststatus = 3
vim.opt.showtabline = 2
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.numberwidth = 2

vim.opt.diffopt:append "algorithm:patience,indent-heuristic"
vim.opt.fillchars = "diff:╱"
vim.opt.listchars = [[extends:»,precedes:«,trail:·,multispace:· ,nbsp:_]]
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = -1

vim.opt.spelloptions:append "camel"
vim.opt.spellfile:append(vim.fn.stdpath "config" .. "/spell/en.utf-8.add")

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 4269
