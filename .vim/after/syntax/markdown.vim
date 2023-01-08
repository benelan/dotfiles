syn region markdownLink matchgroup=markdownLinkDelimiter start="(" end=")"
      \ contains=markdownUrl keepend contained conceal

syn region markdownLinkText matchgroup=markdownLinkTextDelimiter
      \ start="!\=\[\%(\_[^]]*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@="
      \ nextgroup=markdownLink,markdownId skipwhite
      \ contains=@markdownInline,markdownLineStart
      \ concealends

