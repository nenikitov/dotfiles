return {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
        local null_ls = require('null-ls')

        local formatting   = null_ls.builtins.formatting
        local diagnostics  = null_ls.builtins.diagnostics
        local completion   = null_ls.builtins.completion
        local code_actions = null_ls.builtins.code_actions

        local sources = {
            -- ESLint
            code_actions.eslint,
            diagnostics.eslint.with {
                method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
            },
            formatting.eslint,
            -- StyLua
            formatting.stylua,
            -- Prettier
            formatting.prettierd.with {
                filetypes = { 'markdown' }
            },
            -- CSpell
            diagnostics.cspell.with {
                diagnostics_postprocess = function(d)
                    d.severity = vim.diagnostic.severity.HINT
                end,
                method = null_ls.methods.DIAGNOSTICS_ON_SAVE
            },
            code_actions.cspell,
        }

        null_ls.setup {
            sources = sources
        }
    end
}
