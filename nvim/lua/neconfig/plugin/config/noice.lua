return {
    'folke/noice.nvim',
    dependencies = {
        'MunifTanjim/nui.nvim',
        'rcarriga/nvim-notify',
    },
    config = function()
        local noice = require('noice')

        noice.setup {
            cmdline = {
                enabled = true,
                view = 'cmdline',
                format = (function()
                    local icons = {}
                    for k, v in pairs(require('neconfig.user.icons').cmdline) do
                        icons[k] = { icon = v }
                    end
                    return icons
                end)()
            },
            messages = {
                enabled = false
            },
            popupmenu = {
                enabled = false
            },
            notify = {
                enabled = true
            },
            lsp = {
                progress = {
                    enabled = false
                },
                hover = {
                    enabled = false
                },
                signature = {
                    enabled = false
                },
                message = {
                    enabled = false
                },
            },
            smart_move = {
                enabled = false
            },

            -- cmdline = {
            --     view = 'cmdline',
            -- },
            -- lsp = {
            --     override = {
            --         ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            --         ["vim.lsp.util.stylize_markdown"] = true,
            --         ["cmp.entry.get_documentation"] = true,
            --     }
            -- },
        }
    end
}
