" configuration
let g:TodoDeselectedPrefix = '◻️ '
let g:TodoSelectedPrefix = '☑️ '

" code
function! ConfigureTodo()
    setlocal tabstop=2
    setlocal shiftwidth=2 expandtab

    nnoremap <buffer> <CR> :ToggleTodo<CR>
    vnoremap <buffer> <CR> :ToggleTodo<CR>
endfunction

function! EscapeForRegex(str)
    return escape(a:str, '^$.*?/\[]')
endfunction

function! MatchesPrefix(str, prefix)
    let l:escaped = EscapeForRegex(a:prefix)
    if match(a:str, '^\s*' . l:escaped . '.*') != -1
        return 1
    endif
    return 0
endfunction

function! SwapPrefix(lineno, current_prefix, new_prefix)
    let l:line = getline(a:lineno)
    let l:pattern = '^\(\s*\)' . EscapeForRegex(a:current_prefix)
    let l:changed = substitute(l:line, l:pattern, '\1' . a:new_prefix, '')
    call setline(a:lineno, l:changed)
endfunction

function! AddPrefix(lineno, new_prefix)
    let l:line = getline(a:lineno)
    let l:changed = substitute(l:line, '^\(\s*\)', '\1' . a:new_prefix, '')
    call setline(a:lineno, l:changed)
endfunction

function! TodoIsSelected(lineno)
    let l:line = getline(a:lineno)
    if MatchesPrefix(l:line, g:TodoDeselectedPrefix)
        return 0
    endif
    if MatchesPrefix(l:line, g:TodoSelectedPrefix)
        return 1
    endif
    return -1
endfunction

function! ToggleTodo()
    let l:lineno = line('.')
    let l:selected = TodoIsSelected(l:lineno)

    if l:selected == -1
        call AddPrefix(l:lineno, g:TodoDeselectedPrefix)
        return 0
    endif

    if l:selected
        call SwapPrefix(l:lineno, g:TodoSelectedPrefix, g:TodoDeselectedPrefix)
        return 0
    else
        call SwapPrefix(l:lineno, g:TodoDeselectedPrefix, g:TodoSelectedPrefix)
        return 1
    endif
endfunction

augroup todo_mappings
    autocmd!
    autocmd BufRead,BufNewFile todo.txt call ConfigureTodo()

    command! -range ToggleTodo silent <line1>,<line2>call ToggleTodo()
augroup end

