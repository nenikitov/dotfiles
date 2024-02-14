local language = require('utils.language')

language.mason {
    -- Language server
    'jsonls',
    -- Formatter
    'prettierd',
}
language.treesitter {
    'json',
    'json5',
    'jsonc',
}
language.servers {
    jsonls = function()
        return {
            settings = {
                json = {
                    schemas = require('schemastore').json.schemas(),
                    validate = { enable = true },
                },
            },
        }
    end,
}
language.formatters {
    lua = { 'prettierd' },
}

language.before_lsp {
    'b0o/SchemaStore.nvim',
}

return {}
