; extends

((inline) @mdx_inline (#match? @mdx_inline "^\(import\|export\)")) @nospell

; list markers/bullet points
((list_marker_minus) @markdown_list_marker_minus
  (#offset! @markdown_list_marker_minus 0 0 0 -1) (#set! conceal "•"))
((list_marker_plus) @markdown_list_marker_plus
  (#offset! @markdown_list_marker_plus 0 0 0 -1) (#set! conceal "◦"))
((list_marker_star) @markdown_list_marker_star
  (#offset! @markdown_list_marker_star 0 0 0 -1) (#set! conceal "‣"))

; checkboxes
((task_list_marker_unchecked) @markdown_check_undone (#set! conceal "☐ "))
((task_list_marker_checked) @markdown_check_done (#set! conceal "☑ "))

; box drawing characters for tables
(pipe_table_header ("|") @punctuation.special @conceal (#set! conceal "│"))
(pipe_table_delimiter_row ("|") @punctuation.special @conceal (#set! conceal "│"))
(pipe_table_delimiter_cell ("-") @punctuation.special @conceal (#set! conceal "─"))
(pipe_table_row ("|") @punctuation.special @conceal (#set! conceal "│"))

; block quotes
((block_quote_marker) @markdown_quote_marker (#set! conceal "▍"))
((block_quote (paragraph (inline
  (block_continuation) @markdown_quote_marker (#set! conceal "▍")))))
