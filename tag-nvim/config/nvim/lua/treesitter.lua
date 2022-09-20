-- treesitter
require('nvim-treesitter.configs').setup({
    auto_install = true,
    highlight = { enable = true },
})

-- treesitter textobjects
which_key_leader({
    p = {name = '+peek'},
})

require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["a/"] = "@comment.outer",
      },
      selection_modes = {
        ['@function.inner'] = 'V',
        ['@function.outer'] = 'V',
        ['@class.inner'] = 'V',
        ['@class.outer'] = 'V',
        ['@parameter.inner'] = 'v',
        ['@parameter.outer'] = 'v',
        ['@block.inner'] = 'V',
        ['@block.outer'] = 'V',
        ['@comment.outer'] = 'v',
      },
      include_surrounding_whitespace = true,
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
        ["]a"] = "@parameter.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@class.outer",
        ["]A"] = "@parameter.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[a"] = "@parameter.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@class.outer",
        ["[A"] = "@parameter.outer",
      },
    },
    lsp_interop = {
      enable = true,
      border = 'single',
      peek_definition_code = {
        ["<leader>pf"] = "@function.outer",
        ["<leader>pc"] = "@class.outer",
      },
    },
  },
}
