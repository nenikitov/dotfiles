return {
    'luukvbaal/statuscol.nvim',
    opts = function()
        local builtin = require('statuscol.builtin')
        return {
            segments = {
                {
                    sign = {
                        namespace = { 'gitsigns' },
                        colwidth = 1,
                    },
                    click = 'v:lua.ScSa',
                },
                {
                    sign = { name = { '.*' } },
                    click = 'v:lua.ScSa',
                },
                {
                    text = { builtin.lnumfunc, ' ' },
                    condition = { true, builtin.not_empty },
                    click = 'v:lua.ScLa',
                },
                {
                    text = { builtin.foldfunc, ' ' },
                    click = 'v:lua.ScFa',
                },
            },
        }
    end,
}
