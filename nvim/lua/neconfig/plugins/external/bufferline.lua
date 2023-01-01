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
        diagnostics_indicator = function (_, _, diagnostics_dict, _)
            local diagnostics_string = ' '
            for _, type in ipairs(diagnostics_order) do
                local number = diagnostics_dict[type]
                if number and number ~= 0 then
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
        show_close_icon = false,
    }
}

require('neconfig.user.keymaps').bufferline(bufdelete)

--#endregion


