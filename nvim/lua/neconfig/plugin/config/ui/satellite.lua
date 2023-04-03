return {
    'lewis6991/satellite.nvim',
    config = function()
        require('satellite').setup {
            handlers = {
                winblend = 0,
                gitsigns = {
                    signs = {
                        add    = '┃',
                        change = '┃',
                        delete = '┃',
                    }
                },
                diagnostic = {
                    min_severity = vim.diagnostic.severity.INFO
                }
            }
        }
    end
}
