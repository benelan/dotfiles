local cmp_status_ok, cmp = pcall(require, "cmp")
local snip_status_ok, ls = pcall(require, "luasnip")
if not cmp_status_ok or not snip_status_ok then
  return
end
local icons_status_okay, devicons = pcall(require, "nvim-web-devicons")

local kinds = {
  Array = "   ",
  Boolean = " ◩  ",
  Class = " 🝆  ",
  Color = "   ",
  Constant = " 󰭷  ",
  Constructor = "   ",
  Enum = "   ",
  EnumMember = "   ",
  Event = "   ",
  Field = "   ",
  File = "   ",
  Folder = "   ",
  Function = "   ", -- 󰡱
  Interface = "   ", -- 
  Key = " 󰌋  ",
  Keyword = " 󰌋  ",
  Method = "   ",
  Module = " 󰶮  ",
  Namespace = "   ",
  Null = " ∅  ",
  Number = "   ",
  Object = "   ",
  Operator = "   ",
  Package = "   ",
  Property = "   ",
  Reference = "   ",
  Snippet = "   ",
  String = "   ",
  Struct = "   ",
  Text = "   ",
  TypeParameter = "   ",
  Unit = "   ",
  Value = "   ",
  Variable = "   ",
}

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api
        .nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match "%s"
      == nil
end

local vscode_snips = require "luasnip/loaders/from_vscode"
vscode_snips.lazy_load() -- load plugin snippets
vscode_snips.lazy_load { -- load personal snippets
  paths = { "~/.config/Code/User" },
}

cmp.setup {
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-e>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
    ["<C-y>"] = cmp.mapping(
      cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true },
      {
        "i",
        "c",
      }
    ),
    ["<C-x>"] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      { "i", "c" }
    ),
    ["<CR>"] = cmp.mapping.confirm { select = false },
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s", "c" }),
    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s", "c" }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif ls.expandable() then
        ls.expand()
      elseif ls.expand_or_jumpable() then
        ls.expand_or_jump()
        -- elseif has_words_before() then
        --   cmp.complete()
      else
        fallback()
      end
    end, { "i", "s", "c" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif ls.jumpable(-1) then
        ls.jump(-1)
      else
        fallback()
      end
    end, { "i", "s", "c" }),
  },
  formatting = {
    fields = { "abbr", "menu", "kind" },
    format = function(entry, vim_item)
      if
        vim.tbl_contains({ "path" }, entry.source.name) and icons_status_okay
      then
        local icon, hl_group =
          devicons.get_icon(entry:get_completion_item().label)
        if icon then
          vim_item.kind = " " .. icon .. "  " .. vim_item.kind .. "  "
          vim_item.kind_hl_group = hl_group
        else
          vim_item.kind = kinds[vim_item.kind] .. vim_item.kind .. "  "
        end
      else
        vim_item.kind = kinds[vim_item.kind] .. vim_item.kind .. "  "
      end
      vim_item.menu = ({
        buffer = " [BUF] ",
        nvim_lsp = " [LSP] ",
        nvim_lsp_signature_help = " [LSP] ",
        nvim_lua = " [API] ",
        path = "[PATH] ",
        luasnip = "[SNIP] ",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
    { name = "nvim_lsp_signature_help" },
  },
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  -- window = { completion = { winhighlight = "Normal:Pmenu" } },
  experimental = { ghost_text = true },
}

-- Use buffer source for `/` and `?`
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "buffer" } },
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})

local opts = { noremap = true, silent = true }
vim.keymap.set({ "i", "s" }, "<C-l>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, opts)

vim.keymap.set({ "i", "s" }, "<C-h>", function()
  if ls.jumpable(-1) then
    ls.jump(1)
  end
end, opts)

vim.keymap.set({ "i" }, "<C-c>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, opts)
