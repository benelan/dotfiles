---Plugins for AI completion and chat

local M = {}
local augroup = vim.api.nvim_create_augroup("jamin.toggle_ai_completion", {})

-- true if environment variable `COPILOT == 1` and cwd is in any project
-- true if environment variable `COPILOT != 0` and cwd is in a work project
-- otherwise, return false
function M.should_use_copilot(dir)
  local project = dir or vim.uv.cwd()
  return project ~= nil and (vim.env.COPILOT == "1" and string.match(project, vim.env.DEV) ~= nil)
    or (vim.env.COPILOT ~= "0" and string.match(project, vim.env.WORK) ~= nil)
end

-- true if environment variable `CODEIUM == 1` and cwd is in a non-work project or ~/.config/nvim
-- otherwise, return false
function M.should_use_codeium(dir)
  local project = dir or vim.uv.cwd()
  return project ~= nil
    and vim.env.CODEIUM == "1"
    and string.match(project, vim.env.WORK) == nil
    and (
      string.match(project, vim.env.DEV) ~= nil
      or string.match(project, vim.fn.stdpath("config") --[[@as string]]) ~= nil
    )
end

function M.toggle_copilot(dir) vim.cmd.Copilot(M.should_use_copilot(dir) and "enable" or "disable") end
function M.toggle_codeium(dir) vim.cmd.Codeium(M.should_use_codeium(dir) and "Enable" or "Disable") end

local ai_filetypes = vim
  .iter(vim.list_extend(vim.deepcopy(Jamin.filetypes.excluded), Jamin.filetypes.writing))
  :fold({}, function(acc, k)
    acc[k] = false
    return acc
  end)

