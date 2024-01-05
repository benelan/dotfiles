local M = {}

local i = function(icon, backup) return vim.g.use_devicons and icon or backup or "" end

M.icons = {
  diagnostics = {
    [vim.diagnostic.severity.ERROR] = i("󰅜 ", "E"),
    [vim.diagnostic.severity.WARN] = i("󰀦 ", "W"),
    [vim.diagnostic.severity.INFO] = i("󰋼 ", "I"),
    [vim.diagnostic.severity.HINT] = i("󰬏 ", "H"),
  },
  lsp_kind = {
    Array = i " ",
    Boolean = i " ", -- ◩
    Class = i " ", -- 󰠱
    Color = i " ",
    Comment = i " ",
    Component = i " ",
    Conditional = i " ",
    Constant = i "󰭸 ",
    Constructor = i " ",
    Copilot = i " ",
    Enum = i " ",
    EnumMember = i " ",
    Error = i "󰛉 ",
    Event = i " ",
    Field = i "󰓽 ",
    File = i " ",
    Folder = i " ",
    Fragment = i " ",
    Function = i " ", -- 󰡱
    Interface = i " ", -- 
    Key = i "󰷖 ", -- 󰌋
    Keyword = i "󰷖 ",
    Method = i " ",
    Module = i "󰶮 ",
    Namespace = i " ",
    Null = i "󰟢 ",
    Number = i "󰎠 ",
    Object = i "󰅩 ",
    Operator = i " ",
    Package = i " ", -- " ",
    Property = i "󰓽 ",
    Reference = i " ",
    Snippet = i " ",
    Spell = i "󰓆 ",
    String = i "󱀍 ",
    Struct = i " ",
    Text = i "󰦨 ", -- 󰈍
    TypeParameter = i " ",
    Unit = i " ",
    Value = i " ",
    Variable = i " ",
  },
  git = {
    added = i("󰐖 ", "+"),
    changed = i("󰏬 ", "*"),
    removed = i("󰍵 ", "-"),
    branch = i " ",
  },
  border = "rounded", -- i({ "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }, "rounded"),
  ui = { -- utf8 icons so no fallbacks required
    prompt = "❱ ",
    select = "➤  ",
    checkmark = "🗸 ",
    box = "☐ ",
    box_checked = "☑ ",
    circle = "● ",
    collapsed = "🞂",
    expanded = "🞃",
    eol = "⤶",
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
    lightening_bubble = "🗱 ",
  },
  lazy = {
    plugin = "",
    cmd = "",
    config = "",
    event = "",
    ft = "",
    import = "",
    init = "",
    keys = "",
    lazy = "",
    runtime = "",
    source = "",
    start = "",
    task = "",
  },
}

M.filetypes = {
  excluded = {
    "DiffviewFileHistory",
    "DiffviewFiles",
    "NeogitCommitView",
    "NeogitLogView",
    "NeogitPopup",
    "NeogitReflogView",
    "NeogitStatus",
    "Outline",
    "TelescopePreview",
    "TelescopePrompt",
    "TelescopeResults",
    "Trouble",
    "chatgpt-input",
    "checkhealth",
    "cmp_menu",
    "dap-repl",
    "dap-terminal",
    "dapui_console",
    "dapui_hover",
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
    "",
    "chatgpt-input",
    "gitcommit",
    "mail",
    "markdown",
    "octo",
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
  -- "astro",
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
  -- "tailwindcss",
  "taplo",
  -- "tsserver",
  "vimls",
  "volar",
  "yamlls",
  "zk",
}

M.mason_packages = {
  "actionlint", -- github action linter
  "codespell", -- commonly misspelled English words linter
  -- "cspell", -- code spell checker
  -- "delve", -- golang debug adapter
  -- "eslint", -- web dev linter
  "fixjson", -- json formatter
  "hadolint", -- dockerfile linter
  "markdownlint", -- markdown linter and formatter
  "prettier", -- everything formatter
  "shellcheck", -- shell linter
  "shfmt", -- shell formatter
  "stylelint", -- css/scss linter
  "stylua", -- lua formatter
  -- "write-good", -- English grammar linter
}

M.treesitter_parsers = {
  "astro",
  "bash",
  "css",
  "diff",
  "dockerfile",
  "git_rebase",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "graphql",
  "html",
  "http",
  "ini",
  "javascript",
  "jq",
  "jsdoc",
  "json",
  "json5",
  "jsonc",
  "latex",
  "lua",
  "luadoc",
  "luap",
  "make",
  "markdown",
  "markdown_inline",
  "perl",
  "python",
  "query",
  "regex",
  "rst",
  "rust",
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
  ignore = {
    ".git/*",
    "node_modules/*",
    "dist/*",
    "build/*",
    "*.7z",
    "*.avi",
    "*.db",
    "*.docx",
    "*.filepart",
    "*.flac",
    "*.gif",
    "*.gifv",
    "*.gpg",
    "*.gz",
    "*.ico",
    "*.iso",
    "*.jpeg",
    "*.jpg",
    "*.m4a",
    "*.mkv",
    "*.mp3",
    "*.mp4",
    "*.min.*",
    "*.odt",
    "*.ogg",
    "*.pbm",
    "*.pdf",
    "*.png",
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
  },
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
        |   .-------'._
        |  / /  '.' '. \          .---------------.
        |  \ \ @   @ / /         |  Hey sexy mama, |
        |   '---------'          |  wanna kill all |
        |    _______|            |     humans?     |
        |  .'-+-+-+|             ,----------------'
        |  '.-+-+-+|          --'
        |    """""" |
        '-.__   __.-'
             """
  ]],

  bender_dots = [[
               ⠘⡀⠀  Hey⠀sexy mama,    ⠀⡜
               ⠀⠑⡀⠀  wanna kill all⠀⠀⠀⡔
               ⠀⠀⠈⠢⢄⠀⠀⠀humans?⠀ ⠀⠀⠀⣀⠴⠊
               ⠀⠀⠀⠀⠀⢸⠀⠀⠀⢀⣀⣀⣀⣀⣀⡀⠤⠄⠒⠈
               ⠀⠀⠀⠀⠀⠘⣀⠄⠊⠁
   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⣵
   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⡀
   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠀⡇
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
