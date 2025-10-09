local language = require('utils.language')

return language.register {
    tools = {
        -- Language server
        'tinymist',
        -- Formatter
        'prettypst'
    },
    parsers = {
        'typst',
    },
    servers = {
        tinymist = {},
    },
    formatters = {
        typst = { 'injected', 'prettypst' },
    },
    plugins = {
        after_core = {
          'chomosuke/typst-preview.nvim',
          lazy = false,
          version = '1.*',
          opts = {},
        }
    },
}
