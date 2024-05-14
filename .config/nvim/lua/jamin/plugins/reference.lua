local res = require("jamin.resources")

return {
  -- Generates doc annotations for a variety of filetypes
  {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter", "L3MON4D3/LuaSnip" },
    cmd = "Neogen",

    opts = {
      snippet_engine = "luasnip",
      languages = {
        lua = { template = { annotation_convention = "emmylua" } },
        astro = { template = { annotation_convention = "jsdoc" } },
        svelte = { template = { annotation_convention = "jsdoc" } },
        typescript = { template = { annotation_convention = "jsdoc" } },
        typescriptreact = { template = { annotation_convention = "jsdoc" } },
      },
    },

    keys = {
      {
        "<leader>r<leader>",
        function() require("neogen").generate({}) end,
        desc = "Add reference comment (neogen)",
      },
      {
        "<leader>rm",
        function() require("neogen").generate({ type = "func" }) end,
        desc = "Add function reference comment (neogen)",
      },
      {
        "<leader>rc",
        function() require("neogen").generate({ type = "class" }) end,
        desc = "Add class reference comment (neogen)",
      },
      {
        "<leader>rt",
        function() require("neogen").generate({ type = "type" }) end,
        desc = "Add type reference comment (neogen)",
      },
      {
        "<leader>rb",
        function() require("neogen").generate({ type = "file" }) end,
        desc = "Add buffer reference comment (neogen)",
      },
    },
  },

  -----------------------------------------------------------------------------
  -- open rule documentation for linters
  {
    "chrisgrieser/nvim-rulebook",
    keys = {
      { "<leader>rx", function() require("rulebook").ignoreRule() end },
      { "<leader>rl", function() require("rulebook").lookupRule() end },
      { "<leader>ry", function() require("rulebook").yankDiagnosticCode() end },
    },
    config = function()
      require("rulebook").setup({})

      local virtual_text_enabled = true
      local virtual_text_config = {
        source = "if_many",
        severity = { min = vim.diagnostic.severity.WARN },
        prefix = function(diag)
          return require("rulebook").hasDocs(diag) and res.icons.ui.docs or res.icons.ui.square
        end,
      }

      vim.diagnostic.config({ virtual_text = virtual_text_config })

      keymap("n", "<leader>sv", function()
        virtual_text_enabled = not virtual_text_enabled
        vim.diagnostic.config({
          virtual_text = virtual_text_enabled and virtual_text_config or false,
        })
        print(
          string.format(
            "%s %s",
            "diagnostic virtual text",
            virtual_text_enabled and "enabled" or "disabled"
          )
        )
      end, "Toggle diagnostic virtual text")
    end,
  },

  -----------------------------------------------------------------------------
  -- Read https://devdocs.io directly in neovim
  {
    "luckasRanarison/nvim-devdocs",
    build = { ":DevdocsFetch", ":DevdocsUpdateAll" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },

    cmd = {
      "DevdocsFetch",
      "DevdocsInstall",
      "DevdocsUninstall",
      "DevdocsOpen",
      "DevdocsOpenFloat",
      "DevdocsOpenCurrent",
      "DevdocsOpenCurrentFloat",
      "DevdocsUpdate",
      "DevdocsUpdateAll",
    },

    -- stylua: ignore
    keys = {
      { "<leader>ro", "<CMD>DevdocsOpen<CR>", desc = "Open ref (devdocs)" },
      { "<leader>rO", "<CMD>DevdocsOpenFloat<CR>", desc = "Open floating ref (devdocs)" },
      { "<leader>rr", "<CMD>DevdocsOpenCurrent<CR>", desc = "Open ref by filetype (devdocs)" },
      { "<leader>rR", "<CMD>DevdocsOpenCurrentFloat<CR>", desc = "Open floating ref by filetype (devdocs)" },
    },

    opts = function()
      -- calculate the width and height of the floating window
      local ui = vim.api.nvim_list_uis()[1] or { width = 160, height = 120 }
      local width = math.floor(ui.width / 2)

      -- use glow to render docs, if installed - https://github.com/charmbracelet/glow
      local glow_opts = vim.fn.executable("glow") ~= 1 and {}
        or {
          previewer_cmd = "glow",
          picker_cmd = true,
          cmd_args = { "-s", "dark", "-w", width },
          picker_cmd_args = { "-s", "dark" },
          cmd_ignore = {
            "astro",
            "bash",
            "css",
            "docker",
            "dom",
            "gnu_make",
            "go",
            "html",
            "http",
            "javascript",
            "jest",
            "jq",
            "lodash-4",
            "lua-5.4",
            "markdown",
            "node",
            "npm",
            "react",
            "sass",
            "sqlite",
            "svelte",
            "svg",
            "tailwindcss",
            "typescript",
            "vite",
            "vue-3",
          },
        }

      return vim.tbl_deep_extend("force", glow_opts, {
        mappings = { open_in_browser = "<C-o>" },
        -- stylua: ignore
        filetypes = {
          css = { "css", "tailwindcss" },
          scss = { "css", "sass", "tailwindcss" },
          html = { "javascript", "dom", "html", "css" },
          javascript = { "javascript", "dom", "node" },
          typescript = { "javascript", "typescript", "dom", "node" },
          javascriptreact = { "javascript", "dom", "html", "react", "css", "tailwindcss" },
          typescriptreact = { "javascript", "typescript", "dom", "html", "react", "css", "tailwindcss" },
          vue = { "javascript", "dom", "html", "vue", "css", "tailwindcss" },
          svelte = { "javascript", "dom", "html", "svelte", "css", "tailwindcss" },
          astro = { "javascript", "dom", "node", "html", "astro", "css", "tailwindcss" },
        },
        float_win = {
          relative = "editor",
          width = width,
          height = ui.height - 7,
          col = ui.width - 1,
          row = ui.height - 3,
          anchor = "SE",
          style = "minimal",
          border = res.icons.border,
        },
        after_open = function(bufnr)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<CMD>bd!<CR>", {})
          vim.cmd.set("conceallevel=2")
          vim.cmd.set("nowrap")
        end,
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- GPT plugin (requires OpenAI API key)
  {
    "robitx/gp.nvim",
    cond = vim.fn.filereadable(vim.env.DOTFILES .. "/cache/openai.txt.gpg") == 1
      and vim.env.USE_COPILOT ~= "1",
    cmd = { "GpAgent", "GpChatFinder", "GpChatNew", "GpChatPaste", "GpChatToggle" },

    --stylua: ignore
    keys = {
      { "<leader>c", ":GpAgent<CR>", desc = "Print agent (chatgpt)" },
      { "<leader>c<Tab>", ":GpNextAgent<CR>", desc = "Next agent (chatgpt)" },
      { "<leader>c/", ":GpChatFinder<CR>", desc = "Find session (chatgpt)" },
      { "<leader>c<CR>", ":GpChatToggle<CR>", desc = "Toggle (chatgpt)", mode = { "n", "v" } },
      { "<leader>cp", ":GpChatPaste<CR>", desc = "Paste to recent (chatgpt)", mode = { "n", "v" } },
      { "<leader>ca", ":GpAppend<CR>", desc = "Append response (chatgpt)", mode = { "n", "v" } },
      { "<leader>ci", ":GpImplement<CR>", desc = "Implement code (chatgpt)", mode = { "n", "v" } },
      { "<leader>ce", ":GpExplain<CR>", desc = "Explain code (chatgpt)", mode = { "n", "v" } },
      { "<leader>cr", ":GpReview<CR>", desc = "Review code (chatgpt)", mode = { "n", "v" } },
      { "<leader>ct", ":GpTests<CR>", desc = "Generate tests (chatgpt)", mode = { "n", "v" } },
      { "<leader>cd", ":GpDocs<CR>", desc = "Generate docs (chatgpt)", mode = { "n", "v" } },
      { "<leader>co", ":GpOptimize<CR>", desc = "Optimize code (chatgpt)", mode = { "n", "v" } },
      { "<leader>cf", ":GpFix<CR>", desc = "Fix code (chatgpt)", mode = { "n", "v" } },
    },

    opts = {
      openai_api_key = {
        "gpg",
        "--decrypt",
        vim.fs.normalize(vim.env.DOTFILES .. "/cache/openai.txt.gpg"),
      },
      chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<M-CR>" },
      chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<M-BS>" },
      chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<M-Space>" },
      chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<M-c>" },
      hooks = {
        Explain = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please respond by explaining the code, assuming I am a senior software engineer."
          local agent = gp.get_chat_agent()
          gp.Prompt(
            params,
            gp.Target.vnew("markdown"),
            nil,
            agent.model,
            template,
            agent.system_prompt
          )
        end,

        Tests = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please implement tests."
          local agent = gp.get_command_agent()
          gp.Prompt(params, gp.Target.vnew, nil, agent.model, template, agent.system_prompt)
        end,

        Fix = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "There is a problem in this code. Rewrite the code to show it with the bug fixed."
          local agent = gp.get_command_agent()
          gp.Prompt(params, gp.Target.vnew, nil, agent.model, template, agent.system_prompt)
        end,

        Optimize = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please optimize the code to improve performance and readablilty."
          local agent = gp.get_command_agent()
          gp.Prompt(params, gp.Target.rewrite, nil, agent.model, template, agent.system_prompt)
        end,

        Docs = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please respond with a docstring comment to prepend. Pay attention to adding parameter and return types (if applicable) and mention any errors that might be raised or returned, depending on the language."
          local agent = gp.get_command_agent()
          gp.Prompt(params, gp.Target.prepend, nil, agent.model, template, agent.system_prompt)
        end,

        Review = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please analyze for code smells and suggest improvements in markdown format."
          local agent = gp.get_chat_agent()
          gp.Prompt(
            params,
            gp.Target.vnew("markdown"),
            nil,
            agent.model,
            template,
            agent.system_prompt
          )
        end,
      },
    },
  },

  -----------------------------------------------------------------------------
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cond = vim.env.USE_COPILOT == "1",
    branch = "canary",
    dependencies = { "zbirenbaum/copilot.lua", "nvim-lua/plenary.nvim" },
    opts = {
      show_help = false,
      mappings = {
        submit_prompt = { normal = "<M-CR>", insert = "<M-CR>" },
        reset = { normal = "<M-BS>", insert = "<M-BS>" },
      },
    },

    cmd = {
      "CopilotChat",
      "CopilotChatCommit",
      "CopilotChatCommitStaged",
      "CopilotChatDocs",
      "CopilotChatExplain",
      "CopilotChatFix",
      "CopilotChatFixDiagnostic",
      "CopilotChatLoad",
      "CopilotChatOptimize",
      "CopilotChatReset",
      "CopilotChatReview",
      "CopilotChatTests",
      "CopilotChatToggle",
    },

    keys = {
      {
        "<leader>c<CR>",
        ":CopilotChatToggle<CR>",
        desc = "Toggle vsplit (copilot chat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ce",
        ":CopilotChatExplain<CR>",
        desc = "Explain code (copilot chat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ct",
        ":CopilotChatTests<CR>",
        desc = "Generate tests (copilot chat)",
        mode = { "n", "v" },
      },
      {
        "<leader>cd",
        ":CopilotChatDocs<CR>",
        desc = "Generate docs (copilot chat)",
        mode = { "n", "v" },
      },
      {
        "<leader>cr",
        ":CopilotChatReview<CR>",
        desc = "Review code (copilot chat)",
        mode = { "n", "v" },
      },
      {
        "<leader>co",
        ":CopilotChatOptimize<CR>",
        desc = "Optimize code (copilot chat)",
        mode = { "n", "v" },
      },
      {
        "<leader>cm",
        ":CopilotChatCommit<CR>",
        desc = "Generate commit message (copilot chat)",
        mode = { "v", "n" },
      },
      {
        "<leader>cM",
        "<CMD>CopilotChatCommitStaged<CR>",
        desc = "Generate commit message for staged files (copilot chat)",
      },
      { "<leader>cf", ":CopilotChatFix<CR>", desc = "Fix code (copilot chat)", mode = "v" },
      {
        "<leader>cf",
        "<CMD>CopilotChatFixDiagnostic<CR>",
        desc = "Fix diagnostic (copilot chat)",
        mode = "n",
      },
      {
        "<leader>cx",
        "<CMD>CopilotChatReset<CR>",
        desc = "Reset history and clear buffer (copilot chat)",
      },
      {
        "<leader>ch",
        function()
          if not pcall(require, "telescope") then return end
          require("CopilotChat.integrations.telescope").pick(
            require("CopilotChat.actions").help_actions()
          )
        end,
        desc = "Find help actions (copilot chat)",
      },
      {
        "<leader>c/",
        function()
          if not pcall(require, "telescope") then return end
          require("CopilotChat.integrations.telescope").pick(
            require("CopilotChat.actions").prompt_actions()
          )
        end,
        desc = "Find prompt actions (copilot chat)",
      },
    },
  },
}
