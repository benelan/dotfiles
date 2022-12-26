local status_ok, inlay_hints = pcall(require, "inlay-hints")
if not status_ok then return end

inlay_hints.setup({
  -- only_current_line = true,
  hints = {
    parameter = {
      show = true,
      highlight = "whitespace",
    },
    type = {
      show = true,
      highlight = "Whitespace",
    },
  },
  eol = {
    right_align = false
  },
  parameter = {
    separator = ", ",
    format = function(hints)
      return string.format(" <- (%s)", hints)
    end,
  },

  type = {
    separator = ", ",
    format = function(hints)
      return string.format(" => %s", hints)
    end,
  },
})

local augroup_inlay_hints = vim.api.nvim_create_augroup("my-lsp-inlay-hints", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  vim.api.nvim_clear_autocmds { group = augroup_inlay_hints },
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    require("inlay-hints").on_attach(client, args.buf)
  end,
})
