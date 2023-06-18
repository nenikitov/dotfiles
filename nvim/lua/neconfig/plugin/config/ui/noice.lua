local utils_table = require('neconfig.utils.table')

return {
    'folke/noice.nvim',
    dependencies = {
        'MunifTanjim/nui.nvim',
        'rcarriga/nvim-notify',
    },
    config = function()
        local noice = require('noice')

        noice.setup {
            presets = {
                lsp_doc_border = true
            },
            cmdline = {
                enabled = true,
                format =
                    vim.tbl_deep_extend(
                        'force',
                        -- Icons
                        utils_table.pairs_map(
                            require('neconfig.user.icons').cmdline,
                            function(key, value)
                                return key, { icon = value }
                            end
                        ),
                        -- Config
                        {
                            lua = { pattern = '^:%s*lua%s+' },
                        },
                        {
                            rename = { pattern = '^:%s*IncRename%s+' }
                        }
                    )
            },
            popupmenu = {
                enabled = false
            },
            notify = {
                enabled = true
            },
            lsp = {
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                    ['cmp.entry.get_documentation'] = true,
                },
                documentation = { enabled = true },
                hover = { enabled = true },
                signature = { enabled = true },
                -- Manually handled by `nvim-lsp-notify` or `fidget`
                progress = { enabled = false },
                message = { enabled = false },
            },
            smart_move = {
                enabled = true
            },
            -- Manually handled by `notify`
            messages = { enabled = false },
        }
    end
}
