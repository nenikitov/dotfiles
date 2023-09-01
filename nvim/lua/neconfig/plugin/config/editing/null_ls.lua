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
            -- code_actions.eslint,
            -- diagnostics.eslint.with {
            --     method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
            -- },
            -- formatting.eslint,
            -- StyLua
            formatting.stylua,
            -- Prettier
            formatting.prettierd,
            -- CSpell
            diagnostics.cspell.with {
                diagnostics_postprocess = function(d)
                    -- Set as hint
                    d.severity = vim.diagnostic.severity.HINT
                    -- Limit to first character
                    d.end_col = math.min(d.col + 1, d.end_col)
                    d.end_lnum = d.lnum
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
