local language = require('utils.language')

return language.register {
    tools = {
        -- Language server
        'tsserver',
        'eslint',
        -- Formatter
        'prettierd',
    },
    parsers = {
        'javascript',
        'jsdoc',
        'tsx',
        'typescript',
    },
    servers = {
        tsserver = {},
        eslint = {},
    },
    formatters = {
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescriptreact = { 'prettierd' },
    },
}
