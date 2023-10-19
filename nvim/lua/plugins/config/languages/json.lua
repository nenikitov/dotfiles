local language = require('utils.language')

return {
    {
        'b0o/SchemaStore.nvim',
    },
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
    },
    language.formatters {
        lua = { 'prettierd' },
    },
}
