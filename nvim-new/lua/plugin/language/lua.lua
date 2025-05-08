local language = require('util.language')

return language.language({
    tools = { 'lua_ls' },
    parsers = { 'lua', 'luadoc', 'luap' },
    servers = {
        lua_ls = {
            settings = {
                Lua = {
                    hint = {
                        enable = true,
                        setType = false,
                        paramType = true,
                        paramName = "Literal",
                        semicolon = "Disable",
                        arrayIndex = "Auto",
                    },
                    codeLens = { enable = true },
                    doc = { privateName = { '^_' } },
                    completion = {
                        callSnippet = 'Replace',
                    }
                }
            }
        }
    },
    plugins = {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    }
})
