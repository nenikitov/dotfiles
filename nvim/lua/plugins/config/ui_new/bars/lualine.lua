local icons = require('user.icons')

local IMPORTANT = 70
local NOT_IMPORTANT = 90

---@param min_width number
---@return fun(str: string): string
local function hide(min_width)
    return function(str)
        local width
        if vim.api.nvim_get_option_value('laststatus', {}) == 3 then
            width = vim.api.nvim_get_option_value('columns', {})
        else
            width = vim.fn.winwidth(0)
        end

        if width < min_width then
            return ''
        else
            return str
        end
    end
end

return {
    'nvim-lualine/lualine.nvim',
    opts = function()
        local noice = require('noice')

        local lsp_status = false
        local old_handler = vim.lsp.handlers['$/progress']
        vim.lsp.handlers['$/progress'] = function(err, result, context, config)
            old_handler(err, result, context, config)

            if result.value.kind == 'report' then
                lsp_status = result.value
            elseif result.value.kind == 'end' then
                lsp_status = result.value
            end
        end

        return {
            options = {
                component_separators = icons.status_bar.separator.component,
                section_separators = icons.status_bar.separator.section,
            },
            -- Sections
            -- ┌───┬───┬─────────────────────────────────┬───┬───┐
            -- │ A │ B │ C                             X │ Y │ Z │
            -- └───┴───┴─────────────────────────────────┴───┴───┘
            sections = {
                lualine_a = {
                    'mode',
                    'selectioncount',
                    -- Recording
                    {
                        function()
                            ---@type string
                            local mode = noice.api.status.mode.get()
                            local macro = mode:match('^recording @(.*)$')
                            return icons.status_bar.macro .. macro
                        end,
                        cond = function()
                            return noice.api.status.mode.has()
                        end,
                    },
                    -- LSP progress
                    {
                        function()
                            return vim.inspect(lsp_status)
                        end
                    },
                },
                lualine_b = {
                    {
                        'branch',
                        icon = icons.status_bar.branch,
                        fmt = hide(IMPORTANT),
                    },
                    {
                        'diff',
                        symbols = icons.status_bar.diff,
                        source = function()
                            local gitsigns = vim.b.gitsigns_status_dict
                            if gitsigns then
                                return {
                                    added = gitsigns.added,
                                    modified = gitsigns.changed,
                                    removed = gitsigns.removed,
                                }
                            end
                        end,
                    },
                },
                lualine_c = {
                    {
                        'filename',
                        symbols = icons.status_bar.file_name,
                    },
                },
                lualine_x = {
                    {
                        'encoding',
                        fmt = hide(NOT_IMPORTANT),
                    },
                    {
                        'fileformat',
                        symbols = icons.status_bar.file_format,
                        fmt = hide(NOT_IMPORTANT),
                    },
                    -- Fancy spaces
                    {
                        function()
                            local sw = vim.api.nvim_get_option_value('shiftwidth', { buf = 0 })
                            local ts = vim.api.nvim_get_option_value('tabstop', { buf = 0 })
                            if sw == ts then
                                return icons.status_bar.space.space .. sw
                            else
                                return icons.status_bar.space.space
                                    .. sw
                                    .. ' '
                                    .. icons.status_bar.space.tab
                                    .. ts
                            end
                        end,
                    },
                    {
                        'filetype',
                        fmt = hide(NOT_IMPORTANT),
                    },
                },
                lualine_y = {
                    {
                        'diagnostics',
                        update_in_insert = true,
                        symbols = icons.status_bar.diagnostics,
                    },
                    {
                        function()
                            local clients = vim.tbl_map(function(c)
                                return c.name
                            end, vim.lsp.get_clients { bufnr = 0 })
                            if #clients <= 3 then
                                return table.concat(clients, ', ')
                            else
                                return table.concat(
                                    { clients[1], clients[2], clients[3], '+' .. (#clients - 3) },
                                    ', '
                                )
                            end
                        end,
                        fmt = hide(IMPORTANT),
                    },
                },
                lualine_z = {
                    {
                        'progress',
                        fmt = hide(NOT_IMPORTANT),
                    },
                    {
                        'location',
                    },
                },
            },
        }
    end,
}
