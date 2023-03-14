--#region Helpers

-- Autocmd
local ac = vim.api.nvim_create_autocmd
local function ag(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end


--#endregion


--#region Auto commmands

-- Fast close buffers that are only for info
ac(
    'FileType',
    {
        pattern = { 'help', 'man', 'lspinfo' },
        callback = function()
            vim.keymap.set('n', 'q',     '<CMD>close<CR>', { silent = true, buffer = 0 })
            vim.keymap.set('n', '<ESC>', '<CMD>close<CR>', { silent = true, buffer = 0 })
        end,
        group = ag('fast_close')
    }
)

-- Disable auto comments on all files
ac(
    'BufEnter',
    {
        callback = function()
            vim.cmd([[set formatoptions-=cro]])
        end,
        group = ag('format_general')
    }
)

-- Ensure that the file is fully refreshed if modified outside
ac(
    { 'FocusGained', 'BufWinEnter' },
    {
        command = 'checktime',
        group = ag('change_outside')
    }
)

-- Remove trailing spaces
ac(
    'BufWritePre',
    {
        callback = function()
            local cursor = vim.api.nvim_win_get_cursor(0)
            local row, col = cursor[1], cursor[2]
            vim.api.nvim_command([[%s/\s\+$//e]])
            vim.api.nvim_win_set_cursor(0, { row, col })
        end,
        group = ag('trailing_spaces')
    }
)

--#endregion
