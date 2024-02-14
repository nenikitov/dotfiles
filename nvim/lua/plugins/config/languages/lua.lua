local language = require('utils.language')

language.mason {
    -- Language server
    'lua_ls',
    -- Linter
    'luacheck',
    -- Formatter
    'stylua',
}
language.treesitter {
    'lua',
    'luadoc',
    'luap',
}
language.servers {
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = 'Disable' },
            telemetry = { enable = false },
        },
    },
}
language.linters {
    lua = { 'luacheck' },
}
language.formatters {
    lua = { 'stylua' },
}

language.before_lsp {
    'folke/neodev.nvim',
    config = true,
}

return {}
