--#region Helpers

-- Bufferline
local bufferline_status, bufferline = pcall(require, 'bufferline')
if not bufferline_status then
    vim.notify('Bufferline not available', vim.log.levels.ERROR)
    return
end

-- Bufdelete
local bufdelete_status, bufdelete = pcall(require, 'bufdelete')
if not bufdelete_status then
    vim.notify('Bufdelete not available', vim.log.levels.ERROR)
    return
end

local icons = require('neconfig.user.icons').diagnostics
local diagnostics_order = { 'error', 'warning', 'info', 'hint' }

--#endregion


--#region Bufferline

bufferline.setup {
    options = {
        -- Diagnostics
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function (count, level, diagnostics_dict, context)
            local diagnostics_string = ' '
            for _, type in ipairs(diagnostics_order) do
                local number = diagnostics_dict[type]
                if number then
                    local icon = icons[type]
                    diagnostics_string = diagnostics_string .. number .. icon .. '  '
                end
            end
            return '[' .. diagnostics_string:sub(1, -2) .. ']'
        end,
        -- Handlers
        close_command = function(bufnm)
            bufdelete.bufdelete(bufnm, false)
        end,
        -- Appearence
        indicator = {
            style = 'underline'
        },
        offsets = {
            {
                filetype = 'NvimTree',
                text = 'NvimTree',
                text_align = 'center'
            }
        }
    }
}

require('neconfig.user.keymaps').bufferline(bufdelete)

--#endregion


