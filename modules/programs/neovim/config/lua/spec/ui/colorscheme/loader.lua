    return {
        'nenikitov/colorscheme-loader.nvim',
        opts = {
            custom = vim.g.colorschemes,
        },
        init = function(self)
            require('colorscheme_loader').setup(self.opts)
        end,
        config = function() end,
    }
