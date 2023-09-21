return {
    dir = '',
    name = 'treesitter-highlight',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    config = function(_, opts)
        require('nvim-treesitter.configs').setup {
            highlight = opts
        }
    end,
    opts = function()
        return {
            enable = true,
            additional_vim_regex_highlighting = false
        }
    end
}
