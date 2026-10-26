local colorscheme = require('user.colorscheme')

return {
    {
        'nenikitov/colorscheme-loader.nvim',
        priority = 1000,
        dependencies = {
            'akinsho/horizon.nvim',
            'rebelot/kanagawa.nvim',
            'folke/tokyonight.nvim',
            {
                'catppuccin/nvim',
                name = 'catppuccin',
            },
            'joshdick/onedark.vim',
            'Mofiqul/vscode.nvim',
            {
                'nenikitov/termcolors.nvim',
                dependencies = {
                    'nenikitov/highlight-builder.nvim',
                },
            },
        },
        opts = {
            custom = colorscheme.colorscheme,
            fallback = colorscheme.colorscheme_fallback,
        },
    },
}
