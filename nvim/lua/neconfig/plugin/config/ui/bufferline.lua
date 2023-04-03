return {
    'akinsho/bufferline.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons'
    },
    config = function()
        local icons = require('neconfig.user.icons')

        require('bufferline').setup {
            options = {
                indicator = {
                    style = 'underline'
                },
                diagnostics = 'nvim_lsp',
                diagnostics_update_in_insert = true,
                diagnostics_indicator = function (_, _, diagnostics_dict, _)
                    local diagnostics_string = ' '
                    for _, type in ipairs { 'error', 'warning', 'info', 'hint' } do
                        local number = diagnostics_dict[type]
                        if number and number ~= 0 then
                            local icon = icons.diagnostics[type]
                            diagnostics_string = diagnostics_string .. icon .. ' ' .. number .. ' '
                        end
                    end
                    return '[' .. diagnostics_string:sub(1, -1) .. ']'
                end,
                show_close_icon = true,
                -- Icons
                buffer_close_icon = icons.bufferline.buffer_close,
                modified_icon = icons.bufferline.buffer_modified,
                close_icon = icons.bufferline.close,
                left_trunc_marker = icons.bufferline.left_trunc,
                right_trunc_marker = icons.bufferline.left_right,
            }
        }

        require('neconfig.user.keymaps').bufferline()
    end
}