---@type LazySpec
return {
  utils = M,
  -----------------------------------------------------------------------------
  -- "github/copilot.vim", -- official Copilot plugin written in vimscript
  {
    "zbirenbaum/copilot.lua", -- alternative written in Lua
    cond = M.should_use_copilot(),
    cmd = "Copilot",
    event = "InsertEnter",

    config = function()
      vim.api.nvim_create_autocmd("DirChanged", {
        group = augroup,
        callback = function(event) M.toggle_copilot(event.file) end,
      })

      require("copilot")
        .setup --[[@as CopilotConfig]]({
          filetypes = ai_filetypes,
          panel = {
            layout = { position = "right", ratio = 0.3 },
            keymap = {
              jump_next = "]",
              jump_prev = "[",
              refresh = "<CR>",
              accept = "<Tab>",
            },
          },
          suggestion = {
            enabled = not vim.g.codeium_enabled,
            auto_trigger = true,
            keymap = {
              accept = false, -- remapped below to add fallback
              accept_word = "<M-l>",
            },
          },
        })
    end,

    keys = {
      {
        "<Tab>",
        function()
          if require("copilot.suggestion").is_visible() then
            require("copilot.suggestion").accept()
          elseif vim.g.codeium_enabled then
            vim.api.nvim_feedkeys(vim.fn["codeium#Accept"](), "n", true)
          else
            vim.api.nvim_feedkeys(
              vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
              "n",
              false
            )
          end
        end,
        mode = "i",
        desc = "Copilot accept",
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Codeium is a free Copilot alternative - https://codeium.com/
  {
    "Exafunction/codeium.vim",
    cond = M.should_use_codeium(),
    event = "VimEnter",
    cmd = "Codeium",
    keys = {
      { "<M-l>", vim.fn["codeium#AcceptNextWord"], expr = true, silent = true, mode = "i" },
    },

    config = function()
      vim.api.nvim_create_autocmd("DirChanged", {
        group = augroup,
        callback = function(event) M.toggle_codeium(event.file) end,
      })

      vim.g.codeium_enabled = true
      vim.g.codeium_filetypes = ai_filetypes
    end,
  },

  -----------------------------------------------------------------------------
  -- Copilot chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = function()
      local user = vim.env.USER or "user"
      local openai_api_key = os.getenv("OPENAI_API_KEY")

      ---@type CopilotChat.config.Config
      return {
        model = openai_api_key and not M.should_use_copilot() and "gpt-4.1:openai" or nil,
        headers = {
          user = ("## %s%s "):format(user:sub(1, 1):upper(), user:sub(2)),
        },
        window = { border = Jamin.icons.border, width = 0.4 },
        mappings = {
          submit_prompt = { normal = "<C-s>" },
          reset = { normal = "<localleader>x", insert = "<M-x>" },
          toggle_sticky = { normal = "<localleader>s" },
          clear_stickies = { normal = "<localleader>S" },
          quickfix_answers = { normal = "<localleader>qa" },
          quickfix_diffs = { normal = "<localleader>qd" },
          jump_to_diff = { normal = "<Tab>" },
          yank_diff = { normal = "<localleader>y" },
          show_diff = { normal = "<localleader>d" },
          show_info = { normal = "<localleader>i" },
          show_context = { normal = "<localleader>c" },
          show_help = { normal = "g?" },
        },
        providers = {
          openai = not openai_api_key and nil
            or {
              prepare_input = require("CopilotChat.config.providers").copilot.prepare_input,
              prepare_output = require("CopilotChat.config.providers").copilot.prepare_output,

              get_url = function() return "https://api.openai.com/v1/chat/completions" end,

              get_headers = function()
                return {
                  Authorization = "Bearer " .. openai_api_key,
                  ["Content-Type"] = "application/json",
                }
              end,

              get_models = function(headers)
                local response, err =
                  require("CopilotChat.utils.curl").get("https://api.openai.com/v1/models", {
                    headers = headers,
                    json_response = true,
                  })
                if err then error(err) end
                return vim
                  .iter(response.body.data)
                  :filter(function(model)
                    --stylua: ignore
                    local exclude_patterns = { "audio", "babbage", "dall%-e", "davinci", "embedding", "image", "moderation", "realtime", "sora", "transcribe", "tts", "whisper" }
                    for _, pattern in ipairs(exclude_patterns) do
                      if model.id:match(pattern) then return false end
                    end
                    return true
                  end)
                  :map(function(model) return { id = model.id, name = model.id } end)
                  :totable()
              end,
            },
        },

        callback = function(response)
          local chat = require("CopilotChat")

          if vim.g.copilot_chat_title then
            chat.save(vim.g.copilot_chat_title)
            return
          end

          local prompt = [[
          Generate a very short and concise title (max 5 words) for this chat, based on this answer to my query:

          ```
          %s
          ```

          Your response should be filepath-friendly and shouldn't contain any other text, just the title. 
          ]]

          -- use AI to generate prompt title based on first AI response to user question
          chat.ask(vim.trim(prompt:format(response)), {
            headless = true, -- disable updating chat buffer and history with this question
            callback = function(gen_response)
              vim.g.copilot_chat_title = vim.trim(gen_response.content)
              print("Chat title set to: " .. vim.g.copilot_chat_title)
              chat.save(vim.g.copilot_chat_title)
            end,
          })
        end,
      }
    end,

    cmd = {
      "CopilotChat",
      "CopilotChatAgents",
      "CopilotChatCommit",
      "CopilotChatDocs",
      "CopilotChatExplain",
      "CopilotChatFix",
      "CopilotChatLoad",
      "CopilotChatModels",
      "CopilotChatOpen",
      "CopilotChatOptimize",
      "CopilotChatPrompts",
      "CopilotChatReset",
      "CopilotChatReview",
      "CopilotChatTests",
      "CopilotChatToggle",
    },

    -- stylua: ignore
    keys = {
      { "<leader>c<Tab>", ":CopilotChatToggle<CR>", desc = "Toggle (copilot chat)" },
      { "<leader>cc", ":CopilotChatToggle<CR>", desc = "Toggle (copilot chat)" },
      { "<leader>cd", ":CopilotChatDocs<CR>", desc = "Generate docs (copilot chat)", mode = { "n", "v" } },
      { "<leader>ce", ":CopilotChatExplain<CR>", desc = "Explain code (copilot chat)", mode = { "n", "v" } },
      { "<leader>cf", ":CopilotChatFix<CR>", desc = "Fix code (copilot chat)", mode = { "v", "n" } },
      { "<leader>cm", ":CopilotChatCommit<CR>", desc = "Generate commit message (copilot chat)", mode = { "v", "n" } },
      { "<leader>co", ":CopilotChatOptimize<CR>", desc = "Optimize code (copilot chat)", mode = { "n", "v" } },
      { "<leader>cr", ":CopilotChatReview<CR>", desc = "Review code (copilot chat)", mode = { "n", "v" } },
      { "<leader>ct", ":CopilotChatTests<CR>", desc = "Generate tests (copilot chat)", mode = { "n", "v" } },
      { "<leader>cp", ":CopilotChatPrompts<CR>", desc = "Select prompt action (copilot chat)", mode = { "n", "v" } },
      { "<leader>cM", ":CopilotChatModels<CR>", desc = "Select model (copilot chat)" },
      { "<leader>cs", ":CopilotChatSave ", desc = "Save chat (copilot chat)" },
      { "<leader>cl", ":CopilotChatLoad ", desc = "Load saved chat (copilot chat)" },
      {
        "<leader>cx",
        function()
          vim.g.copilot_chat_title = nil
          require("CopilotChat").reset()
        end,
        desc = "Reset (copilot chat)",
      },
    },
  },
}
