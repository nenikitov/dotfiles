return {
    {
        'nenikitov/colorscheme-loader.nvim',
        opts = {
            custom = vim.g.colorschemes,
        },
        -- Is called before all other plugins
        init = function(self)
            require('colorscheme_loader').setup(self.opts)
        end
    },
    'akinsho/horizon.nvim',
    'olimorris/onedarkpro.nvim',
}
