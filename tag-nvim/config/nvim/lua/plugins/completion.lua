vim.pack.add({
    'https://github.com/rafamadriz/friendly-snippets',
    {
        src = 'https://github.com/saghen/blink.cmp', -- VeryLazy
        version = vim.version.range('^1'),
    },
})

require('blink.cmp').setup({
    keymap = {
        preset = 'enter',
    },
    completion = {
        documentation = {
            auto_show = true,
            window = {
                border = 'rounded',
            },
        },
        list = {
            selection = {
                preselect = false,
            },
        },
    },
    cmdline = {
        completion = {
            menu = {
                auto_show = true,
            },
            list = {
                selection = {
                    preselect = false,
                },
            },
        },
    },
    signature = {
        enabled = true,
        window = {
            border = 'rounded',
        },
    },
})
