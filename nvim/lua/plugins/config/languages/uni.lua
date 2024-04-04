local language = require('utils.language')

return language.register {
    tools = {
        -- Language server
        'clojure_lsp',
        -- Formatter
        'zprint',
    },
    parsers = {
        'clojure',
    },
    servers = {
        clojure_lsp = {},
    },
    formatters = {
        clojure = { 'zprint' },
    },
    plugins = {
        before_core = {
            'aklt/plantuml-syntax',
        },
    },
}
