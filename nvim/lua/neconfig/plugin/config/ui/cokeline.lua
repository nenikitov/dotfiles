local icons = require('neconfig.user.icons').buffer_line

---@param diagnostics {errors: integer, warnings: integer, infos: integer, hints: integer}
---@return string | nil severity
---@return integer | nil count
local function get_worst_diagnostic(diagnostics)
    local count = 0
    local severity = nil
    for _, d in ipairs { 'hint', 'info', 'warning', 'error' } do
        local key = d .. 's'
        if diagnostics[key] ~= 0 then
            count = diagnostics[key]
            severity = d
        end
    end
    if count == 0 then
        return nil, nil
    end
    return severity, count
end

---@param buffer {number: number}
---@return boolean
local function is_tab_hovered(buffer)
    local hovered = require('cokeline.hover').hovered()
    if hovered then
        return hovered.bufnr == buffer.number
    end
    return false
end

return {
    'willothy/nvim-cokeline',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        require('cokeline').setup {
            show_if_buffers_are_at_least = 0,
            rendering = {
                max_buffer_width = 50,
            },
            components = {
                -- Icon
                {
                    text = function(buffer)
                        return ' ' .. buffer.devicon.icon
                    end,
                    fg = function(buffer)
                        return buffer.devicon.color
                    end,
                },
                {
                    text = '  '
                },
                {
                    text = function(buffer)
                        if buffer.is_readonly then
                            return ' '
                        end
                        return ''
                    end
                },
                -- Prefix
                {
                    text = function(buffer)
                        return buffer.unique_prefix
                    end,
                },
                -- File name
                {
                    text = function(buffer)
                        return buffer.filename
                    end,
                    style = function(buffer)
                        if buffer.is_hovered and not buffer.is_focused then
                            return 'underline'
                        end
                    end,
                },
                -- Diagnostics
                {
                    text = function(buffer)
                        local severity, count = get_worst_diagnostic(buffer.diagnostics)
                        if not severity then
                            return '  '
                        end
                        return ' ' .. icons.diagnostics[severity] .. ' ' .. count
                    end,
                },
                {
                    text = '  '
                },
                -- Modified / close icon
                {
                    text = function(buffer)
                        if buffer.is_modified and not is_tab_hovered(buffer) then
                            return icons.modified
                        else
                            return icons.close
                        end
                    end,
                    on_click = function(_, _, _, _, buffer)
                        buffer:delete()
                    end,
                },
                {
                    text = ' ',
                },
            },
        }
    end,
}

--[[ return {
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
                buffer_close_icon = icons.buffer_line.close,
                modified_icon = icons.buffer_line.modified,
                close_icon = icons.buffer_line.close,
            }
        }

        require('neconfig.user.keymaps').bufferline()
    end
} ]]
