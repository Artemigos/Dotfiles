return {
    {
        'saghen/blink.cmp',
        dependencies = 'rafamadriz/friendly-snippets',
        event = 'VeryLazy',
        version = '1.*',
        opts = {
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
            signature = {
                enabled = true,
                window = {
                    border = 'rounded',
                },
            },
        },
    },
}
