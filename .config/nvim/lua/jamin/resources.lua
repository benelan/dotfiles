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
  "zk"
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

M.i = function(icon, backup)
  if vim.g.use_devicons then return icon end
  return backup or ""
end

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
    user = "🯅", -- 🏄︎🏂︎ 🛉 🯅 🯆 🯈 🯇 🮲🮳👽︎
    storage = "⛁ ", -- 🗃 📚︎ 📟︎ ⛁ ⛃
    network = "🖧 ", -- 💻︎
    package = "📦︎",
    edit = "🖉 ",
    security = "🛡",
    settings = "🛠",
    pay = "💰︎",
    pin = "🖈 ",
    clock = "⏲ ",
    alert = "🕭 ",
    sleep = "🌜︎",
    awake = "⛾ ",
    search = "🔍︎",
    key = "🗝 ",
    globe = "🌎︎",
    map = "🗺 ",
  },
  lsp_kind = {
    Array = M.i(" "),
    Boolean = M.i(" "), -- 󰨙 ◩
    Class = M.i(" "), --     
    Codeium = M.i("󰘦 "),
    Color = M.i(" "),
    Comment = M.i(" "),
    Control = M.i(" "),
    Component = M.i(" "),
    Conditional = M.i(" "),
    Constant = M.i("󰭸 "),
    Constructor = M.i(" "), -- 
    Copilot = M.i(" "), --   
    Enum = M.i(" "),
    EnumMember = M.i(" "),
    Error = M.i("󰛉 "), -- 
    Event = M.i(" "),
    Field = M.i("󰓽 "), -- 
    File = M.i(" "),
    Folder = M.i(" "),
    Fragment = M.i(" "),
    Function = M.i(" "), -- 󰡱
    Interface = M.i(" "), -- 
    Key = M.i("󰷖 "), -- 󰌋   🗝
    Keyword = M.i(" "), -- 
    Macro = M.i(" "),
    TypeAlias = M.i(" "),
    Method = M.i(" "),
    StaticMethod = M.i(" "),
    Module = M.i(" "), -- 󰶮
    Namespace = M.i("󰦮 "), --   
    Null = M.i("󰟢 "),
    Number = M.i(" "),
    Object = M.i("󰅩 "),
    Operator = M.i(" "),
    Package = M.i(" "), -- 
    Property = M.i("󰓽 "), -- 
    Reference = M.i(" "), -- 
    Snippet = M.i("✀ "), -- ✀  
    Spell = M.i("󰓆 "),
    String = M.i("󱀍 "), --   
    Struct = M.i(" "),
    Text = M.i("󰈍 "), -- 󰦨
    TypeParameter = M.i(" "),
    Parameter = M.i(" "),
    Unit = M.i(" "),
    Value = M.i(" "), -- 󰠱
    Variable = M.i(" "),
    Fallback = M.i(" "), -- 󰒅  󰒉
  },
  diagnostics = {
    [vim.diagnostic.severity.ERROR] = M.i("󰅝 ", "E"),
    [vim.diagnostic.severity.WARN] = M.i("󰀪 ", "W"),
    [vim.diagnostic.severity.INFO] = M.i("󰋽 ", "I"),
    [vim.diagnostic.severity.HINT] = M.i("󰰀 ", "H"),
  },
  git = {
    status = "▎",
    branch = M.i("󰘬 "), -- ⛕  ⛙
    added = M.i("󰜄 ", "+"),
    changed = M.i("󱗝 ", "∗"),
    removed = M.i("󰛲 ", "‒"),
  },
  border = M.i({ "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }, "rounded"),
}

return M
