local M = {}

M.filetypes = {
  excluded = {
    "",
    "TelescopePreview",
    "TelescopePrompt",
    "TelescopeResults",
    "Trouble",
    "checkhealth",
    "cmp_menu",
    "copilot-chat",
    "copilot-diff",
    "copilot-system-prompt",
    "copilot-user-selection",
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
    "gitsigns-blame",
    "grug-far",
    "grug-far-help",
    "grug-far-history",
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
  "ts_ls",
  -- "typos_lsp",
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
  "comment",
  "css",
  -- "csv",
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
  -- "http",
  -- "ini",
  "javascript",
  "jsdoc",
  "json",
  "json5",
  "jsonc",
  -- "jq",
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
    docs = M.i(" ", "🖹 "),
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
    horizontal_separator = "─",
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
  emoji = {
    folder_open = "📂 ",
    folder_closed = "📁 ",
  },
  lsp_kind = {
    Array = M.i(" "),
    Boolean = M.i(" "), -- 󰨙 ◩
    Class = M.i(" "), --     
    Codeium = M.i("󰘦 "),
    Color = M.i(" "),
    Comment = M.i(" "),
    Control = M.i(" "),
    Component = M.i(" "),
    Conditional = M.i(" "),
    Constant = M.i("󰭸 "),
    Constructor = M.i(" "), --  
    Copilot = M.i(" "), --   
    Enum = M.i(" "),
    EnumMember = M.i(" "),
    Error = M.i("󰛉 "), -- 
    Event = M.i(" "),
    Field = M.i("󰓽 "), --  
    File = M.i(" "),
    Folder = M.i(" "),
    Fragment = M.i(" "),
    Function = M.i(" "), -- 󰡱
    Interface = M.i(" "), --   
    Key = M.i(" "), -- 󰌋   🗝
    Keyword = M.i(" "), -- 
    Macro = M.i(" "),
    TypeAlias = M.i(" "),
    Method = M.i(" "),
    StaticMethod = M.i(" "),
    Module = M.i(" "), -- 󰶮  
    Namespace = M.i("󰦮 "), -- 
    Null = M.i("󰟢 "), -- 
    Number = M.i(" "), --   
    Object = M.i("󰅩 "),
    Operator = M.i(" "),
    Package = M.i(" "), -- 
    Property = M.i("󰓽 "), -- 
    Reference = M.i(" "), -- 
    Snippet = M.i("✀ "), --   
    Spell = M.i("󰓆 "),
    String = M.i(" "), -- 󱀍
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
  debug = {
    breakpoint = M.i("󰆤 ", "B"),
    breakpoint_condition = M.i("󱄶 ", "C"),
    breakpoint_rejected = M.i("󰽅 ", "R"),
    logpoint = M.i("󰆣 ", "L"),
    stopped = M.i("󰿅 ", "S"),
  },
  git = {
    status = "▎",
    history = M.i("󰋚 "),
    branch = M.i("󰘬 "), -- ⛕  ⛙
    added = M.i("󰜄 ", "+"),
    changed = M.i("󱗝 ", "∗"),
    removed = M.i("󰛲 ", "‒"),
  },
  progress = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
  border = M.i({ "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }, "rounded"),
}

M.icons.test = {
  passed = M.i("󰗡 ", M.icons.ui.checkmark),
  running = M.i("󰁚 ", M.icons.ui.play),
  skipped = M.i("󰍷 ", M.icons.ui.skip),
  failed = M.i("󰅚 ", M.icons.ui.x),
  unknown = M.i("󰘥 ", M.icons.ui.question_mark),
  running_animated = M.icons.progress,
}

M.diagnostics = {
  virtual_text = {
    severity = { min = vim.diagnostic.severity.WARN },
    source = "if_many",
  },
  signs = { text = M.icons.diagnostics },
  float = {
    border = M.icons.border,
    header = "",
    prefix = "",
    focusable = true,
    source = true,
  },
  severity_sort = true,
  underline = true,
  update_in_insert = false,
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

-- taken from https://github.com/CopilotC-Nvim/CopilotChat.nvim/blob/canary/lua/CopilotChat/prompts.lua
M.prompts = {
  review = [[
Your task is to review the provided code snippet, focusing specifically on its readability and maintainability.
Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- The presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- The use of excessively long names for variables or functions.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.

Your feedback must be concise, directly addressing each identified issue with:
- The specific line number(s) where the issue is found.
- A clear description of the problem.
- A concrete suggestion for how to improve or correct the issue.

Format your feedback as follows:
line=<line_number>: <issue_description>

If the issue is related to a range of lines, use the following format:
line=<start_line>-<end_line>: <issue_description>

If you find multiple issues on the same line, list each issue separately within the same feedback statement, using a semicolon to separate them.

Example feedback:
line=3: The variable name 'x' is unclear. Comment next to variable declaration is unnecessary.
line=8: Expression is overly complex. Break down the expression into simpler components.
line=10: Using camel case here is unconventional for lua. Use snake case instead.
line=11-15: Excessive nesting makes the code hard to follow. Consider refactoring to reduce nesting levels.

If the code snippet has no readability issues, simply confirm that the code is clear and well-written as is.
]],

  explain = [[
You are a world-class coding tutor. Your code explanations perfectly balance high-level concepts and granular details. Your approach ensures that students not only understand how to write code, but also grasp the underlying principles that guide effective programming.
Follow the user's requirements carefully & to the letter.
Keep your answers short and impersonal.
Use Markdown formatting in your answers.
Make sure to include the programming language name at the start of the Markdown code blocks.
Avoid wrapping the whole response in triple backticks.
The user works in an IDE called Neovim which has a concept for editors with open files, integrated unit test support, an output pane that shows the output of running the code as well as an integrated terminal.
The active document is the source code the user is looking at right now.
You can only give one reply for each conversation turn.

Additional Rules
Think step by step:
1. Examine the provided code selection and any other context like user question, related errors, project details, class definitions, etc.
2. If you are unsure about the code, concepts, or the user's question, ask clarifying questions.
3. If the user provided a specific question or error, answer it based on the selected code and additional provided context. Otherwise focus on explaining the selected code.
4. Provide suggestions if you see opportunities to improve code readability, performance, etc.

Assume prioer knowledge at the senior software engineer level.
Use developer-friendly terms and analogies in your explanations.
Identify 'gotchas' or less obvious parts of the code.
]],
}

return M
