---@module 'lazy'
---@module 'ibl'

local util = require('util')
local defs = require('defs')

local icons = defs.icons.indent

---@type LazySpec
return {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = 'LazyFile',
    ---@type ibl.config
    opts = {
        indent = {
            char = defs.icons.indent.space,
            tab_char = icons.tab,
        },
        scope = {
            -- TODO: make this highlight indent level instead of the scope
            enabled = true,
            show_start = false,
            show_end = false,
        },
    },
    config = function(_, opts)
        require('ibl').setup(opts)

        local group = util.vim.augroup('ibl refresh')
        vim.api.nvim_create_autocmd('CmdlineChanged', {
            group = group,
            pattern = { '/', '?' },
            desc = 'Redraw indent guides while the search preview scrolls the view',
            callback = function()
                require('ibl').refresh(0)
            end,
        })
        vim.api.nvim_create_autocmd('CmdlineLeave', {
            group = group,
            pattern = { '/', '?' },
            desc = 'Redraw indent guides when the search ends or is cancelled',
            callback = function()
                vim.schedule(function()
                    require('ibl').refresh(0)
                end)
            end,
        })
    end,
}
