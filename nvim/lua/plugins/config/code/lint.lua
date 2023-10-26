local language = require('utils.language')

return {
    {
        --'mfussenegger/nvim-lint',
        dir = '~/SharedFiles/Projects/nvim/nvim-lint/',
        dependencies = {
            'williamboman/mason.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
        },
        config = function(_, opts)
            --require('mason-registry').get_package('cspell'):install()
            -- TODO Add install CSPELL

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
        opts = {
            linters_by_ft = vim.tbl_deep_extend('force', {
                --['*'] = { 'cspell' },
            }, language.get_linters()),
            events = { 'BufWritePost', 'BufReadPost', 'BufEnter', 'InsertLeave', 'TextChanged' },
        },
    },
}
