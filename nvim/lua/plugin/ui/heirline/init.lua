---@module 'lazy'
---@module 'heirline'

local defs = require('defs')
local util = require('util')

---@param name string
---@return table
local function section_highlight(name)
    local group = vim.api.nvim_get_hl(0, { name = name, link = false })
    local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })

    local function hex(color)
        return color and ('#%06x'):format(color)
    end

    return {
        fg = hex(group.fg or normal.fg),
        bg = hex(group.bg),
        ctermfg = group.ctermfg or normal.ctermfg,
        ctermbg = group.ctermbg,
        bold = group.bold,
    }
end

---@type LazySpec
return {
    'rebelot/heirline.nvim', -- for statusline and tabline
    dependencies = { defs.plugins.mini_icons },
    event = 'UIEnter',
    config = function()
        local basic = require('plugin.ui.heirline.modules.basic')
        local cursor = require('plugin.ui.heirline.modules.cursor')
        local file = require('plugin.ui.heirline.modules.file')
        local git = require('plugin.ui.heirline.modules.git')
        local input = require('plugin.ui.heirline.modules.input')
        local lsp = require('plugin.ui.heirline.modules.lsp')

        local slayout = require('plugin.ui.heirline.layouts.statusline')

        ---@class ne.plugin.heirline.ShowWidths
        local SHOW_WIDTHS = {
            ICONS = 150,
            DETAILS = 110,
            CONTEXT = 65,
            MINIMAL = 40,
        }

        ---@class ne.plugin.heirline.FlexPriorities
        local FLEX_PRIORITIES = {
            ESSENTIAL = 1
        }

        local statusline = slayout.statusline({
            highlight = function(active, section, mode)
                if not active then
                    return 'StatusLineNC'
                end

                local distance = math.abs(section)
                if distance >= 3 then
                    return section_highlight('CurSearch')
                elseif distance == 2 then
                    return section_highlight('Visual')
                end
                return section_highlight('CursorLine')
            end,

            section_separator = function(section)
                return section < 0 and defs.icons.status_line.section.left or defs.icons.status_line.section.right
            end,

            component_separator = function(section)
                return section < 0 and defs.icons.status_line.component.left or defs.icons.status_line.component.right
            end,

            active = {
                [-3] = {
                    input.mode(),
                    basic.by_width({
                        { min = SHOW_WIDTHS.CONTEXT, input.selection() },
                    }),
                    input.recording(),
                },
                [-2] = {
                    basic.by_width({
                        { min = SHOW_WIDTHS.ICONS, git.branch() },
                        { min = SHOW_WIDTHS.DETAILS, git.branch({ icon = false }) },
                    }),
                    basic.by_width({
                        { min = SHOW_WIDTHS.ICONS, git.diff({ show_when_zero = 'with_nonzero' }) },
                        { min = SHOW_WIDTHS.CONTEXT, git.diff({ show_when_zero = false, icon = false }) },
                    }),
                },
                [-1] = {
                    basic.by_width({
                        {
                            min = SHOW_WIDTHS.ICONS,
                            {
                                flexible = FLEX_PRIORITIES.ESSENTIAL,
                                file.name({ name = 'full' }),
                                file.name({ name = 'full', max_directory_length = 20 }),
                                file.name({ name = 'shorten' }),
                                file.name({ name = 'filename' }),
                            },
                        },
                        {
                            flexible = FLEX_PRIORITIES.ESSENTIAL,
                            file.name({ name = 'full', icon = false }),
                            file.name({ name = 'full', max_directory_length = 20, icon = false }),
                            file.name({ name = 'shorten', icon = false }),
                            file.name({ name = 'filename', icon = false }),
                        },
                    }),
                    basic.by_width({
                        { min = SHOW_WIDTHS.CONTEXT, file.flags() },
                    }),
                },
                [1] = {
                    basic.by_width({
                        { min = SHOW_WIDTHS.ICONS, file.encoding() },
                        { min = SHOW_WIDTHS.DETAILS, file.encoding({ icon = false }) },
                    }),
                    basic.by_width({
                        { min = SHOW_WIDTHS.ICONS, file.line_ending() },
                        { min = SHOW_WIDTHS.DETAILS, file.line_ending({ icon = false }) },
                    }),
                    basic.by_width({
                        { min = SHOW_WIDTHS.DETAILS, file.indent() },
                    }),
                    basic.by_width({
                        { min = SHOW_WIDTHS.ICONS, file.filetype() },
                        { min = SHOW_WIDTHS.DETAILS, file.filetype({ icon = false }) },
                    }),
                },
                [2] = {
                    basic.by_width({
                        { min = SHOW_WIDTHS.ICONS, lsp.diagnostics({ show_when_zero = 'with_nonzero' }) },
                        lsp.diagnostics({ show_when_zero = false, icon = false }),
                    }),
                    basic.by_width({
                        { min = SHOW_WIDTHS.ICONS, lsp.progress() },
                        { min = SHOW_WIDTHS.DETAILS, lsp.progress({ icon = false }) },
                        { min = SHOW_WIDTHS.MINIMAL, lsp.progress({ percentage = false }) },
                    }),
                    basic.by_width({
                        { min = SHOW_WIDTHS.ICONS, lsp.clients() },
                        { min = SHOW_WIDTHS.CONTEXT, lsp.clients({ icon = false }) },
                    }),
                },
                [3] = {
                    basic.by_width({
                        { min = SHOW_WIDTHS.ICONS, cursor.scroll() },
                    }),
                    basic.by_width({
                        { min = SHOW_WIDTHS.CONTEXT, cursor.location() },
                        cursor.location({ line_width = 0, column_width = 0 }),
                    }),
                },
            },

            inactive = {
                [-1] = { file.name({ name = 'filename' }) },
                [1] = { cursor.location() },
            },
        })

        require('heirline').setup({ statusline = statusline })

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
        for _, module in ipairs({ input, file, git, lsp, cursor }) do
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
    end,
}
