return {
    'lewis6991/gitsigns.nvim',
    config = function()
        require('gitsigns').setup {
            signs = (function()
                local icons = {}
                for k, v in pairs(require('neconfig.user.icons').gitsigns) do
                    icons[k] = { text = v }
                end
                return icons
            end)(),
            preview_config = {
                border = 'single'
            },
            on_attach = function(bufnr)
                require('neconfig.user.keymaps').gitsigns()
            end
        }
    end
}
