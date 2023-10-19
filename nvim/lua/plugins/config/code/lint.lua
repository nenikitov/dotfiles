local language = require('utils.language')

return {
    language.mason {
        'cspell'
    },
    {
        --'mfussenegger/nvim-lint',
        dir = '~/SharedFiles/Projects/nvim/nvim-lint/',
        dependencies = {
            'williamboman/mason.nvim',
        },
        config = function(_, opts)
            local lint = require('lint')

            local all_filetypes = opts.linters_by_ft['*']
            opts.linters_by_ft['*'] = nil
            lint.linters_by_ft = opts.linters_by_ft

            local group = vim.api.nvim_create_augroup('lint', {})

            vim.api.nvim_create_autocmd(opts.events, {
                group = group,
                callback = function()
                    require('lint').try_lint()
                end,
            })
            vim.api.nvim_create_autocmd(opts.events, {
                group = group,
                callback = function()
                    require('lint').try_lint(all_filetypes)
                end,
            })
        end,
        opts = function()
            return {
                linters_by_ft = {
                    --['*'] = { 'cspell' },
                },
                events = { 'BufWritePost', 'BufReadPost', 'BufEnter', 'InsertLeave', 'TextChanged' },
            }
        end,
    },
}
