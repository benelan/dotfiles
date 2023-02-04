local status_ok, ufo = pcall(require, "ufo")
if not status_ok then return end

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "zR", ufo.openAllFolds,
  vim.list_extend({ desc = "Open all folds" }, opts))

vim.keymap.set("n", "zM", ufo.closeAllFolds,
  vim.list_extend({ desc = "Close All Folds" }, opts))

vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds,
  vim.list_extend({ desc = "Open Folds Except Kinds" }, opts))

vim.keymap.set("n", "zm", ufo.closeFoldsWith,
  vim.list_extend({ desc = "Close N folds"}, opts)) -- closeAllFolds == closeFoldsWith(0)

vim.keymap.set("n", "zK", ufo.peekFoldedLinesUnderCursor,
  vim.list_extend({ desc = "Peek fold under cursor" }, opts))

local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = ("  %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

ufo.setup({
  -- open_fold_hl_timeout = 150,
  -- close_fold_kinds = {"imports", "comment"},
  preview = {
    win_config = {
      border = { " ", " ", " ", " ", " ", " ", " ", " " },
      winhighlight = "Normal:Folded",
      winblend = 1
    },
    mappings = {
      scrollU = "<C-u>",
      scrollD = "<C-d>"
    }
  },
  fold_virt_text_handler = handler
})

-- buffer scope handler
-- will override global handler if it is existed
local bufnr = vim.api.nvim_get_current_buf()
require("ufo").setFoldVirtTextHandler(bufnr, handler)
