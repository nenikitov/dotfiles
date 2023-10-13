local language = require('utils.language')

return {
    language.mason {
        -- Language server
        'jsonls',
        -- Formatter
        'prettierd',
    },
    language.treesitter {
        'json5',
        'jsonc',
    },
    language.servers {
        jsonls = {},
    },
    language.formatters {
        lua = { 'prettierd' },
    },
}
