---@module 'lazy'
---@module 'noice'

local util = require('util')
local shared = require('shared')

---@type LazySpec
return {
    'folke/noice.nvim',
    dependencies = {
        'MunifTanjim/nui.nvim',
    },
    event = 'VeryLazy',
    ---@type NoiceConfig
    opts = {
        notify = {
            enabled = false,
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
            message = {
                enabled = false,
            },
        },
        messages = {
            enabled = true,
            view_search = 'virtualtext',
        },
        cmdline = {
            opts = {},
            format = {
                cmdline = {
                    pattern = '^:',
                    icon = shared.icons.cmdline.command,
                    lang = 'vim',
                },
                search_down = {
                    kind = 'search',
                    pattern = '^/',
                    icon = shared.icons.cmdline.search_down,
                    lang = 'regex',
                },
                search_up = {
                    kind = 'search',
                    pattern = '^%?',
                    icon = shared.icons.cmdline.search_up,
                    lang = 'regex',
                },
                filter = {
                    pattern = '^:%s*!',
                    icon = shared.icons.cmdline.shell,
                    lang = 'bash'
                },
                lua = {
                    pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' },
                    icon = shared.icons.cmdline.lua,
                    lang = 'lua'
                },
                help = {
                    pattern = '^:%s*he?l?p?%s+',
                    icon = shared.icons.cmdline.help,
                },
                calculator = {
                    pattern = '^=',
                    icon = shared.icons.cmdline.expression,
                    lang = 'vimnormal',
                },
                input = {
                    view = 'cmdline_input',
                    icon = shared.icons.cmdline.input,
                },
                IncRename = {
                    icon = shared.icons.cmdline.rename,
                },
            },
        },
        presets = {
            inc_rename = true,
        },
        popupmenu = {
            enabled = false,
        },
    },
    config = function(_, opts)
        require('noice').setup(opts)

        util.vim.autocmd_multiple_events({
            -- Popups keep the position they were opened at when the terminal is resized
            'VimResized',
        }, {
            group = util.vim.augroup('ne.plugin.noice_refresh'),
            desc = 'Force-refresh noice UI on events upstream missed',
            callback = function()
                for view, _ in pairs(require('noice.message.router').get_views()) do
                    ---@cast view NuiView
                    if view.is_mounted and view:is_mounted() then
                        pcall(view.update_layout, view)
                    end
                end

                local position = require('noice.ui.cmdline').position
                if position and vim.api.nvim_win_is_valid(position.win) then
                    local config = vim.api.nvim_win_get_config(position.win)
                    local row, col = unpack(config.relative == 'win' and vim.api.nvim_win_get_position(config.win) or { 0, 0 })
                    vim.g.ui_cmdline_pos = { row + config.row + position.bufpos.row, col + config.col + position.bufpos.col - 2 }
                end
            end,
        })
    end,
}
