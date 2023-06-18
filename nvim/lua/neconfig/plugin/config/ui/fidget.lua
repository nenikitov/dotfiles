return {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = function()
        require('fidget').setup {
            text = {
                spinner = 'dots_snake',
            },
            widow = {
                border = 'rounded'
            }
        }
    end
}
