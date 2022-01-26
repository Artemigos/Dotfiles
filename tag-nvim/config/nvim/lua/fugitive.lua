which_key_leader({ g = { name = '+git' } })

nmap('<Leader>gg', ':Git<CR>')
nmap('<Leader>gi', ':Git commit<CR>')
nmap('<Leader>gc', ':Telescope git_commits<CR>')
nmap('<Leader>gp', ':Git push<CR>')
nmap('<Leader>gl', ':Git pull<CR>')
nmap('<Leader>gb', ':Telescope git_branches<CR>')
nmap('<Leader>gs', ':Telescope git_stash<CR>')
