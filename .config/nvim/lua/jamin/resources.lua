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
    Class = i " ", -- 󰠱
    Color = i " ",
    Comment = i " ",
    Component = i " ",
    Conditional = i " ",
    Constant = i "󰭸 ",
    Constructor = i " ",
    Copilot = " ",
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
    add = i("󰐖 ", "+"),
    edit = i("󰏬 ", "*"),
    delete = i("󰍵 ", "-"),
    branch = i " ",
  },
  ui = {
    checkmark = "🗸 ",
    prompt = "❱ ",
    select = "  ",
    expanded = "🞃 ",
    collapsed = "🞂 ",
    replace = "� ",
    eol = "⮠",
    nbsp = "␣",
    extends = "»",
    precedes = "«",
    fill_dot = "·",
    fill_slash = "╱",
    separator = "┊",
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
    "",
    "TelescopePreview",
    "TelescopePrompt",
    "TelescopeResults",
    "checkhealth",
    "cmp_menu",
    "dap-repl",
    "dap-terminal",
    "dapui_console",
    "dapui_hover",
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
    "mail",
    "markdown",
    "octo",
    "rst",
    "text",
    "vimwiki",
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

M.mason_packages = {
  "actionlint", -- github action linter
  "codespell", -- commonly misspelled English words linter
  "cspell", -- code spell checker
  "delve", -- golang debug adapter
  "markdown-toc", -- markdown table of contents generator
  "markdownlint", -- markdown linter and formatter
  "shellcheck", -- shell linter
  "shfmt", -- shell formatter
  "stylua", -- lua formatter
  "write-good", -- English grammar linter
}

return M
