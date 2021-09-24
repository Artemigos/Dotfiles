" clean up behavior of completion menu
set completeopt=menuone,noinsert,noselect
set shortmess+=c

" some quality of life settings
set signcolumn=yes
set cmdheight=2

" devicons
lua << EOF
require'nvim-web-devicons'.setup {
    default = true
}
EOF

" lspkind
lua << EOF
require'lspkind'.init {}
EOF

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
vnoremap <silent> ga :<C-U>lua vim.lsp.buf.range_code_action()<CR>
nnoremap <silent> gt <cmd>lua vim.lsp.buf.type_definition()<CR>
inoremap <silent> <C-Space> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-Space> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> gx <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> gT :Telescope lsp_dynamic_workspace_symbols<CR>
nnoremap <silent> gX :Telescope lsp_document_diagnostics<CR>

" Leader keybindings
if exists('g:which_key_map')
    let g:which_key_map.c = { 'name': '+code' }
    let g:which_key_map.r = { 'name': '+refactor' }
endif

nmap <silent> <Leader>cd <cmd>lua vim.lsp.buf.definition()<CR>
nmap <silent> <Leader>cD <cmd>lua vim.lsp.buf.implementation()<CR>
nmap <silent> <Leader>cr <cmd>lua vim.lsp.buf.references()<CR>
nmap <silent> <Leader>c<Space> <cmd>lua vim.lsp.buf.hover()<CR>
nmap <silent> <Leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
vmap <silent> <Leader>ca :<C-U>lua vim.lsp.buf.range_code_action()<CR>
nmap <silent> <Leader>ct <cmd>lua vim.lsp.buf.type_definition()<CR>
nmap <silent> <Leader>cx <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nmap <silent> <Leader>cT :Telescope lsp_dynamic_workspace_symbols<CR>
nmap <silent> <Leader>cX :Telescope lsp_document_diagnostics<CR>

nmap <silent> <Leader>rr <cmd>lua vim.lsp.buf.rename()<CR>

" show diagnostics when cursor is on it
autocmd! CursorHold <buffer> lua vim.lsp.buf.document_highlight()
autocmd! CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references()

lua << EOF
local on_attach = function(client)
    vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    require('completion').on_attach(client)
end

-- TODO: cssls?, dockerls, html, jedi_language_server/pylsp/pyright, jsonls, stylelint_lsp?, sumneko_lua, yamlls

require('lspconfig').rust_analyzer.setup({
    on_attach = on_attach
})

require('lspconfig').bashls.setup({
    on_attach = on_attach
})

require('lspconfig').vimls.setup({
    on_attach = on_attach
})

local pid = vim.fn.getpid()
local omnisharp_bin = vim.env.HOME .. "/.omnisharp/run"
require('lspconfig').omnisharp.setup({
    cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
    on_attach = on_attach
})
EOF

