" C# method text objects
let g:method_regex='\(\(public\|private\|async\|static\|virtual\|abstract\|override\|new\|protected\|internal\)\s\+\)*\a\+\s\+\a\+\(<.\{-1,}>\)\=(.\{-})\_s\{-}{'
exec 'vnoremap am :<C-U>?'.g:method_regex.'<CR>v/{<CR>%'
exec 'vnoremap im :<C-U>?'.g:method_regex.'<CR>/{<CR>vi{'
omap am :normal vam<CR>
omap im :normal vim<CR>

