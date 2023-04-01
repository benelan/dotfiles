return {
  "Exafunction/codeium.vim", -- AI completion
  enabled = false,
  event = "InsertEnter",
  init = function()
    -- codeium options
    -- vim.g.codeium_manual = true
    vim.g.codeium_disable_bindings = true
    vim.g.codeium_filetypes = { bash = false }
  end,
  keys = {
    {
      "<M-y>",
      function()
        return vim.fn["codeium#Accept"]()
      end,
      "i",
      desc = "Codeium Accept",
    },
    {
      "<M-c>",
      function()
        return vim.fn["codeium#Complete"]()
      end,
      "i",
      desc = "Codeium Complete",
    },
    {
      "<M-n>",
      function()
        return vim.fn["codeium#CycleCompletions"](1)
      end,
      "i",
      desc = "Codeium Next",
    },
    {
      "<M-p>",
      function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end,
      "i",
      desc = "Codeium Previous",
    },
    {
      "<M-e>",
      function()
        return vim.fn["codeium#Clear"]()
      end,
      "i",
      desc = "Codeium Clear",
    },
  },
}
