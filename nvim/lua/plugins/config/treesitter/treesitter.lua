local keymaps = require('user.keymaps')

return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
        keymaps.treesitter()
    end,
    opts = function()
        return {
            ensure_installed = {
                'query',
                'vim',
                'vimdoc',

                'git_config',
                'git_rebase',
                'gitattributes',
                'gitcommit',
                'gitignore',

                'awk',
                'passwd',
                'comment',
                'diff',
                'regex',
            },
            sync_install = false,
        }
    end,
}
