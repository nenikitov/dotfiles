local language = require('utils.language')

language.mason {
    -- Language server
    'tsserver',
    -- Linter
    'eslint',
    -- Formatter
    'prettierd',
}
language.treesitter {
    'javascript',
    'jsdoc',
    'tsx',
    'typescript',
}
language.servers {
    eslint = {},
    tsserver = {},
}
language.formatters {
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescriptreact = { 'prettier' },
}

return {}
