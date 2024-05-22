; extends

; MDX import/export syntax
(((inline) @_inline (#match? @_inline "^\(import\|export\)")) @injection.content
  (#set! injection.language "tsx"))
