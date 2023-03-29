return {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
        require('indent_blankline').setup {
            show_current_context = true,
            char_blankline = '┆'
        }
    end,
}
