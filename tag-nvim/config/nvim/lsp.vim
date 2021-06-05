" clean up behavior of completion menu
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set signcolumn=yes

" setup <Tab> as navigation through completions
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)

" keybindings
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g<Space> <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> ga <cmd>lua vim.lsp.buf.code_action()<CR>
inoremap <silent> <C-Space> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-Space> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" show diagnostics when cursor is on it
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

lua << EOF
local on_attach = function(client)
    vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    require('completion').on_attach(client)
end

require('lspconfig').rust_analyzer.setup({
    on_attach = on_attach
})

require('lspconfig').bashls.setup({
    on_attach = on_attach
})

require('lspconfig').vimls.setup({
    on_attach = on_attach
})
EOF

