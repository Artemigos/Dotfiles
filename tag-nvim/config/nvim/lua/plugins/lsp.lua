return {
    {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
    },
    { 'ray-x/lsp_signature.nvim' },
    { 'onsails/lspkind-nvim' },
    {
        "someone-stole-my-name/yaml-companion.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("telescope").load_extension("yaml_schema")
        end,
    },

    -- null-ls
    { 'jose-elias-alvarez/null-ls.nvim' },
    {
        'jayp0521/mason-null-ls.nvim',
        config = function() require('user.null-ls') end
    },
}
