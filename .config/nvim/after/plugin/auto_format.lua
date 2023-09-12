-- Format on Save
-- from https://github.com/nvim-lua/kickstart.nvim

local res = require "jamin.resources"
local format_is_enabled = false

-- Command for toggling autoformatting
vim.api.nvim_create_user_command("AutoFormatToggle", function()
  format_is_enabled = not format_is_enabled
  print("Setting autoformatting to: " .. tostring(format_is_enabled))
end, {})

local fix_typescript_issues = function(bufnr)
  local has_ts, ts = pcall(require, "typescript")
  local has_ts_tools, _ = pcall(require, "typescript-tools")
  local ts_client
  if has_ts then
    ts_client = vim.lsp.get_clients({ bufnr = bufnr, name = "tsserver" })[1]
  elseif has_ts_tools then
    ts_client = vim.lsp.get_clients({ bufnr = bufnr, name = "typescript-tools" })[1]
  end
  if not ts_client then
    return
  end

  local diag =
    vim.diagnostic.get(bufnr, { namespace = vim.lsp.diagnostic.get_namespace(ts_client.id, false) })

  if #diag > 0 then
    if has_ts then
      ts.actions.fixAll { sync = true }
      ts.actions.addMissingImports { sync = true }
      ts.actions.removeUnused { sync = true }
    elseif has_ts_tools then
      vim.cmd "TSToolsFixAll sync"
      vim.cmd "TSToolsAddMissingImports sync"
      vim.cmd "TSToolsRemoveUnused sync"
    end
  end
  if has_ts then
    ts.actions.organizeImports { sync = true }
  elseif has_ts_tools then
    vim.cmd "TSToolsOrganizeImports sync"
  end
end

local fix_eslint_issues = function(bufnr)
  local eslint_client = vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" })[1]
  if not eslint_client then
    return
  end

  local diag = vim.diagnostic.get(
    bufnr,
    { namespace = vim.lsp.diagnostic.get_namespace(eslint_client.id, false) }
  )

  if #diag > 0 then
    vim.cmd "EslintFixAll"
  end
end

-- Create an augroup per client to prevent interference
-- when multiple clients are attached to the same buffer
local _augroups = {}
local get_client_augroup = function(client)
  if not _augroups[client.id] then
    local group_name = "jamin_auto_format_" .. client.name
    local id = vim.api.nvim_create_augroup(group_name, { clear = true })
    _augroups[client.id] = id
  end
  return _augroups[client.id]
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("jamin_lsp_attach_auto_format", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil or not client.supports_method "textDocument/formatting" then
      return
    end

    vim.keymap.set("n", "<leader>sF", "<CMD>AutoFormatToggle<CR>", {
      buffer = args.buf,
      silent = true,
      noremap = true,
      desc = "Toggle format on save",
    })

    -- Autocmd needs to run *before* the buffer saves
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = get_client_augroup(client),
      buffer = args.buf,
      callback = function(event)
        if not format_is_enabled then
          return
        end
        -- skip typescript/eslint fixes for non web dev files
        local webdev_formatting =
          vim.tbl_contains(res.filetypes.webdev, vim.api.nvim_buf_get_option(event.buf, "filetype"))

        if webdev_formatting then
          fix_typescript_issues(event.buf)
        end

        -- format the code
        vim.lsp.buf.format {
          async = false,
          filter = function(c)
            return c.id == client.id
          end,
        }

        if webdev_formatting then
          fix_eslint_issues(event.buf)
        end
      end,
    })
  end,
})
