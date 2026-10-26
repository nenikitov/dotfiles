local defs = require('defs')

return defs.lang({
    tools = {
        mason = { 'lua-language-server' },
    },
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
    completion = {
        sources_by_filetype = {
            lua = { 'lazydev' },
        },
        providers = {
            lazydev = {
                name = '[lzy]',
                module = 'lazydev.integrations.blink',
                score_offset = 100,
            },
        },
    },
    plugins = {
        {
            'folke/lazydev.nvim',
            ft = 'lua',
            opts = {
                library = {
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
    }
})
