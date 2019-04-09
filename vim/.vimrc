" C# method text objects
let g:method_regex='\(\(public\|private\|async\|static\|virtual\|abstract\|override\|new\|protected\|internal\)\s\+\)*\a\+\s\+\a\+\(<.\{-1,}>\)\=(.\{-})\_s\{-}{'
exec 'vnoremap am :<C-U>?'.g:method_regex.'<CR>v/{<CR>%'
exec 'vnoremap im :<C-U>?'.g:method_regex.'<CR>/{<CR>vi{'
omap am :normal vam<CR>
omap im :normal vim<CR>

" indenting settings
set modeline
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" non-printable characters
set list
set listchars=trail:.,tab:>\ 

" editor appearance
set relativenumber
set cursorline

" colors
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum
set t_Co=256
set termguicolors
syntax on
colors dracula

