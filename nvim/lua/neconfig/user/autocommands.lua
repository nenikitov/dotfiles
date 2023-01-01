--#region Helpers

-- Autocmd
local ac = vim.api.nvim_create_autocmd
local function ag(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end


--#endregion


--#region Auto commmands

-- Fast close buffers that are only for info
local group_fast_close = ag('fast_close')
ac(
    'FileType',
    {
        pattern = { 'help', 'man', 'lspinfo' },
        callback = function()
            vim.keymap.set('n', 'q',     '<CMD>close<CR>', { silent = true, buffer = 0 })
            vim.keymap.set('n', '<ESC>', '<CMD>close<CR>', { silent = true, buffer = 0 })
        end,
        group = group_fast_close
    }
)

--#endregion

