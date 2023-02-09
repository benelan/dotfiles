function! s:gruvbox_material_custom() abort
    let s:palette = gruvbox_material#get_palette('medium', 'original', {'bg_orange': ['#5A3B0A', '130'], 'bg_visual_yellow': ['#A0460A', '208']})
    call gruvbox_material#highlight('CmpItemAbbrDeprecated', s:palette.grey1, s:palette.none, "strikethrough")
    call gruvbox_material#highlight('GitSignsChange', s:palette.orange, s:palette.none)
    call gruvbox_material#highlight('GitSignsChangeNr', s:palette.orange, s:palette.none)
    call gruvbox_material#highlight('GitSignsChangeLn', s:palette.none, s:palette.bg_orange)
    call gruvbox_material#highlight('DiffDelete', s:palette.bg4, s:palette.bg_diff_red)
    call gruvbox_material#highlight('DiffChange', s:palette.none, s:palette.bg_orange)
    call gruvbox_material#highlight('DiffText', s:palette.fg0, s:palette.bg_visual_yellow)
    highlight! link CursorLineNr Purple
endfunction

augroup GruvboxMaterialCustom
  autocmd!
  autocmd ColorScheme gruvbox-material call s:gruvbox_material_custom()
augroup END

set background=dark
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set t_Co=256
if exists('+termguicolors')
    set termguicolors
endif

let g:gruvbox_material_background = "soft"
let g:gruvbox_material_foreground = "original"
let g:gruvbox_material_ui_contrast = "high"
let g:gruvbox_material_statusline_style = "material"
let g:gruvbox_material_diagnostic_virtual_text = "colored"
" let g:gruvbox_material_spell_foreground = "colored"
" let g:gruvbox_material_sign_column_background = "grey"
" let g:gruvbox_material_menu_selection_background = "orange"
" let g:gruvbox_material_current_word = "bold"
" let g:gruvbox_material_visual = "reverse"

let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_diagnostic_text_highlight = 1
let g:gruvbox_material_enable_italic = 1
" let g:gruvbox_material_enable_bold = 1
" let g:gruvbox_material_disable_italic_comment = 1
" let g:gruvbox_material_transparent_background = 1
" let g:gruvbox_material_disable_terminal_colors = 1
" let g:gruvbox_material_dim_inactive_windows = 1

colorscheme gruvbox-material
