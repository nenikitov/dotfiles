local keymaps = require('user.keymaps')
local language = require('utils.language')

return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
        keymaps.treesitter()
    end,
    opts = {
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

            'disassembly',

            unpack(language.parsers()),
        },
        sync_install = false,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
        },
    },
}
