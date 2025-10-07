return {
    "folke/which-key.nvim",
    opts = {
        preset = 'modern',
        win = {
            padding = {0, 0},
            width = math.huge,
        },
        keys = {
            scroll_up = '<C-y>',
            scroll_down = '<C-e>',
        }
    },
    config = function (_, opts)
        require('which-key').setup(opts)
        vim.api.nvim_create_autocmd('VimResized', {
            group = vim.api.nvim_create_augroup("WhichKey", { clear = true }),
            callback = function ()
                require('which-key.view').update()
            end
        })
    end,
    keys = function()
        return {
            { "<LEADER>?", require('which-key').show, desc = "Show all keymaps" },
        }
    end,
    event = "VeryLazy"
}
