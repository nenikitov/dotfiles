local icons = require('user.icons')

return {
    'ray-x/lsp_signature.nvim',
    opts = {
        handler_opts = {
            border = icons.border,
        },
        hint_prefix = icons.lsp_signature
    },
}
