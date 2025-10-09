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
                capabilities = function(capabilities)
                    capabilities.textDocument.completion.completionItem.snippetSupport = true
                    return capabilities
                end,
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
