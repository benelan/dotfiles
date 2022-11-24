local status_ok, telescope = pcall(require, "telescope")
if not status_ok then return end

local telescope_actions = require "telescope.actions"

telescope.setup {
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "auto" },
    set_env = { ["COLORTERM"] = "truecolor" },
    file_ignore_patterns = {
      ".git/",
      "node_modules/",
      "dist/",
      "build/",
      "assets/",
      ".mp3",
      ".mp4",
      ".mkv",
      ".m4a",
      ".m4p"
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim",
      "--hidden",
      "--glob=!.git/",
    },
    mappings = {
      i = {
        ["<Down>"] = telescope_actions.cycle_history_next,
        ["<Up>"] = telescope_actions.cycle_history_prev,
        ["<C-j>"] = telescope_actions.move_selection_next,
        ["<C-k>"] = telescope_actions.move_selection_previous,
        ['<tab>'] = telescope_actions.toggle_selection + telescope_actions.move_selection_next,
        ['<s-tab>'] = telescope_actions.toggle_selection + telescope_actions.move_selection_previous,
        -- ['<C-p>'] = telescope_actions.toggle_preview,
        ["<esc>"] = telescope_actions.close
      },
      n = {
        ["<C-j>"] = telescope_actions.move_selection_next,
        ["<C-k>"] = telescope_actions.move_selection_previous
      }
    },
  },
  pickers = {
    find_files = {
      mappings = {
        n = {
          -- change directory in normal mode
          ["<leader>cd"] = function(prompt_bufnr)
            local selection = telescope_actions.state.get_selected_entry()
            local dir = vim.fn.fnamemodify(selection.path, ":p:h")
            telescope_actions.close(prompt_bufnr)
            vim.cmd(string.format("silent cd %s", dir))
          end
        }
      }
    },
  },
}

telescope.load_extension('fzf')
