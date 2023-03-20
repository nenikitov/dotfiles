return {
    dir = '~/SharedFiles/Projects/nvim/nvim-lsp-notify',
    dependencies = {
        'rcarriga/nvim-notify',
    },
    config = function()
        require('lsp-notify').setup {
            notify = require('notify')
        }
    end
}
