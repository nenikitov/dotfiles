local language = require('utils.language')

return language.register {
    tools = {
        -- Language server
        'typescript-language-server',
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
        ['typescript-language-server'] = {},
        eslint = {},
    },
    formatters = {
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescriptreact = { 'prettierd' },
    },
}
