return {
    {
        'williamboman/mason-lspconfig.nvim',
        opts = {},
        dependencies = { 'mason.nvim' }
    },
    {
        'neovim/nvim-lspconfig',
        event = 'LazyFile',
        dependencies = { 'mason-lspconfig.nvim' },
        config = function(_, opts)
        end,
    }
}
