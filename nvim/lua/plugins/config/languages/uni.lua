local language = require('utils.language')

return language.register {
    tools = {
        -- Language server
        'clojure_lsp',
        'sqlls',
        -- Formatter
        'zprint',
        'sqlfluff',
    },
    parsers = {
        'clojure',
        'sql',
    },
    servers = {
        clojure_lsp = {},
        sqlls = {},
    },
    linters = {
        sql = { 'sqlfluff' },
    },
    formatters = {
        clojure = { 'zprint' },
        sql = { 'sqlfluff' },
    },
    plugins = {
        before_core = {
            'aklt/plantuml-syntax',
        },
    },
}
