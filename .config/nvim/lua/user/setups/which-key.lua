local status_ok, which_key = pcall(require, "which-key")
if not status_ok then return end

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
    t = {
      name = "Toggle options"
    },
    h = { "<cmd>DiffviewFileHistory %<cr>", "Buffer File History" },
    d = { "<cmd>DiffviewOpen<cr>", "Open Diffview" },
    q = { "<cmd>DiffviewClose<cr>", "Close Diffview" },
    V = { "<cmd>DiffviewRefresh<cr>", "Refresh Diffview" },
    H = { "<cmd>DiffviewFileHistory<cr>", "All Files History" },
    l = { "<cmd>lua require'gitsigns'.blame_line{full=true}<cr>", "Blame Line" },
    S = { "<cmd>Gitsigns stage_buffer<cr>", "Stage Buffer" },
    R = { "<cmd>Gitsigns reset_buffer<cr>", "Reset Buffer" },
    j = { "<cmd>Gitsigns next_hunk<cr>", "Next Hunk" },
    k = { "<cmd>Gitsigns prev_hunk<cr>", "Prev Hunk" },
    p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk" },
    r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
    s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
    u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Unstage Hunk" },
    o = { "<cmd>Telescope git_status<cr>", "Open Status" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout Branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout Commit" },
    C = {
      "<cmd>Telescope git_bcommits<cr>",
      "Checkout Buffer Commit",
    },
    m = {
      name = "Mergetool",
      U = { "<cmd>diffupdate<cr>", "Update Merge Diff" },
      r = { "<cmd>diffget RE<cr>", "Choose Hunk From Remote" },
      R = { "<cmd>%diffget RE<cr>", "Choose All From Remote" },
      b = { "<cmd>diffget BA<cr>", "Choose Hunk From Base" },
      B = { "<cmd>%diffget BA<cr>", "Choose All From Base" },
      l = { "<cmd>diffget LO<cr>", "Choose Hunk From Local" },
      L = { "<cmd>diffget LO<cr>", "Choose All From Local" }
    },
  },

  l = {
    name = "LSP",
    a = { vim.lsp.buf.code_action, "Code Action" },
    h = { vim.lsp.buf.signature_help, "Signature Help" },
    j = { vim.diagnostic.goto_next, "Next Diagnostic" },
    k = { vim.diagnostic.goto_prev, "Prev Diagnostic" },
    l = { vim.lsp.codelens.run, "CodeLens Action" },
    f = { vim.lsp.buf.format, "Format" },
    q = { vim.diagnostic.setloclist, "Quickfix" },
    r = { vim.lsp.buf.rename, "Rename" },
  },
}

