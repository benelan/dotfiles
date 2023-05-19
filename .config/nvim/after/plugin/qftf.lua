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

      local lnum = e.lnum > 99999 and -1 or e.lnum
      local end_lnum = e.end_lnum > 99999 and -1 or e.end_lnum
      local lnum_diff = end_lnum - lnum
      local lnums = lnum_diff == 0 and lnum
        or lnum .. "+" .. (lnum_diff > 99 and ">C" or lnum_diff)

      local col = e.col > 999 and -1 or e.col
      local end_col = e.end_col > 999 and -1 or e.end_col
      local cols = col == end_col and col or col .. "-" .. end_col

      local qtype = e.type == "" and ""
        or " " .. e.type:sub(1, 1):upper() .. ":"

      str = validFmt:format(fname, lnums, cols, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end

vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
