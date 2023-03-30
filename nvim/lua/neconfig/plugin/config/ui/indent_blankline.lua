return {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
        require('indent_blankline').setup {
            show_current_context = true,
            show_trailing_blankline_indent = false,
        }

        -- Refresh indent lines on folds
        for _, keymap in pairs { 'zo', 'zO', 'zc', 'zC', 'za', 'zA', 'zv', 'zx', 'zX', 'zm', 'zM', 'zr', 'zR' } do
            vim.api.nvim_set_keymap('n', keymap,  keymap .. '<CMD>IndentBlanklineRefresh<CR>', { noremap=true, silent=true })
        end
    end,
}
