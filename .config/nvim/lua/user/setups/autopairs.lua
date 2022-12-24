-- Setup nvim-cmp.
local status_ok, npairs = pcall(require, "nvim-autopairs")
if not status_ok then return end

npairs.setup({
  ignore_next_char = "[%w%.]",
  check_ts = true, -- treesitter integration
  disable_filetype = { "TelescopePrompt" },
  disable_in_macro = true,
  ts_config = {
    lua = { "string", "source" },
    javascript = { "string", "template_string" },
    java = false,
  },

  fast_wrap = {
    map = "<M-e>",
    chars = { "{", "[", "(", '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
    offset = 0, -- Offset from pattern match
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "PmenuSel",
    highlight_grey = "LineNr",
  },
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp_status_ok, cmp = pcall(require, "cmp")
if cmp_status_ok then
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({}))
end


-- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules
local rule_status_ok, Rule = pcall(require, "nvim-autopairs.rule")
if not rule_status_ok then return end

-- Add space between parentheses
local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
npairs.add_rules {
  Rule(' ', ' ')
      :with_pair(function(opts)
        local pair = opts.line:sub(opts.col - 1, opts.col)
        return vim.tbl_contains({
          brackets[1][1] .. brackets[1][2],
          brackets[2][1] .. brackets[2][2],
          brackets[3][1] .. brackets[3][2],
        }, pair)
      end)
}
for _, bracket in pairs(brackets) do
  npairs.add_rules {
    Rule(bracket[1] .. ' ', ' ' .. bracket[2])
        :with_pair(function() return false end)
        :with_move(function(opts)
          return opts.prev_char:match('.%' .. bracket[2]) ~= nil
        end)
        :use_key(bracket[2])
  }
end

-- Move past commas and semicolons
for _, punct in pairs { ",", ";" } do
  npairs.add_rules {
    Rule("", punct)
        :with_move(function(opts) return opts.char == punct end)
        :with_pair(function() return false end)
        :with_del(function() return false end)
        :with_cr(function() return false end)
        :use_key(punct)
  }
end

-- JavaScript arrow functions
npairs.add_rules {
  Rule('%(.*%)%s*%=>$', ' {  }', { 'typescript', 'typescriptreact', 'javascript' })
      :use_regex(true)
      :set_end_pair_length(2)
}


-- https://github.com/rstacruz/vim-closer/blob/master/autoload/closer.vim
-- Expand multiple pairs on Enter key
local get_closing_for_line = function(line)
  local i = -1
  local clo = ''

  while true do
    i, _ = string.find(line, "[%(%)%{%}%[%]]", i + 1)
    if i == nil then break end
    local ch = string.sub(line, i, i)
    local st = string.sub(clo, 1, 1)

    if ch == '{' then
      clo = '}' .. clo
    elseif ch == '}' then
      if st ~= '}' then return '' end
      clo = string.sub(clo, 2)
    elseif ch == '(' then
      clo = ')' .. clo
    elseif ch == ')' then
      if st ~= ')' then return '' end
      clo = string.sub(clo, 2)
    elseif ch == '[' then
      clo = ']' .. clo
    elseif ch == ']' then
      if st ~= ']' then return '' end
      clo = string.sub(clo, 2)
    end
  end

  return clo
end

-- npairs.remove_rule('(')
-- npairs.remove_rule('{')
-- npairs.remove_rule('[')
--
-- npairs.add_rule(
--   Rule("[%(%{%[]", "")
--   :use_regex(true)
--   :replace_endpair(function(opts)
--     return get_closing_for_line(opts.line)
--   end)
--   :end_wise()
-- )
