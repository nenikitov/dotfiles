return {
    'RRethy/nvim-treesitter-endwise',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    config = function(_, opts)
        ---@diagnostic disable-next-line: missing-fields -- Treesitter is already initialized, no need to pass all parameters
        require('nvim-treesitter.configs').setup {
            endwise = opts,
        }
    end,
    opts = {
        enable = true,
    },
}
