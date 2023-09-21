return {
    dir = '',
    name = 'treesitter-indent',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    config = function(_, opts)
        require('nvim-treesitter.configs').setup {
            indent = opts
        }
    end,
    opts = function()
        return {
            enable = true
        }
    end
}