local mappings = {
  [";"] = { "<cmd>Alpha<CR>", "Dashboard" },
  ["w"] = { "<cmd>w!<CR>", "Save" },
  ["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment toggle" },

  b = {
    name = "Buffers",
    j = { "<cmd>BufferLinePick<cr>", "Jump" },
    f = { "<cmd>Telescope buffers<cr>", "Find" },
    b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
    n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
    W = { "<cmd>Bwipeout<cr>", "Wipeout" },
    e = {
      "<cmd>BufferLinePickClose<cr>",
      "Pick which buffer to close",
    },
    h = {
      "<cmd>BufferLineCloseLeft<cr>",
      "Close all to the left"
    },
    l = {
      "<cmd>BufferLineCloseRight<cr>",
      "Close all to the right",
    },
    D = {
      "<cmd>BufferLineSortByDirectory<cr>",
      "Sort by directory",
    },
    L = {
      "<cmd>BufferLineSortByExtension<cr>",
      "Sort by language",
    },
  },

  D = {
    name = "Debug",
    t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
    b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
    c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
    C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
    d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
    g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
    i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
    o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
    u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
    p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
    r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
    s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
    q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
    U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
  },

  d = {
    name = "Directory"
  },

  s = {
    name = "Settings"
  },

  f = {
    name = "Find",
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    f = { "<cmd>Telescope find_files hidden=true<cr>", "Find File" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    p = { "<cmd>Telescope project", "Projects" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    t = { "<cmd>Telescope live_grep<cr>", "Text" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    C = { "<cmd>Telescope commands<cr>", "Commands" },
  },

  t = {
    name = "Tabs"
  },

  g = {
    name = "Git",
    t = {
      name = "Toggle options"
    },
    d = { "<cmd>DiffviewOpen<cr>", "Open Diffview" },
    q = { "<cmd>DiffviewClose<cr>", "Close Diffview" },
    V = { "<cmd>DiffviewRefresh<cr>", "Refresh Diffview" },
    h = { "<cmd>DiffviewFileHistory %<cr>", "Buffer File History" },
    H = { "<cmd>DiffviewFileHistory<cr>", "All Files History" },
    l = { "<cmd>lua require'gitsigns'.blame_line{full=true}<cr>", "Blame Line" },
    S = { "<cmd>Gitsigns stage_buffer<cr>", "Stage Buffer" },
    R = { "<cmd>Gitsigns reset_buffer<cr>", "Reset Buffer" },
    j = { "<cmd>Gitsigns next_hunk<cr>", "Next Hunk" },
    k = { "<cmd>Gitsigns prev_hunk<cr>", "Prev Hunk" },
    p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk" },
    r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
    s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
    u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Unstage Hunk" },
    o = { "<cmd>Telescope git_status<cr>", "Open Status" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout Branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout Commit" },
    C = {
      "<cmd>Telescope git_bcommits<cr>",
      "Checkout Buffer Commit"
    },
    m = {
      name = "Mergetool",
      U = { "<cmd>diffupdate<cr>", "Update Merge Diff" },
      r = { "<cmd>diffget RE<cr>", "Choose Hunk From Remote" },
      R = { "<cmd>%diffget RE<cr>", "Choose All From Remote" },
      b = { "<cmd>diffget BA<cr>", "Choose Hunk From Base" },
      B = { "<cmd>%diffget BA<cr>", "Choose All From Base" },
      l = { "<cmd>diffget LO<cr>", "Choose Hunk From Local" },
      L = { "<cmd>diffget LO<cr>", "Choose All From Local" }
    },
  },

  o = {
    name = "Octo (GitHub)",
    i = {
      name = "Issues",
      D = {
        name = "Remove"
      },
      a = {
        name = "Add"
      }
    },
    p = {
      name = "Pull requests",
      D = {
        name = "Remove"
      },
      a = {
        name = "Add"
      },
      r = {
        name = "Reviews"
      }
    },
    m = {
      name = "My stuff",
      i = {
        name = "Issues"
      },
      p = {
        name = "Pull requests"
      }
    },
    r = {
      name = "Reactions"
    }
  },

  l = {
    name = "LSP",
    a = { vim.lsp.buf.code_action, "Code Action" },
    h = { vim.lsp.buf.signature_help, "Signature Help" },
    j = { vim.diagnostic.goto_next, "Next Diagnostic" },
    k = { vim.diagnostic.goto_prev, "Prev Diagnostic" },
    l = { vim.lsp.codelens.run, "CodeLens Action" },
    q = { vim.diagnostic.setloclist, "Quickfix" },
    r = { vim.lsp.buf.rename, "Rename" },
    f = { "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", "Format" },
    e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
    w = { "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    d = {
      "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>",
      "Buffer Diagnostics"
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
    c = { "<cmd>PackerCompile<cr>", "Compile" },
    i = { "<cmd>PackerInstall<cr>", "Install" },
    s = { "<cmd>PackerSync<cr>", "Sync" },
    S = { "<cmd>PackerStatus<cr>", "Status" },
    u = { "<cmd>PackerUpdate<cr>", "Update" },
  },

  T = {
    name = "Treesitter",
    i = { "<cmd>TSConfigInfo<cr>", "Info" },
    h = { "<cmd>TSBufToggle highlight<cr>", "Toggle highlight" },
    u = { "<cmd>TSUpdate<cr>", "Update" },
  }
}

which_key.setup()
which_key.register(mappings, opts)
which_key.register(xmappings, xopts)