return {
    {
        'nenikitov/colorscheme-loader.nvim',
        opts = {
            custom = vim.g.colorschemes,
        },
        -- Is called before all other plugins
        init = function(spec)
            require('colorscheme_loader').setup(spec.opts)
        end
    },
    'akinsho/horizon.nvim',
    'olimorris/onedarkpro.nvim',
}
