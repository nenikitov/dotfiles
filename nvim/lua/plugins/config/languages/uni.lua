local language = require('utils.language')

return language.register {
    tools = {
        -- CLOJURE
        -- Language server
        'clojure_lsp',
        -- Formatter
        'zprint',

        -- JAVA
        'jdtls',

        -- SQL
        'sqlls',
        'sqlfluff',
    },
    parsers = {
        'clojure',
        'java',
        'sql',
    },
    servers = {
        clojure_lsp = {},
        jdtls = {},
        sqlls = {},
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
