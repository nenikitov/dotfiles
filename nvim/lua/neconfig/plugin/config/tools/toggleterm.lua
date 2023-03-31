return {
    'akinsho/toggleterm.nvim',
    config = function()
        require('toggleterm').setup {
            size = function(term)
                if term.direction == 'horizontal' then
                    return 12
                else
                    return vim.o.columns * 0.3
                end
            end,
            open_mapping = require('neconfig.user.keymaps').toggleterm_open(),
            on_open = function(t)
                local win = vim.wo[t.window]
                win.signcolumn = 'no'
                win.foldcolumn = '0'
            end,
            persist_size = false,
            persist_mode = false
        }

        -- Keymaps
        require('neconfig.user.keymaps').toggleterm()

        -- Open a terminal on startup
        vim.api.nvim_create_autocmd(
            'VimEnter',
            {
                callback = function()
                    vim.cmd('ToggleTerm')
                    vim.cmd('ToggleTermToggleAll')
                end,
                group = vim.api.nvim_create_augroup('open_terminal', { clear = true })
            }
        )
    end
}
