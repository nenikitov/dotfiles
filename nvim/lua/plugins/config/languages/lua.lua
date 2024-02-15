local language = require('utils.language')

return language.register {
    tools = {
        -- Language server
        'lua_ls',
        -- Linter
        'luacheck',
        -- Formatter
        'stylua',
    },
    parsers = {
        'lua',
        'luadoc',
        'luap',
    },
    servers = {
        lua_ls = {
            Lua = {
                workspace = { checkThirdParty = 'Disable' },
                telemetry = { enable = false },
            },
        },
    },
    linters = {
        lua = { 'luacheck' },
    },
    formatters = {
        lua = { 'stylua' },
    },
    plugins = {
        before_core = {
            'folke/neodev.nvim',
            config = true,
        },
    },
}
