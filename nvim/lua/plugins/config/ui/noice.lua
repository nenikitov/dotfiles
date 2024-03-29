local icons = require('user.icons')

return {
    'folke/noice.nvim',
    dependencies = {
        'MunifTanjim/nui.nvim',
        'rcarriga/nvim-notify',
        'nvim-treesitter/nvim-treesitter',
    },
    opts = {
        routes = {
            {
                filter = {
                    event = 'msg_show',
                    any = {
                        { find = '%d+L, %d+B written' },
                        { find = '; after #%d+' },
                        { find = '; before #%d+' },
                        { find = '%d fewer lines' },
                        { find = '%d more lines' },
                    },
                },
                opts = { skip = true },
            },
        },
        cmdline = {
            format = {
                cmdline = {
                    pattern = '^:',
                    icon = icons.cmd_line.cmdline,
                    lang = 'vim',
                },
                search_down = {
                    kind = 'search',
                    pattern = '^/',
                    icon = icons.cmd_line.search_down,
                    lang = 'regex',
                },
                search_up = {
                    kind = 'search',
                    pattern = '^%?',
                    icon = icons.cmd_line.search_up,
                    lang = 'regex',
                },
                filter = {
                    title = 'Shell',
                    pattern = '^:%s*!',
                    icon = icons.cmd_line.bash,
                    lang = 'bash',
                },
                lua = {
                    pattern = { '^:%s*lua%s+' },
                    icon = icons.cmd_line.lua,
                    lang = 'lua',
                },
                calculator = {
                    pattern = { '^:%s*=', '^:%s*lua%s+=' },
                    icon = icons.cmd_line.calculator,
                    lang = 'lua',
                },
                help = {
                    pattern = '^:%s*he?l?p?%s+',
                    icon = icons.cmd_line.help,
                },
                rename = {
                    pattern = '^:%s*IncRename%s+',
                    icon = icons.cmd_line.rename,
                },
                input = {}, -- Used by input()
            },
            --[[format = (function()
                local f = {}
                for k, v in ipairs(icons.cmd_line) do
                    f[k] = { icon = v }
                end
                return vim.tbl_deep_extend('force', f, {
                    {
                        lua = { pattern = '^:%s*lua%s+' },
                    },
                    {
                        rename = { pattern = '^:%s*IncRename%s+' },
                    },
                })
            end)()]]
        },
        lsp = {
            progress = {
                enabled = false,
            },
            hover = {
                enabled = false,
            },
            signature = {
                enabled = false,
            },
        },
        views = {
            cmdline_popup = {
                border = {
                    style = icons.border,
                },
            },
            popup = {
                border = {
                    style = icons.border,
                },
            },
        },
    },
}
