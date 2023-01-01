--#region Helpers

-- LuaLine
local lualine_status, lualine = pcall(require, 'lualine')
if not lualine_status then
    vim.notify('LuaLine not available', vim.log.levels.ERROR)
    return
end

--#endregion


--#region LuaLine

-- Sections
-- ╭───┬───┬─────────────────────────────────┬───┬───╮
-- │ A │ B │ C                             X │ Y │ Z │
-- ╰───┴───┴─────────────────────────────────┴───┴───╯
--  ███|░░░| -                             - |░░░|███
lualine.setup {
    options = {
        component_separators = '|',
        section_separators = ' '
    },
    sections = {
        lualine_a = {
            'mode'
        },
        lualine_b = {
            'branch',
            'diff',
            {
                'diagnostics',
                update_in_insert = true
            }
        },
        lualine_c = {
            {
                'aerial',
                sep = ' > '
            }
        },
        lualine_x = {
            'filename'
        },
        lualine_y = {
            'encoding',
            'fileformat',
            'filetype'
        },
        lualine_z = {
            'progress',
            'location'
        }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            'filename'
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    extensions = {
        'aerial'
    }
}

-- Tabline
lualine.hide {
    place = { 'tabline' },
    unhide = false
}

--#endregion


