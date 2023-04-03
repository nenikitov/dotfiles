return {
    'numToStr/Comment.nvim',
    dependencies = {
        'JoosepAlviste/nvim-ts-context-commentstring'
    },
    config = function()
        require('Comment').setup {
            toggler = require('neconfig.user.keymaps').comment().toggler,
            opleader = require('neconfig.user.keymaps').comment().opleader,
            extra = require('neconfig.user.keymaps').comment().extra,
            pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
        }
    end
}
