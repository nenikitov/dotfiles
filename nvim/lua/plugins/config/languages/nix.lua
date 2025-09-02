local language = require('utils.language')

return language.register {
    tools = {
        'nil',
    },
    parsers = {
        'nix',
    },
    servers = {
        ['nil'] = {
            ['nil'] = {
                nix = {
                    flake = {
                        autoArchive = true,
                    },
                },
            },
        },
        nixd = {},
    },
    formatters = {
        nix = { 'alejandra' },
    },
    plugins = {
        after_core = {
            name = 'NixD setup',
            dir = '~/Documents/dummy.nvim/',
            config = function()
                require('lspconfig').nixd.setup {
                    settings = {
                        nixd = {
                            formatting = {
                                command = { 'alejandra' },
                            },
                        },
                    },
                    on_init = function(client, _)
                        client.server_capabilities.semanticTokensProvider = nil
                    end,
                }
                vim.api.nvim_set_hl(0, '@lsp.type.comment.nix', {})
            end,
        },
    },
}
