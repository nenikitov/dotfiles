--- Shortcut to `vim.api.nvim_create_autocmd`.
local ac = vim.api.nvim_create_autocmd
--- Shortcut to `vim.api.nvim_create_autogroup`.
local function ag(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Fast close buffers that are only for info
ac(
    'FileType',
    {
        pattern = { 'help', 'man', 'lspinfo', 'notify' },
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
