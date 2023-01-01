--#region Helpers

-- LuaLine
local lualine_status, lualine = pcall(require, 'lualine')
if not lualine_status then
    vim.notify('LuaLine not available', vim.log.levels.ERROR)
    return
end

--#endregion


--#region LuaLine

-- Custom components
local function spaces()
    return 'Spaces: ' .. vim.api.nvim_buf_get_option(0, 'shiftwidth')
end
local function progress_graphic()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local chars = { '⠀', '⠁', '⠉', '⠋', '⠛', '⠟', '⠿', '⡿' ,'⣿', '█' }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
return chars[index]
end

-- Sections
-- ╭───┬───┬─────────────────────────────────┬───┬───╮
-- │ A │ B │ C                             X │ Y │ Z │
-- ╰───┴───┴─────────────────────────────────┴───┴───╯
--  ███|░░░| -                             - |░░░|███
lualine.setup {
    options = {
        component_separators = '|',
        section_separators = ' ',
        disabled_filetypes = {
            'NvimTree', 'aerial'
        }
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
            spaces,
            'filetype'
        },
        lualine_z = {
            progress_graphic,
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


