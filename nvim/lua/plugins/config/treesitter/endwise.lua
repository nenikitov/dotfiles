return {
    'RRethy/nvim-treesitter-endwise',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    config = function(_, opts)
        require('nvim-treesitter.configs').setup {
            endwise = opts
        }
    end,
    opts = function()
        return {
            enable = true
        }
    end
}
