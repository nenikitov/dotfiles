return {
    {
        -- Hack to have an empty plugin
        dir = '',
        name = 'autoload-colorscheme',
        priority = 1000,
        dependencies = {
            -- Put all colorschemes here
            'Mofiqul/vscode.nvim',
            {
                dir = '~/SharedFiles/Projects/nvim/termcolors.nvim',
                dependencies = {
                    dir = '~/SharedFiles/Projects/nvim/highlight-builder.nvim'
                },
            }
        },
        config = function()
            -- Load colorscheme here
            require('neconfig.user.colorscheme')
        end
    },
}
