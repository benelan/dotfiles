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
set t_Co=256
if exists('+termguicolors')
    set termguicolors
endif

" Fix modern terminal features
" https://sw.kovidgoyal.net/kitty/faq/#using-a-color-theme-with-a-background-color-does-not-work-well-in-vim
" Styled and colored underline support
let &t_AU = "\e[58:5:%dm"
let &t_8u = "\e[58:2:%lu:%lu:%lum"
let &t_Us = "\e[4:2m"
let &t_Cs = "\e[4:3m"
let &t_ds = "\e[4:4m"
let &t_Ds = "\e[4:5m"
let &t_Ce = "\e[4:0m"
" Strikethrough
let &t_Ts = "\e[9m"
let &t_Te = "\e[29m"
" Truecolor support
let &t_8f = "\e[38:2:%lu:%lu:%lum"
let &t_8b = "\e[48:2:%lu:%lu:%lum"
let &t_RF = "\e]10;?\e\\"
let &t_RB = "\e]11;?\e\\"
" Bracketed paste
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
let &t_PS = "\e[200~"
let &t_PE = "\e[201~"
" Cursor control
let &t_RC = "\e[?12$p"
let &t_SH = "\e[%d q"
let &t_RS = "\eP$q q\e\\"
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[1 q"
let &t_VS = "\e[?12l"
" Focus tracking
let &t_fe = "\e[?1004h"
let &t_fd = "\e[?1004l"
" Window title
let &t_ST = "\e[22;2t"
let &t_RT = "\e[23;2t"

" vim hardcodes background color erase even if the terminfo file does
" not contain bce. This causes incorrect background rendering when
" using a color theme with a background color in terminals such as
" kitty that do not support background color erase.
let &t_ut=''

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
