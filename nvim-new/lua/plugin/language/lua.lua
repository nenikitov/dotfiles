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
                lua_ls = true
            }
        }
    },
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {},
    }
}
