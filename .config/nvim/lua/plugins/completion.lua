return {
  {
    "uga-rosa/cmp-dictionary", -- completes words from a dictionary file
    -- only use source if a dict file exists in the usual place
    cond = vim.fn.filereadable("/usr/share/dict/words") == 1,
    config = function()
      local has_dict, dict = pcall(require, "cmp_dictionary")
      if not has_dict then
        return
      end

      dict.setup({
        paths = { "/usr/share/dict/words" },
        document = { enable = true, command = { "dict", "${label}" } },
        external = { enable = true, command = { "look", "${prefix}", "${path}" } },
        first_case_insensitive = true,
      })
    end,
  },
  {
    "petertriho/cmp-git", -- completes git commits and github issues/pull requests
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "gitcommit", "markdown", "octo" },
    config = function()
      require("cmp_git").setup({
        filetypes = { "gitcommit", "markdown", "octo" },
        github = { issues = { state = "all" }, pull_requests = { state = "all" } },
      })
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp-signature-help", -- completes function signatures via LSP
    event = "LspAttach",
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "andersevenrud/cmp-tmux", -- completes text visible in other tmux panes
        cond = vim.env.TMUX ~= nil,
      },
      {
        "lukas-reineke/cmp-rg", -- completes text from other files in the project
        cond = vim.fn.executable("rg") == 1,
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "git" })
      table.insert(opts.sources, { name = "dictionary" })
      table.insert(opts.sources, { name = "rg" })
      table.insert(opts.sources, { name = "tmux" })
      table.insert(opts.sources, { name = "nvim_lsp_signature_help" })
    end,
  },
}
