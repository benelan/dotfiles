local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = false,
}
local xopts = {
  mode = "x", -- VISUAL mode
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = false,
}

-- NOTE: Prefer using <cmd> over : to avoid changing modes
-- see https://neovim.io/doc/user/map.html#%3CCmd%3E
local xmappings = {
  ["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment toggle" },
  g = {
    name = "Git",
    C = { "<cmd>Telescope git_bcommits<cr>", "Checkout Buffer Commit" },
    H = { "<cmd>DiffviewFileHistory<cr>", "All Files History" },
    R = { "<cmd>Gitsigns reset_buffer<cr>", "Reset Buffer" },
    S = { "<cmd>Gitsigns stage_buffer<cr>", "Stage Buffer" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout Branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout Commit" },
    d = { "<cmd>DiffviewOpen<cr>", "Open Diffview" },
    h = { ":'<,'>DiffviewFileHistory<cr>", "Selection History" },
    j = { "<cmd>Gitsigns next_hunk<cr>", "Next Hunk" },
    k = { "<cmd>Gitsigns prev_hunk<cr>", "Prev Hunk" },
    l = { "<cmd>lua require'gitsigns'.blame_line{full=true}<cr>", "Blame Line" },
    m = { name = "Mergetool" },
    o = { ":'<,'>GBrowse<cr>", "Open In Browser" },
    p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk" },
    q = { "<cmd>DiffviewClose<cr>", "Close Diffview" },
    r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
    s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
    u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Unstage Hunk" },
    y = { ":'<,'>GBrowse!<cr>", "Yank URL" },
  },

  l = {
    name = "LSP",
    f = { vim.lsp.buf.format, "Format" },
    j = { vim.diagnostic.goto_next, "Next Diagnostic" },
    k = { vim.diagnostic.goto_prev, "Prev Diagnostic" },
    q = { vim.diagnostic.setloclist, "Quickfix" },
  },
}

local mappings = {
  ["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment toggle" },
  [";"] = { "<cmd>Alpha<CR>", "Dashboard" },
  ["gp"] = { name = "Preview" },
  D = {
    name = "Debug",
    C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
    U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
    b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
    c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
    d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
    g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
    i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
    o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
    p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
    q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
    r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
    s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
    t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
    u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
  },

  S = { name = "Sessions" },
  b = { name = "Buffers" },
  d = { name = "Directory" },
  s = { name = "Settings" },
  t = { name = "Tabs" },

  f = {
    name = "Find",
    C = { "<cmd>Telescope commands<cr>", "Commands" },
    H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    b = { "<cmd>Telescope file_browser<cr>", "File Browser" },
    c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    f = { "<cmd>Telescope find_files hidden=true<cr>", "Find File" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    p = { "<cmd>Telescope project", "Projects" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    t = { "<cmd>Telescope live_grep<cr>", "Text" },
  },
  g = {
    name = "Git",
    C = { "<cmd>Telescope git_bcommits<cr>", "Checkout Buffer Commit" },
    H = { "<cmd>DiffviewFileHistory<cr>", "All Files History" },
    R = { "<cmd>Gitsigns reset_buffer<cr>", "Reset Buffer" },
    S = { "<cmd>Gitsigns stage_buffer<cr>", "Stage Buffer" },
    V = { "<cmd>DiffviewRefresh<cr>", "Refresh Diffview" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout Branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout Commit" },
    d = { "<cmd>DiffviewOpen<cr>", "Open Diffview" },
    h = { "<cmd>DiffviewFileHistory %<cr>", "Buffer File History" },
    j = { "<cmd>Gitsigns next_hunk<cr>", "Next Hunk" },
    k = { "<cmd>Gitsigns prev_hunk<cr>", "Prev Hunk" },
    l = { "<cmd>lua require'gitsigns'.blame_line{full=true}<cr>", "Blame Line" },
    m = { name = "Mergetool" },
    o = { "<cmd>GBrowse<cr>", "Open In Browser" },
    p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk" },
    q = { "<cmd>DiffviewClose<cr>", "Close Diffview" },
    r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
    s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
    t = { name = "Toggle options" },
    u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Unstage Hunk" },
    w = { name = "Worktree" },
    y = { "<cmd>GBrowse!<cr>", "Yank URL" },
  },

  o = {
    name = "Octo (GitHub)",
    i = { name = "Issues", D = { name = "Remove" }, a = { name = "Add" } },
    p = {
      name = "Pull requests",
      D = { name = "Remove" },
      a = { name = "Add" },
      r = { name = "Reviews" },
    },
    m = { name = "My stuff", i = { name = "Issues" }, p = { name = "Pull requests" } },
    r = { name = "Reactions" },
  },
  l = {
    name = "LSP",
    Q = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
    R = { "<cmd>Telescope lsp_references<cr>", "References" },
    T = { vim.lsp.buf.type_definition, "Type Definition" },
    W = { "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics" },
    a = { vim.lsp.buf.code_action, "Code Action" },
    d = { vim.lsp.buf.definition, "Definition" },
    f = { "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", "Format" },
    h = { vim.lsp.buf.signature_help, "Signature Help" },
    j = { vim.diagnostic.goto_next, "Next Diagnostic" },
    k = { vim.diagnostic.goto_prev, "Prev Diagnostic" },
    l = { vim.lsp.codelens.run, "CodeLens Action" },
    q = { vim.diagnostic.setloclist, "Quickfix" },
    r = { vim.lsp.buf.rename, "Rename" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    B = {
      "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>",
      "Buffer Diagnostics",
    },
    S = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      "Workspace Symbols",
    },
    i = { "<cmd>LspInfo<cr>", "Info" },
    I = { "<cmd>Mason<cr>", "Mason Info" },
  },

  P = {
    name = "Packer",
    S = { "<cmd>PackerStatus<cr>", "Status" },
    c = { "<cmd>PackerCompile<cr>", "Compile" },
    i = { "<cmd>PackerInstall<cr>", "Install" },
    s = { "<cmd>PackerSync<cr>", "Sync" },
    u = { "<cmd>PackerUpdate<cr>", "Update" },
  },

  T = {
    name = "Treesitter",
    h = { "<cmd>TSBufToggle highlight<cr>", "Toggle Highlights" },
    i = { "<cmd>TSConfigInfo<cr>", "Info" },
    p = { "<cmd>TSPlaygroundToggle<cr>", "Toggle Playground" },
    u = { "<cmd>TSUpdate<cr>", "Update" },
  },
}

which_key.setup()
which_key.register(mappings, opts)
which_key.register(xmappings, xopts)
