local M = {}

M.filetypes = {
  excluded = {
    "-",
    "TelescopePreview",
    "TelescopePrompt",
    "TelescopeResults",
    "checkhealth",
    "cmp_menu",
    "fugitive",
    "fugitiveblame",
    "help",
    "lazy",
    "lspinfo",
    "man",
    "mason",
    "netrw",
    "qf",
    "undotree",
  },
  writing = {
    "gitcommit",
    "mail",
    "markdown",
    "octo",
    "org",
    "text",
  },
  marker_folds = {
    "",
    "conf",
    "text",
    "swayconfig",
    "i3config",
    "sh",
    "tmux",
    "vim",
    "vifm",
  },
}

M.lsp_servers = {
  "astro",
  "bashls",
  "cssls",
  -- "docker_compose_language_service",
  "dockerls",
  -- "emmet_language_server",
  "eslint",
  -- "gopls",
  -- "graphql",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  -- "mdx_analyzer",
  -- "pyright",
  -- "rust_analyzer",
  -- "sqlls",
  "svelte",
  "tailwindcss",
  "taplo",
  "tsserver",
  "vimls",
  "volar",
  "yamlls",
}

M.mason_packages = {
  "actionlint", -- github action linter
  "fixjson", -- json formatter
  "hadolint", -- dockerfile linter
  "markdownlint", -- markdown linter and formatter
  "prettier", -- everything formatter
  "shellcheck", -- shell linter
  "shfmt", -- shell formatter
  "stylelint", -- css/scss linter
  "stylua", -- lua formatter
}

M.treesitter_parsers = {
  "astro",
  "bash",
  "css",
  "diff",
  "dockerfile",
  "git_rebase",
  "gitcommit",
  "go",
  -- "gomod",
  -- "gosum",
  -- "gowork",
  "graphql",
  "html",
  "http",
  -- "ini",
  "javascript",
  "jsdoc",
  "json",
  "json5",
  "jsonc",
  -- "latex",
  "lua",
  "luadoc",
  "luap",
  "make",
  "markdown",
  "markdown_inline",
  -- "perl",
  "printf",
  "python",
  "query",
  "regex",
  -- "rst",
  -- "rust",
  "scss",
  "sql",
  "svelte",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "xml",
  "yaml",
}

M.path = {
  include = {
    ".",
    "",
    "src/**",
    "api/**",
    "lua/**",
    "utils/**",
    "scripts/**",
    "support/**",
    "server/**",
    "packages/**",
    "apps/**",
    "examples/**",
    "docs/**",
    "tests/**",
    ".github/**",
    "static",
    "config",
    "public",
  },
  suffixes = {
    ".db",
    ".doc",
    ".gif",
    ".gpg",
    ".ico",
    ".jpeg",
    ".jpg",
    ".lock",
    ".odt",
    ".orig",
    ".pdf",
    ".png",
    ".tmp",
  },
  ignore = {
    "*.7z",
    "*.avi",
    "*.docx",
    "*.filepart",
    "*.flac",
    "*.gifv",
    "*.gz",
    "*.iso",
    "*.m4a",
    "*.mkv",
    "*.mp3",
    "*.mp4",
    "*.min.*",
    "*.ogg",
    "*.pbm",
    "*.ppt",
    "*.psd",
    "*.pyc",
    "*.rar",
    "*.sqlite*",
    "*.swp",
    "*.tar",
    "*.tga",
    "*.ttf",
    "*.wav",
    "*.webm",
    "*.xbm",
    "*.xcf",
    "*.xls",
    "*.xlsx",
    "*.xpm",
    "*.xz",
    "*.zip",
    ".git/*",
    "build/*",
    "dist/*",
    "node_modules/*",
  },
}

local i = function(icon, backup) return vim.g.use_devicons and icon or backup or "" end

M.icons = {
  ui = {
    -- utf8 icons don't need fallbacks
    prompt = "❱ ",
    select = "➤  ",
    play = "⯈ ",
    skip = "⏩︎",
    x = "✘ ",
    checkmark = "✔ ",
    question_mark = "？",
    square = "■ ",
    box = "☐ ",
    box_checked = "☑ ",
    box_crossed = "☒ ",
    box_dot = "🞔 ",
    circle = "● ",
    collapsed = "🞂 ",
    expanded = "🞃 ",
    eol = "⤶",
    linebreak = "↳ ",
    nbsp = "␣",
    extends = "»",
    precedes = "«",
    ellipses = "…  ",
    dot = "·",
    dot_outline = "◦",
    indentline = "▏",
    fill_slash = "╱",
    fill_shade = "░",
    fill_solid = "█",
    speech_bubble = "🗩 ",
    pencil = "🖉 ",
    pin = "🖈 ",
    clock = "⏲ ",
    bell = "🕭 ",
    map = "🗺 ",
    key = "🗝 ",
  },
  lsp_kind = {
    Array = i(" "),
    Boolean = i(" "), -- 󰨙 ◩
    Class = i(" "), --     
    Codeium = i("󰘦 "),
    Color = i(" "),
    Comment = i(" "),
    Control = i(" "),
    Component = i(" "),
    Conditional = i(" "),
    Constant = i("󰭸 "),
    Constructor = i(" "), -- 
    Copilot = i(" "), --   
    Enum = i(" "),
    EnumMember = i(" "),
    Error = i("󰛉 "), -- 
    Event = i(" "),
    Field = i("󰓽 "), -- 
    File = i(" "),
    Folder = i(" "),
    Fragment = i(" "),
    Function = i(" "), -- 󰡱
    Interface = i(" "), -- 
    Key = i("󰷖 "), -- 󰌋   🗝
    Keyword = i(" "), -- 
    Macro = i(" "),
    TypeAlias = i(" "),
    Method = i(" "),
    StaticMethod = i(" "),
    Module = i(" "), -- 󰶮
    Namespace = i("󰦮 "), --   
    Null = i("󰟢 "),
    Number = i(" "),
    Object = i("󰅩 "),
    Operator = i(" "),
    Package = i(" "), -- 
    Property = i("󰓽 "), -- 
    Reference = i(" "), -- 
    Snippet = i(" "),
    Spell = i("󰓆 "),
    String = i("󱀍 "), --   
    Struct = i(" "),
    Text = i("󰈍 "), -- 󰦨
    TypeParameter = i(" "),
    Parameter = i(" "),
    Unit = i(" "),
    Value = i(" "), -- 󰠱
    Variable = i(" "),
    Fallback = i(" "), -- 󰒅  󰒉
  },
  diagnostics = {
    [vim.diagnostic.severity.ERROR] = i("󰅝 ", "E"),
    [vim.diagnostic.severity.WARN] = i("󰀪 ", "W"),
    [vim.diagnostic.severity.INFO] = i("󰋽 ", "I"),
    [vim.diagnostic.severity.HINT] = i("󰰀 ", "H"),
  },
  git = {
    status = "▎",
    branch = i(" "),
    added = i("󰜄 ", "+"),
    changed = i("󱗝 ", "∗"),
    removed = i("󰛲 ", "‒"),
  },
  border = "rounded", -- i({ "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }, "rounded"),
}

return M
