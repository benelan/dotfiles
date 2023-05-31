-- Make Quickfix list format easier to read, originally from:
-- https://github.com/kevinhwang91/nvim-bqf#customize-quickfix-window-easter-egg
function _G.qftf(info)
  local items
  local ret = {}
  local limit = 30
  local validFmt = "%s │%8s : %-7s│%s %s"

  if info.quickfix == 1 then
    items = vim.fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end

  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ""
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = vim.fn.bufname(e.bufnr)
        if fname == "" then
          fname = "[No Name]"
        else
          fname = fname:gsub("^" .. vim.env.HOME, "~")
        end

        -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
        if #fname <= limit then
          fname = ("%-" .. limit .. "s"):format(fname)
        else
          fname = ("… %." .. (limit - 2) .. "s"):format(fname:sub(2 - limit))
        end
      end

      -- ensure long line/col numbers don't break the list's formatting
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local end_lnum = e.end_lnum > 99999 and -1 or e.end_lnum
      local lnums = tostring(lnum)

      -- show how many additional lines the qickfix item spans
      if end_lnum ~= lnum and end_lnum ~= 0 then
        local lnums_diff = end_lnum - lnum
        -- 'H' for hecto-lines
        lnums = lnum .. "+" .. (lnums_diff > 99 and ">H" or lnums_diff)
      end

      local cols
      if (e.col > 999 or e.end_col > 999) or e.col == e.end_col then
        cols = e.col > 999999 and -1 or e.col
      else
        cols = string.format("%s-%s", e.col, e.end_col)
      end

      -- type initial used for syntax highlighting
      local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper() .. ":"

      str = validFmt:format(
        fname,
        lnums,
        cols,
        qtype,
        e.text:gsub("^%s*(.-)%s*$", "%1") -- trim leading/trailing whitespace
      )
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end

vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
