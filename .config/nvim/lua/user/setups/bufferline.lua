local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then return end

bufferline.setup {
  options = {
    diagnostics = "nvim_lsp",
    offsets = { {
      filetype = "NvimTree",
      text = "Explorer",
      padding = 1,
    } },
    show_close_icon = false,
    sort_by = "relative_directory",
  },
  highlights = {
    fill = {
      bg = { attribute = 'bg', highlight = 'TabLine' },
    },
    background = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    tab = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    tab_close = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    close_button = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    close_button_visible = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    buffer_visible = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    numbers = {
      bg = { attribute = 'bg', highlight = 'TabLine' },
    },
    numbers_visible = {
      bg = { attribute = 'bg', highlight = 'TabLine' },
    },
    diagnostic = {
      bg = { attribute = 'bg', highlight = 'TabLine' },
    },
    diagnostic_visible = {
      bg = { attribute = 'bg', highlight = 'TabLine' },
    },
    hint = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    hint_visible = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    hint_diagnostic = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    hint_diagnostic_visible = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    info = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    info_visible = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    info_diagnostic = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    info_diagnostic_visible = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    warning = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    warning_visible = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    warning_diagnostic = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    warning_diagnostic_visible = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    error = {
      bg = { attribute = 'bg', highlight = 'TabLine' },
    },
    error_visible = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    error_diagnostic = {
      bg = { attribute = 'bg', highlight = 'TabLine' },
    },
    error_diagnostic_visible = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    modified = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    modified_visible = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    duplicate_visible = {
      bg = { attribute = 'bg', highlight = 'TabLine' },
    },
    duplicate = {
      bg = { attribute = 'bg', highlight = 'TabLine' },
    },
    separator_visible = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    separator = {
      bg = { attribute = 'bg', highlight = 'TabLine' }
    },
    pick_visible = {
      bg = { attribute = 'bg', highlight = 'TabLine' },
    },
    pick = {
      bg = { attribute = 'bg', highlight = 'TabLine' },
    },
  };
}
