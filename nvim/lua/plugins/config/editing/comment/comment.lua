local keymaps = require('user.keymaps')

return {
    'numToStr/Comment.nvim',
    dependencies = {
        'JoosepAlviste/nvim-ts-context-commentstring',
    },
    opts = function()
        return {
            pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            toggler = keymaps.comment().toggler,
            opleader = keymaps.comment().opleader,
            extra = keymaps.comment().extra,
        }
    end,
}
