local language = require('utils.language')

return {
    language.mason {
        -- Language server
        'lua_ls',
        -- Linter
        'luacheck',
        -- Formatter
        'stylua',
    },
    language.treesitter {
        'lua',
        'luadoc',
        'luap',
    },
    language.servers {
        lua_ls = {
            Lua = {
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
            },
        },
    },
    language.linters {
        lua = { 'luacheck' },
    },
    language.formatters {
        lua = { 'stylua' },
    },
}
