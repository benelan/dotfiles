vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.guifont = "Iosevka,Ubuntu_Mono,monospace:h12"
vim.opt.updatetime = 100
vim.opt.confirm = true
vim.opt.pastetoggle = "<leader><C-v>"

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
vim.opt.wildignore:append(
  ".git/*,node_modules/*,dist/*,build/*"
    .. "*.7z,*.avi,*.db,*.docx,*.filepart,*.flac,"
    .. "*.gif,*.gifv,*.gpg,*.gz,*.ico,*.iso,*.jpeg,*.jpg,"
    .. "*.m4a,*.mkv,*.mp3,*.mp4,*.min.*,*.odt,*.ogg,"
    .. "*.pbm,*.pdf,*.png,*.ppt,*.psd,*.pyc,*.rar,"
    .. "*.sqlite*,*.swp,*.tar,*.tga,*.ttf,*.wav,*.webm,"
    .. "*.xbm,*.xcf,*.xls,*.xlsx,*.xpm,*.xz,*.zip"
)
vim.opt.path = ".,src/**,api/**,lua/**,utils/**,static,config,,"
vim.opt.backupskip:append "/dev/shm/*,/usr/tmp/*,/var/tmp/*,*/systemd/user/*"
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.opt.laststatus = 3
vim.opt.showtabline = 2
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
vim.opt.tabstop = 2
vim.opt.softtabstop = -1

vim.opt.spelloptions:append "camel"
vim.opt.spellfile:append(vim.fn.stdpath "config" .. "/spell/en.utf-8.add")

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 4269

vim.opt.statusline = "%!v:lua.StatusLine()"

local function table_length(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end
  return count
end

local function git_branch()
  if
    vim.fn.exists "g:loaded_fugitive" == 1
    and vim.fn["FugitiveGitDir"]() ~= vim.fn.expand "~/.git"
    and vim.fn["fugitive#Head"]() ~= ""
  then
    return " " .. vim.fn["fugitive#Head"]()
  -- elseif vim.b.gitsigns_head then
  --   return "  " .. vim.b.gitsigns_head
  end
  return ""
end

local function buffer_diagnostics()
  return string.format(
    "%s%s%d%s%s%d%s%s%d",
    "%#ErrorFloat#", -- "%#DiagnosticVirtualTextError#",
    "    ",
    table_length(vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.ERROR,
    })),
    "%#WarningFloat#", -- "%#DiagnosticVirtualTextWarn#",
    "    ",
    table_length(vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.WARN,
    })),
    "%#HintFloat#", -- "%#DiagnosticVirtualTextHint#",
    "    ", -- " ",
    table_length(vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.HINT,
    }))
  )
end

function StatusLine()
  return "%#TabLineSel#  "
    .. "[%n]%m%r%h%w%q%y  "
    .. buffer_diagnostics()
    .. "  %#TabLineFill#  "
    .. git_branch()
    .. "  %="
    .. "%#NormalFloat#  " -- .. "%#Normal#  "
    .. "%f  "
    .. "%#TabLineSel#  "
    .. "%c:[%l/%L]%<  "
end
