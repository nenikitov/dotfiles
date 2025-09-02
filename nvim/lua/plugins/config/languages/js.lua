local language = require('utils.language')

return language.register {
    tools = {
        -- Language server
        'ts_ls',
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
        ts_ls = {},
        eslint = {},
    },
    formatters = {
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescriptreact = { 'prettierd' },
    },
}
