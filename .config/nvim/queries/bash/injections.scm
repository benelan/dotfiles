; extends

((command
   name: (command_name) @command
   redirect: (herestring_redirect
               (string) @injection.content))
 (#eq? @command "python3")
 (#offset! @injection.content 0 1 0 -1)
 (#set! injection.language "python")
 (#set! injection.include-children))

; echo "
; local a = 1
; " > file.lua
(redirected_statement
  body: (command
          name: (command_name (word) @_cmd)
          argument: [(string) (raw_string)] @injection.content)
  redirect: (file_redirect
              destination: (_) @injection.filename)
  (#eq? @_cmd echo)
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children))

; cat <<'EOF' > file.lua
; local a = 1
; EOF
(redirected_statement
  body: (_) @_cmd
  redirect: (heredoc_redirect
              redirect: (file_redirect
                          destination: (_) @injection.filename)
              (heredoc_body) @injection.content)
  (#eq? @_cmd cat)
  (#set! injection.include-children))


; https://mise.jdx.dev/mise-cookbook/neovim.html
;
; ============================================================================
; #MISE comments - TOML injection
; ============================================================================
; This injection captures comment lines starting with "#MISE " or "#[MISE]" or
; "# [MISE]" and treats them as TOML code blocks for syntax highlighting.
;
; #MISE format
; The (#offset!) directive skips the "#MISE " prefix (6 characters) from the source
((comment) @injection.content
  (#lua-match? @injection.content "^#MISE ")
  (#offset! @injection.content 0 6 0 1)
  (#set! injection.language "toml"))

; #[MISE] format
((comment) @injection.content
  (#lua-match? @injection.content "^#%[MISE%] ")
  (#offset! @injection.content 0 8 0 1)
  (#set! injection.language "toml"))

; # [MISE] format
((comment) @injection.content
  (#lua-match? @injection.content "^# %[MISE%] ")
  (#offset! @injection.content 0 9 0 1)
  (#set! injection.language "toml"))

; ============================================================================
; #USAGE comments - KDL injection
; ============================================================================
; This injection captures consecutive comment lines starting with "#USAGE " or
; "#[USAGE]" or "# [USAGE]" and treats them as a single KDL code block for
; syntax highlighting.
;
; #USAGE format
((comment) @injection.content
  (#lua-match? @injection.content "^#USAGE ")
  ; Extend the range one byte to the right, to include the trailing newline.
  ; see https://github.com/neovim/neovim/discussions/36669#discussioncomment-15054154
  (#offset! @injection.content 0 7 0 1)
  (#set! injection.combined)
  (#set! injection.language "kdl"))

; #[USAGE] format
((comment) @injection.content
  (#lua-match? @injection.content "^#%[USAGE%] ")
  (#offset! @injection.content 0 9 0 1)
  (#set! injection.combined)
  (#set! injection.language "kdl"))

; # [USAGE] format
((comment) @injection.content
  (#lua-match? @injection.content "^# %[USAGE%] ")
  (#offset! @injection.content 0 10 0 1)
  (#set! injection.combined)
  (#set! injection.language "kdl"))
