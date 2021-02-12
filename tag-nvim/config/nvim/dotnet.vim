if exists('g:which_key_map')
    let g:which_key_map.d = { 'name': '+dotnet' }
endif

nnoremap <Leader>dt :!dotnet test<CR>
nnoremap <Leader>db :!dotnet build<CR>
nnoremap <Leader>dr : call fzf#run(fzf#wrap(fzf#vim#with_preview({'source': 'find . -name *.csproj', 'sink': '!dotnet run --project'})))<CR>
