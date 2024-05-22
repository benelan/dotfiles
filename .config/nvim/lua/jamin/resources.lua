local M = {}

M.filetypes = {
  excluded = {
    "-",
    "Outline",
    "OverseerList",
    "OversserForm",
    "TelescopePreview",
    "TelescopePrompt",
    "TelescopeResults",
    "Trouble",
    "chatgpt-input",
    "checkhealth",
    "cmp_menu",
    "copilot-chat",
    "dap-preview",
    "dap-repl",
    "dap-terminal",
    "dapui_breakpoints",
    "dapui_console",
    "dapui_hover",
    "dapui_scopes",
    "dapui_stacks",
    "dapui_watches",
    "floggraph",
    "fugitive",
    "fugitiveblame",
    "harpoon",
    "help",
    "lazy",
    "lspinfo",
    "man",
    "mason",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "netrw",
    "octo",
    "qf",
    "undotree",
  },
  writing = {
    "asciidoc",
    "changelog",
    "chatgpt-input",
    "copilot-chat",
    "gitcommit",
    "mail",
    "markdown",
    "octo",
    "org",
    "pdf",
    "rmd",
    "rrst",
    "rst",
    "text",
  },
  webdev = {
    "astro",
    "html",
    "javascript",
    "javascriptreact",
    "svelte",
    "typescript",
    "typescriptreact",
    "vue",
  },
  marker_folds = {
    "",
    "conf",
    "text",
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
  -- "efm",
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
  -- "typos_lsp",
  -- "tsserver",
  "vimls",
  "volar",
  "yamlls",
  "zk",
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
  -- "printf",
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
    docs = i(" ", "🖹 "),
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
    separator = "┊",
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
  debug = {
    breakpoint = i("󰆤 ", "B"),
    breakpoint_condition = i("󱄶 ", "C"),
    breakpoint_rejected = i("󰽅 ", "R"),
    logpoint = i("󰆣 ", "L"),
    stopped = i("󰿅 ", "S"),
  },
  git = {
    branch = i(" "),
    added = i("󰜄 ", "+"),
    changed = i("󱗝 ", "∗"),
    removed = i("󰛲 ", "‒"),
  },
  progress = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
  border = "rounded", -- i({ "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }, "rounded"),
}

M.icons.test = {
  passed = i("󰗡 ", M.icons.ui.checkmark),
  running = i("󰁚 ", M.icons.ui.play),
  skipped = i("󰍷 ", M.icons.ui.skip),
  failed = i("󰅚 ", M.icons.ui.x),
  unknown = i("󰘥 ", M.icons.ui.question_mark),
  running_animated = M.icons.progress,
}

M.art = {
  bender_ascii = [[
          _
         ( )
          H
          H
         _H_
      .-'-.-'-.
     /         \
    |           |
    |   .-------'._     ,--------------------.
    |  / /  '.' '. \    | Hey lazy dev, want |
    |  \ \ @   @ / /    |   me to replace    |
    |   '---------'     |    all humans?     |
    |  .'-+-+-+|        ,--------------------'
    |  `.-+-+-+|    ---'
    |    """""" |
    '-.__   __.-'
         """
  ]],
  bender_dots = [[
                  ⠘⡀ Hey⠀lazy dev, want ⡜
                   ⠑⡀⠀ me to replace   ⡜
 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠐⣵    ⠈⠢⢄⠀all humans? ⣀⠴⠊
 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⡀   ⠀⠀⢸⠀⠀⠀⢀⣀⣀⣀⣀⡀⠤⠄⠒⠈
 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠀⡇    ⠀⠘⣀⠄⠊⠁
 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠚⠒⠊⣲⠤⣀
 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⠈⠀⠈⠉⠉⠀⠀⠀⠉⢆
 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇
 ⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
 ⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⡠⠀⠒⠀⠀⠀⠐⠒⠒⠈⠐⠠⡀
 ⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠐⠀⠀⡔⠈⠙⠛⠻⢿⠿⠛⠉⠻⣷⡕⡄
 ⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⢠⠀⠀⡀⠰⠆⠀⠀⢈⠰⠶⠀⢠⣿⡿⡇
 ⠀⠀⠀⠀⠀⠀⠀⠀⢸⡀⠀⠀⠑⠠⠬⠅⠐⠒⠒⠓⠲⢶⠶⠯⠉⠂⠁
 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⣀⣀⠀⢀⠀⠀⡀⠀⣀⠸
 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⣌⠁⠓⠒⢺⠒⠒⡗⠒⡇
 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⡇⠀⠈⠫⠽⠀⢸⠂⠀⠇⠩⠓⡄
 ⠀⠀⠀⠀⠀⢀⡠⠂⠁⠈⠐⠂⠤⠄⠀⠀⠀⠤⠤⠄⠒⠉⠐⢄⡀
 ⠀⠀⠀⠀⡔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢘⣄
 ⠀⠀⢀⠤⠯⠭⣒⠂⠤⠄⢀⣀⣀⣀⣀⠀⢀⣀⣀⡀⠀⠤⠐⠊⠁⢸⢢⠀
 ⠀⢰⣁⠤⢤⡀⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡀⠀⡄⠈⡧⡀
 ⡠⠋⠀⠀⢀⠇⠀⢸⠀⢰⠋⠀⠒⠒⠒⠒⠒⠒⠂⠉⠉⠀⠀⢸⠀⡇⢰⡿⠛⠆
 ]],
}

return M
