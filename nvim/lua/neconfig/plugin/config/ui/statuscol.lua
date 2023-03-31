return {
    'luukvbaal/statuscol.nvim',
    config = function()
        local builtin = require('statuscol.builtin')
        require('statuscol').setup {
            segments = {
                {
                    text = { '%s' },
                    click = 'v:lua.ScSa'
                },
                {
                    text = { builtin.lnumfunc, ' ' },
                    condition = { true, builtin.not_empty },
                    click = 'v:lua.ScLa',
                },
                {
                    text = { builtin.foldfunc, ' ' },
                    click = 'v:lua.ScFa'
                }
            },
            ft_ignore = {
                'NvimTree',
                'neo-tree',
                'notify'
            },
            bt_ignore = {
                'terminal'
            }
        }
    end
}
