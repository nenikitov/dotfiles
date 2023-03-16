return {
    'folke/noice.nvim',
    dependencies = {
        'MunifTanjim/nui.nvim',
        'rcarriga/nvim-notify',
        'mrded/nvim-lsp-notify'
    },
    config = function()
        local noice = require('noice')
        local notify = require('notify')
        local lsp_notify = require('lsp-notify');

        noice.setup {
            presets = {
                inc_rename = true,
                lsp_doc_border = true
            },
            cmdline = {
                enabled = true,
                format = (function()
                    local icons = {}
                    for k, v in pairs(require('neconfig.user.icons').cmdline) do
                        icons[k] = { icon = v }
                    end
                    return icons
                end)()
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
                hover = { enabled = true },
                signature = { enabled = true },
                -- Manually handled by `nvim-lsp-notify`
                progress = { enabled = false, },
                message = { enabled = false },
            },
            smart_move = {
                enabled = true
            },
            -- Manually handled by `notify`
            messages = { enabled = false },
        }

        notify.setup {
            timeout = 2000,
            top_down = false,
            stages = 'slide',
            -- on_open = function(win)
            --     vim.api.nvim_win_set_config(win, { border = 'none' })
            -- end,
            icons = (function()
                local icons = {}
                for k, v in pairs(require('neconfig.user.icons').notify) do
                    local case = require('neconfig.utils.case')
                    icons[case.convert_case(k, case.cases.SNAKE, case.cases.SCREAMING)] = v
                end
                return icons
            end)(),
        }

        lsp_notify.setup {
            notify = notify
        }
    end
}
