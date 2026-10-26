local icons = require('user.icons')

return {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
        indent = icons.indent,
        scope = {
            show_start = false,
            show_end = false,
            include = {
                node_type = {
                    ['*'] = {
                        'return_statement',
                        'table_constructor',
                    },
                },
            },
        },
    },
}
