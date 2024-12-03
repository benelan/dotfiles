---Plugins for Language Server Protocal integration
---https://microsoft.github.io/language-server-protocol/

local res = require("jamin.resources")

return {
  -- Installer/manager for language servers, linters, formatters, and debuggers
  {
    "williamboman/mason.nvim",
    lazy = true,
    build = ":MasonUpdate",
    keys = { { "<leader>lm", "<CMD>Mason<CR>", desc = "Mason" } },
    opts = {
      ensure_installed = res.mason_packages,
      ui = { border = res.icons.border, height = 0.8 },
    },

    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")

      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

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

    opts = {
      ensure_installed = res.lsp_servers,
      handlers = {
        -- the zk.nvim and typescript-tools.nvim plugins setup the servers themselves,
        -- so make sure mason-lspconfig doesn't call the default handler
        -- ts_ls = function() end,
        zk = function() end,

        function(server_name)
          local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
          local has_user_opts, user_opts = pcall(require, "jamin.lsp.servers." .. server_name)

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

          local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            has_cmp and cmp_nvim_lsp.default_capabilities() or {},
            capabilities_overrides
          )

          local server_opts = vim.tbl_deep_extend(
            "force",
            { capabilities = capabilities },
            has_user_opts and user_opts or {}
          )

          require("lspconfig")[server_name].setup(server_opts)
        end,
      },
    },
  },

  -----------------------------------------------------------------------------
  -- integrates CLI linters
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        css = { "stylelint" },
        scss = { "stylelint" },
        dockerfile = { "hadolint" },
        markdown = { "markdownlint" },
        yaml = { "actionlint" },
        -- sh = { "shellcheck" }, -- replaced by bashls
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave", "TextChanged" }, {
        group = vim.api.nvim_create_augroup("jamin_linter", { clear = true }),
        callback = function() lint.try_lint() end,
      })

      local quiet = { virtual_text = false, signs = false }

      local markdownlint_ns = lint.get_namespace("markdownlint")
      vim.diagnostic.config(quiet, markdownlint_ns)

      local stylelint_ns = lint.get_namespace("stylelint")
      vim.diagnostic.config(quiet, stylelint_ns)
    end,
  },

  -----------------------------------------------------------------------------
  -- integrates CLI formatters
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>F",
        function() require("conform").format({ async = true }) end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      format_on_save = function(bufnr)
        return (vim.g.autoformat or vim.b[bufnr].autoformat)
            and not vim.tbl_contains(res.filetypes.excluded, vim.bo[bufnr].filetype)
            and { timeout_ms = 500, lsp_format = "fallback" }
          or nil
      end,
      formatters_by_ft = {
        -- "_" means filetypes w/o any other formatters configured
        ["_"] = { "trim_whitespace" },
        ["*"] = { "injected" },
        -- runs multiple formatters sequentially
        bash = { "shellcheck", "shfmt" },
        sh = { "shellcheck", "shfmt" },
        markdown = { "markdownlint", "prettier" },
        css = { "stylelint", "prettier" },
        scss = { "stylelint", "prettier" },
        json = { "fixjson", "prettier" },
        jsonc = { "fixjson", "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        astro = { "prettier" },
        svelte = { "prettier" },
        vue = { "prettier" },
        yaml = { "prettier" },
        lua = { "stylua" },
      },
      default_format_opts = { lsp_format = "fallback" },
      formatters = {
        shfmt = {
          prepend_args = { "-ci", "-i", "4" },
        },
        injected = {
          options = {
            lang_to_ext = {
              bash = "sh",
              graphql = "gql",
              javascript = "js",
              javascriptreact = "jsx",
              markdown = "md",
              perl = "pl",
              python = "py",
              ruby = "rb",
              rust = "rs",
              typescript = "ts",
              typescriptreact = "tsx",
              yaml = "yml",
            },
          },
        },
      },
    },
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
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
  -- integration with the tailwind LSP server
  {
    "luckasRanarison/tailwind-tools.nvim",
    event = "LspAttach",
    enabled = vim.tbl_contains(res.lsp_servers, "tailwindcss"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },

  -----------------------------------------------------------------------------
  -- get diagnostics for the whole workspace rather than only open buffers
  { "artemave/workspace-diagnostics.nvim", lazy = true, opts = {} },
}
