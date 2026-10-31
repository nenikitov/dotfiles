---@module 'lazy'
---@module 'heirline'

local defs = require('defs')
local util = require('util')

---@type LazySpec
return {
    'rebelot/heirline.nvim', -- for statusline and tabline
    dependencies = { defs.plugins.mini_icons },
    event = 'UIEnter',
    config = function()
        local basic = require('plugin.ui.heirline.basic')
        local file = require('plugin.ui.heirline.file')
        local git = require('plugin.ui.heirline.git')
        local input = require('plugin.ui.heirline.input')
        local lsp = require('plugin.ui.heirline.lsp')

        local statusline = { input.mode(), file.name(), git.branch(), lsp.progress() }

        require('heirline').setup({
            statusline = basic.background('DiffDelete', statusline),
        })

        local group = vim.api.nvim_create_augroup('ne.heirline', { clear = true })

        -- Redraw, at most once per tick
        local pending = false
        local function redraw()
            if pending then
                return
            end
            pending = true
            vim.schedule(function()
                pending = false
                vim.cmd.redrawstatus({ bang = true })
            end)
        end

        local events = {}
        for _, module in ipairs({ file, git, input, lsp }) do
            vim.list_extend(events, module.events or {})
        end

        util.vim.autocmd_multiple_events(events, {
            group = group,
            callback = redraw,
        })

        -- Recreate merged highlight groups after colorscheme changes
        util.vim.autocmd_multiple_events({
            'ColorScheme',
            { 'OptionSet', pattern = 'background' },
        }, {
            group = group,
            callback = function()
                require('heirline.utils').on_colorscheme({})
            end,
        })
    end
}
