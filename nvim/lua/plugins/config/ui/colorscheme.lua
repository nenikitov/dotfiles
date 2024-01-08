local function colorscheme(args)
    args.priority = 1000
    return args
end

local function colorscheme_loader()
    return {
        dir = '',
        name = 'autoload-colorscheme',
        priority = 999,
        config = function()
            require('user.colorscheme').apply()
        end,
    }
end

return {
    colorscheme_loader(),
    colorscheme {
        'akinsho/horizon.nvim',
    },
    colorscheme {
        'rebelot/kanagawa.nvim',
    },
    colorscheme {
        'folke/tokyonight.nvim',
    },
    colorscheme {
        'catppuccin/nvim',
        name = 'catppuccin',
    },
    colorscheme {
        'joshdick/onedark.vim',
    },
    colorscheme {
        'nenikitov/termcolors.nvim',
        --dir = '~/SharedFiles/Projects/nvim/termcolors.nvim/',
        --'nenikitov/termcolors.nvim',
        --branch = 'remake',
        dependencies = {
            'nenikitov/highlight-builder.nvim',
            dir = '~/SharedFiles/Projects/nvim/highlight-builder.nvim/',
        },
    },
    colorscheme {
        'Mofiqul/vscode.nvim'
    }
}
