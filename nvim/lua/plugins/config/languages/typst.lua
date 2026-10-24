local language = require('utils.language')

return language.register {
    tools = {
        -- Language server
        'tinymist',
        -- Formatter
        'typstyle',
    },
    parsers = {
        'typst',
    },
    servers = {
        tinymist = {},
    },
    formatters = {
        typst = { 'injected', 'typstyle' }
    },
    plugins = {
        after_core = {
            'chomosuke/typst-preview.nvim',
            lazy = false,
            version = '1.*',
            opts = {}
        }
    }
}
