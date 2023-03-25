return {
  "dbeniamine/cheat.sh-vim", -- integrates https://cht.sh
  event = "VeryLazy",
  init = function()
    vim.g.CheatSheetDoNotMap = true
  end,
  config = function()
    vim.cmd [[
        " Toggle comments globally
        nnoremap <script> <silent> <leader>cC :call cheat#toggleComments()<CR>

         " Toggle comments for previous request
        nnoremap <script> <silent> <leader>cc :call cheat#navigate(0, 'C')<CR>
        vnoremap <script> <silent> <leader>cc :call cheat#navigate(0, 'C')<CR>

        " Create new buffer for the query's answer
        nnoremap <script> <silent> <leader>cb
                    \ :call cheat#cheat("", getcurpos()[1], getcurpos()[1], 0, 0, '!')<CR>
        vnoremap <script> <silent> <leader>cb :call cheat#cheat("", -1, -1, 2, 0, '!')<CR>

        " Repeat previous query
        vnoremap <script> <silent> <leader>c.  :call cheat#session#last()<CR>
        nnoremap <script> <silent> <leader>c.  :call cheat#session#last()<CR>

        " Replace question with answer in current buffer
        nnoremap <script> <silent> <leader>cr
                    \ :call cheat#cheat("", getcurpos()[1], getcurpos()[1], 0, 1, '!')<CR>
        vnoremap <script> <silent> <leader>cr :call cheat#cheat("", -1, -1, 2, 1, '!')<CR>

        " Paste answer into current buffer
        nnoremap <script> <silent> <leader>cP
                    \ :call cheat#cheat("", getcurpos()[1], getcurpos()[1], 0, 4, '!')<CR>
        vnoremap <script> <silent> <leader>cP :call cheat#cheat("", -1, -1, 4, 1, '!')<CR>

        nnoremap <script> <silent> <leader>cp
                    \ :call cheat#cheat("", getcurpos()[1], getcurpos()[1], 0, 3, '!')<CR>
        vnoremap <script> <silent> <leader>cp :call cheat#cheat("", -1, -1, 3, 1, '!')<CR>

        " Query an error from the quickfix list
        nnoremap <script> <silent> <leader>ce :call cheat#cheat("", -1, -1 , -1, 5, '!')<CR>
        vnoremap <script> <silent> <leader>ce :call cheat#cheat("", -1, -1, -1, 5, '!')<CR>

        " Go to the next/previous answer
        nnoremap <script> <silent> <leader>can :call cheat#navigate(1, 'A')<CR>
        vnoremap <script> <silent> <leader>can :call cheat#navigate(1, 'A')<CR>
        nnoremap <script> <silent> <leader>cap :call cheat#navigate(-1,'A')<CR>
        vnoremap <script> <silent> <leader>cap :call cheat#navigate(-1,'A')<CR>

        " Go to the next/previous question
        nnoremap <script> <silent> <leader>cqn :call cheat#navigate(1,'Q')<CR>
        vnoremap <script> <silent> <leader>cqn :call cheat#navigate(1,'Q')<CR>
        nnoremap <script> <silent> <leader>cqp :call cheat#navigate(-1,'Q')<CR>
        vnoremap <script> <silent> <leader>cqp :call cheat#navigate(-1,'Q')<CR>

        " Go to the next/previous query in history
        nnoremap <script> <silent> <leader>chn :call cheat#navigate(1, 'H')<CR>
        vnoremap <script> <silent> <leader>chn :call cheat#navigate(1, 'H')<CR>
        nnoremap <script> <silent> <leader>chp :call cheat#navigate(-1, 'H')<CR>
        vnoremap <script> <silent> <leader>chp :call cheat#navigate(-1, 'H')<CR>

        " Go to the next/previous 'see also' section
        nnoremap <script> <silent> <leader>csn :call cheat#navigate(1,'S')<CR>
        vnoremap <script> <silent> <leader>csn :call cheat#navigate(1,'S')<CR>
        nnoremap <script> <silent> <leader>csp :call cheat#navigate(-1,'S')<CR>
        vnoremap <script> <silent> <leader>csp :call cheat#navigate(-1,'S')<CR>
      ]]
  end,
}
