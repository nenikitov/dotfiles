local icons = require('user.icons')

return {
    'ray-x/lsp_signature.nvim',
    opts = {
        doc_lines = 0,
        floating_window = false,
        handler_opts = {
            border = icons.border,
        },
        hint_prefix = icons.lsp_signature
    },
}
