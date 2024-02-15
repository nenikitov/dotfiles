local language = require('utils.language')

return language.register {
    tools = {
        -- Language server
        'jsonls',
        -- Formatter
        'prettierd',
    },
    parsers = {
        'json',
        'json5',
        'jsonc',
    },
    servers = {
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
    formatters = {
        json = { 'prettierd' },
    },
    plugins = {
        before_core = {
            'b0o/SchemaStore.nvim',
        },
    },
}
