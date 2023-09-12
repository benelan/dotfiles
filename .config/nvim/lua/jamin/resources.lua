local M = {}

local i = function(icon, backup)
  return vim.g.use_devicons and icon or backup or ""
end

M.icons = {
  diagnostics = {
    {
      name = "Error",
      text = i("󰅜 ", "E"),
      severity = vim.diagnostic.severity.ERROR,
    },
    {
      name = "Warn",
      text = i("󰀦 ", "W"),
      severity = vim.diagnostic.severity.WARN,
    },
    {
      name = "Hint",
      text = i("󰬏 ", "H"),
      severity = vim.diagnostic.severity.HINT,
    },
    {
      name = "Info",
      text = i("󰋼 ", "I"),
      severity = vim.diagnostic.severity.INFO,
    },
  },
  lsp_kind = {
    Array = i " ",
    Boolean = i " ", -- ◩
    Class = i " ", -- 󰠱 🝆
    Color = i " ",
    Comment = i " ",
    Component = i " ",
    Conditional = i " ",
    Constant = i "󰭸 ",
    Constructor = i " ",
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
    Text = i "󰦨 ", -- 󰈍  󰦪
    TypeParameter = i " ",
    Unit = i " ",
    Value = i " ",
    Variable = i " ",
  },
  debug = {
    breakpoint = i(" ", "B"),
    breakpoint_condition = i("󰼈 ", "?"),
    breakpoint_rejected = i("󰜺 ", "R"),
    logpoint = i("󰤌 ", "L"),
    stopped = i("󰗽 ", "X"),
    -- dapui
    pause = i("󰏦 ", "⏸︎ "),
    play = i("󰐍 ", "⯈ "),
    terminate = i("󰙧 ", "◼ "),
    disconnect = i("󰐥 ", "⏻︎ "), -- ⏏
    skip = i("󰙢 ", "⏭︎ "),
    run_last = i("󰙤 ",  "⏮︎ "),
    step_back = i("󰌍 ", "🡸 "),
    step_over = i("󰆷 ", "🡺 "),
    step_into = i("󰆹 ", "🡻 "),
    step_out = i("󰆸 ", "🡹 "),
  },
  test = {
    passed = i("󰗡 ",  "✔ "),
    running = i("󰁚 ", "⯈ "),
    skipped = i("󰍷 ", "⏩︎"),
    failed = i("󰅚 ",  "✘ "),
    unknown = i("󰘥 ", "？")
  },
  git = {
    add = i("󰐖 ", "+"),
    edit = i("󰏬 ", "*"),
    delete = i("󰍵 ", "-"),
    branch = i " ",
  },
  ui = {
    light = i " ",
    folder_open = i " ",
    folder_closed = i " ",
    checkmark = "🗸 ",
    prompt = "❱ ", -- ❯ ❱ ⧽
    select = "  ", -- ➜  ⮞    🡺  🡲
    eol = "⮠", -- 󰌑 ⤶  ↵  ⮠
    nbsp = "␣",
    expanded = "🞃 ",
    collapsed = "🞂 ",
    extends = "»",
    precedes = "«",
    fill_dot = "·",
    fill_slash = "╱",
    separator = "┊",
  },
  lazy = {
    plugin = i(" ", "⧠ "),
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
    "",
    "DiffviewFiles",
    "Outline",
    "TelescopePreview",
    "TelescopePrompt",
    "TelescopeResults",
    "ccc-ui",
    "checkhealth",
    "cmp_menu",
    "dap-repl",
    "dap-terminal",
    "dapui_console",
    "dapui_hover",
    "flash_prompt",
    "fugitive",
    "harpoon",
    "help",
    "lazy",
    "lspinfo",
    "man",
    "mason",
    "netrw",
    "octo",
    "qf",
    "tsplayground",
    "undotree",
  },
  writing = {
    "gitcommit",
    "markdown",
    "octo",
    "text",
    "vimwiki",
  },
  webdev = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "html",
    "vue",
    "svelte",
  },
}

M.lsp_servers = {
  "bashls",
  "cssls",
  -- "docker_compose_language_service",
  "dockerls",
  "eslint",
  "gopls",
  -- "graphql",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  -- "pyright",
  -- "rust_analyzer",
  -- "sqlls",
  "svelte",
  "taplo",
  "tailwindcss",
  "tsserver",
  "vimls",
  "volar",
  "yamlls",
  "zk",
}

return M
