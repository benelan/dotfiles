---Plugins for Language Server Protocal integration
---https://microsoft.github.io/language-server-protocol/

local res = require("jamin.resources")

---@type LazySpec
return {
  -- Installer/manager for language servers, linters, formatters, and debuggers
  {
    "williamboman/mason.nvim",
    lazy = true,
    build = ":MasonUpdate",
    keys = { { "<leader>lm", "<CMD>Mason<CR>", desc = "Mason" } },

    ---@type MasonSettings
    opts = {
      ensure_installed = res.mason_packages,
      ui = { border = res.icons.border, height = 0.8 },
    },

    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() and vim.fn.executable(tool) == 0 then p:install() end
        end
      end)
    end,
  },

  -----------------------------------------------------------------------------
  -- integrates mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    event = "BufReadPost",
    build = ":MasonUpdate",
    dependencies = {
      "williamboman/mason.nvim",
      {
        "neovim/nvim-lspconfig",
        keys = {
          { "<leader>ll", "<CMD>LspInfo<CR>", desc = "LSP info" },
          { "<leader>lL", "<CMD>LspLog<CR>", desc = "LSP logs" },
          { "<leader>l<Tab>", "<CMD>LspRestart<CR>", desc = "LSP restart" },
        },
      },
    },

    ---@type MasonLspconfigSettings
    opts = {
      ensure_installed = res.lsp_servers,
      handlers = {
        -- the zk.nvim and typescript-tools.nvim plugins setup the servers themselves,
        -- so make sure mason-lspconfig doesn't call the default handler
        -- ts_ls = function() end,
        zk = function() end,

        function(server_name)
          local has_cmp, cmp = pcall(require, "blink.cmp")
          local has_user_opts, user_opts = pcall(require, "jamin.lsp.servers." .. server_name)

          ---@type lsp.ClientCapabilities
          local capabilities_overrides = {
            telemetry = false,
            textDocument = {
              codeLens = { dynamicRegistration = false },
              completion = {
                completionItem = {
                  snippetSupport = true,
                  resolveSupport = {
                    properties = { "documentation", "detail", "additionalTextEdits" },
                  },
                },
              },
            },
            workspace = {
              fileOperations = { didRename = true, willRename = true },
            },
          }

          local server_opts = vim.tbl_deep_extend(
            "force",
            has_cmp and { capabilities = cmp.get_lsp_capabilities(capabilities_overrides) } or {},
            has_user_opts and user_opts or {}
          )

          require("lspconfig")[server_name].setup(server_opts)
        end,
      },
    },
  },

  -----------------------------------------------------------------------------
  -- JSON and YAML schema store for autocompletion and validation
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    cond = vim.tbl_contains(res.lsp_servers, "yamlls")
      or vim.tbl_contains(res.lsp_servers, "jsonls"),
  },

  -----------------------------------------------------------------------------
  -- get diagnostics for the whole workspace rather than only open buffers
  {
    "artemave/workspace-diagnostics.nvim",
    lazy = true,
    opts = {},
    keys = {
      {
        "<leader>lw",
        function()
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
            require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
          end
        end,
        noremap = true,
        silent = true,
        desc = "LSP populate workspace diagnostics",
      },
    },
  },

  -----------------------------------------------------------------------------
  -- LSP incremental rename
  {
    "smjonas/inc-rename.nvim",
    opts = {},
    event = "LspAttach",
    cmd = "IncRename",
  },
}
