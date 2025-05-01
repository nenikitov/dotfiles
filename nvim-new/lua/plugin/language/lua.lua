return {
    -- TODO: make this into a utility
    {
        'mason-tool-installer.nvim',
        opts = {
            ensure_installed = {
                'lua_ls',
            },
        },
        event = 'VeryLazy'
    },
    {
        'nvim-lspconfig',
        opts = {
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
            }
        }
    },
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    }
}
