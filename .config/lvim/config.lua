-- Additional Plugins
lvim.plugins = {
    { "sainnhe/gruvbox-material" }
}

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "gruvbox-material"
lvim.builtin.lualine.options.theme = "gruvbox-material"
-- lvim.builtin.theme.name = "gruvbox"
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
    -- for input mode
    i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev
    },
    -- for normal mode
    n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous
    }
}

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
-- }

lvim.builtin.which_key.mappings["-"] = { function()
    local previous_buf = vim.api.nvim_get_current_buf()
    require("nvim-tree").open_replacing_current_buffer()
    require("nvim-tree").find_file(false, previous_buf)
end, "NvimTree in place" }

lvim.builtin.which_key.mappings["lh"] = { "<cmd>HideDiagnostic<CR>", "Hide Diagnostics" }
lvim.builtin.which_key.mappings["lg"] = { "<cmd>ShowDiagnostic<CR>", "Show Diagnostics" }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
-- lvim.builtin.nvimtree.setup.actions.open_file.quit_on_open = true
lvim.builtin.nvimtree.setup.hijack_netrw = true
lvim.builtin.nvimtree.setup.view.preserve_window_proportions = true

lvim.builtin.nvimtree.setup = {
    view = {
        mappings = {
            list = {
                -- NOTE: default to editing the file in place, netrw-style
                {
                    key = { "<C-e>", "o", "-" },
                    action = "edit_in_place"
                },
                -- NOTE: override the "split" to avoid treating nvim-tree
                -- window as special. Splits will appear as if nvim-tree was a
                -- regular window
                {
                    key = "<C-v>",
                    action = "split_right",
                    action_cb = function(node)
                        vim.cmd("vsplit " .. vim.fn.fnameescape(node.absolute_path))
                    end
                }, {
                    key = "<C-x>",
                    action = "split_bottom",
                    action_cb = function(node)
                        vim.cmd("split " .. vim.fn.fnameescape(node.absolute_path))
                    end
                },
                -- NOTE: override the "open in new tab" mapping to fix the error
                -- that occurs there
                {
                    key = "<C-t>",
                    action = "new_tab",
                    action_cb = function(node)
                        vim.cmd("tabnew " .. vim.fn.fnameescape(node.absolute_path))
                    end
                }
            }
        }
    },
    actions = {
        change_dir = {
            -- NOTE: netrw-style, do not change the cwd when navigating
            enable = false
        }
    }
}

lvim.builtin.treesitter.ensure_installed = {
    "bash",
    "c",
    "css",
    "javascript",
    "json",
    "lua",
    "python",
    "typescript",
    "tsx",
    "rust",
    "yaml",
}

lvim.builtin.treesitter.ignore_install = { "java", "haskell" }
lvim.builtin.treesitter.highlight.enable = true

-- setup formatters, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup { {
    command = "prettier"
} }

-- setup additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup { {
    command = "eslint_d"
}, {
    command = "shellcheck",
    extra_args = { "--severity", "warning" }
} }

-- setup code actions
local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup { {
    command = "eslint_d"
} }

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.json", "*.jsonc" },
    -- enable wrap mode for json files only
    command = "setlocal wrap"
})

local function organize_imports()
    local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = ""
    }
    vim.lsp.buf.execute_command(params)
end

vim.lsp.buf.execute_command({
    command = "_typescript.organizeImports",
    arguments = { vim.fn.expand("%:p") }
})

vim.api.nvim_buf_create_user_command(vim.api.nvim_get_current_buf(), 'HideDiagnostic', function()
    vim.diagnostic.hide()
    -- lvim.lsp.diagnostics.virtual_text = false
end, {
    nargs = 0
})

vim.api.nvim_buf_create_user_command(vim.api.nvim_get_current_buf(), 'ShowDiagnostic', function()
    vim.diagnostic.show()
    -- lvim.lsp.diagnostics.virtual_text = true
end, {
    nargs = 0
})

require "user.options"
require "user.keymaps"
