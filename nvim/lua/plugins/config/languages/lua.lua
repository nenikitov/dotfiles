local language = require('utils.language')

return {
    {
        'folke/neodev.nvim',
        opts = {}
    },
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
    language.formatters {
        lua = { 'stylua' },
    },
}
