local keymaps = require('user.keymaps')

return {
    'numToStr/Comment.nvim',
    opts = function()
        return vim.tbl_extend(
            'force',
            keymaps.comment(),
            {}
        )
    end
}
