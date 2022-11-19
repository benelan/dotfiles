vim.opt.backup = false                          -- creates a backup file
vim.opt.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard
vim.opt.cmdheight = 1                           -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menuone", "noselect", "noselect" } -- options for cmp
vim.opt.pastetoggle = "<Leader><C-v>"           -- toggle automatically indenting pastes
vim.opt.conceallevel = 0                        -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.hlsearch = true                         -- highlight all matches on previous search pattern
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.smartcase = true                        -- smart case
vim.opt.mouse = "a"                             -- allow the mouse to be used in neovim
vim.opt.mousehide = true                        -- hide the mouse while typing
vim.opt.pumheight = 10                          -- pop up menu height
vim.opt.showmode = false                        -- we don"t need to see things like -- INSERT -- anymore
vim.opt.showtabline = 0                         -- always show tabs
vim.opt.smartindent = true                      -- make indenting smarter again
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                        -- creates a swapfile
vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 1000                       -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true                         -- enable persistent undo
vim.opt.updatetime = 300                        -- faster completion (4000ms default)
vim.opt.writebackup = false                     -- don't need backups when overwriting files
vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.shiftwidth = 2                          -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2                             -- insert 2 spaces for a tab
vim.opt.breakindentopt = "shift:2"              -- Shift two characters left when breakindent-ing
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.relativenumber = true                   -- show +/- offset number from the current line
vim.opt.number = true                           -- show the current line number instead of 0
vim.opt.laststatus = 3                          -- only the last window will always have a status line
vim.opt.showcmd = false                         -- hide command in the last line of the screen (for performance)
vim.opt.ruler = false                           -- hide the line and column number of the cursor position
vim.opt.numberwidth = 4                         -- minimal number of columns to use for the line number {default 4}
vim.opt.signcolumn = "yes"                      -- always show the sign column to prevent text shifting
vim.opt.wrap = true                             -- display lines as one long line
vim.opt.linebreak = true                        -- don't wrap in the middle of words
vim.opt.scrolloff = 8                           -- minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 8                       -- left/right column padding, only applies when wrap=false
vim.opt.foldenable = true                       -- enable folding
vim.opt.foldmethod = "expr"                     -- use foldexpr to set fold (below)
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- use treesitter to determine fold
vim.opt.foldlevelstart = 99                     -- start with all folds closed
vim.opt.foldlevel = 99                          -- set the fold level to closed
vim.opt.foldcolumn = "1"                        -- how many fold columns to display
vim.opt.grepprg = "rg --vimgrep"                -- Use ripgrep instead of grep
vim.opt.shortmess:append("c")                   -- hide all completion messages ("match 1 of 2", "Pattern not found")
vim.opt.whichwrap:append("<,>,[,]")             -- keys to move to the previous/next line when at the start/end of line
vim.opt.iskeyword:append("-")                   -- treats words with `-` as single words
vim.opt.confirm = true                          -- raise a dialog instead of failing operations like quit or write
vim.opt.spelloptions:append("camel")            -- When a word is CamelCased, assume "Cased" is aseparate word
vim.opt.formatoptions:append("l,1,j,p")         -- :help formatoptions
vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.opt.guifont = "JetBrainsMono_Nerd_Font:h11,SauceCodePro_Nerd_Font:h12,Iosevka:h12,monospace:h12"
