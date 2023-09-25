local keymaps = require('user.keymaps')
local icons = require('user.icons')

return {
    'lewis6991/gitsigns.nvim',
    config = true,
    opts = function()
        return {
            signs = vim.tbl_map(
                function(icon) return { text = icon } end,
                icons.gitsigns
            ),
            preview_config = {
                border = icons.border
            },
            on_attach = function(buf)
                keymaps.gitsigns(buf)
            end
        }
    end
}
