return {
    'kevinhwang91/nvim-ufo',
    dependencies = {
        'kevinhwang91/promise-async',
        'neovim/nvim-lspconfig',
    },
    config = function()
        local ufo = require('ufo')

        ufo.setup {
            provide_selector = function()
                return { 'lsp', 'treesitter', 'indent' }
            end
        }

        vim.keymap.set('n', 'zR', ufo.openAllFolds)
        vim.keymap.set('n', 'zM', ufo.closeAllFolds)
    end
}
