local language = require('utils.language')

return language.register {
    tools = {
        -- CLOSURE
        -- Language server
        'clojure_lsp',
        -- Formatter
        'zprint',

        -- JAVA
        -- Language server
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
    linters = {
        sql = { 'sqlfluff' },
    },
    formatters = {
        clojure = { 'zprint' },
        sql = { 'sqlfluff' },
    },
    plugins = {},
}
