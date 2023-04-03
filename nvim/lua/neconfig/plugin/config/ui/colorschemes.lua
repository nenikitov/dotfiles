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
            -- Load colorscheme here
            require('neconfig.user.colorscheme')
        end
    }
end

return {
    colorscheme_loader(),
    colorscheme {
        'Mofiqul/vscode.nvim'
    },
    colorscheme {
        'marko-cerovac/material.nvim',
        config = function()
            require('material').setup {
                plugins = {
                    'gitsigns',
                    'indent-blankline',
                    'nvim-cmp',
                    'nvim-tree',
                    'nvim-web-devicons',
                    'telescope',
                    'which-key',
                }
            }
            vim.g['material_style'] = 'deep ocean'
        end
    },
    colorscheme {
        dir = '~/SharedFiles/Projects/nvim/termcolors.nvim',
        dependencies = {
            dir = '~/SharedFiles/Projects/nvim/highlight-builder.nvim'
        },
    },
    colorscheme {
        'rebelot/kanagawa.nvim',
    },
    colorscheme {
        'wuelnerdotexe/vim-enfocado',
        config = function()
            vim.g['enfocado_style'] = 'neon'
        end
    },
    colorscheme {
        'LunarVim/horizon.nvim'
    }
}
