local language = require('utils.language')

return language.register {
    tools = {
        -- Language server
        'texlab',
        -- Formatter
        'latexindent',
    },
    parsers = {
        'latex',
    },
    servers = {
        texlab = {},
    },
    formatters = {
        tex = { 'latexindent' },
    },
    plugins = {
        after_core = {
            'frabjous/knap',
        },
    },
}
