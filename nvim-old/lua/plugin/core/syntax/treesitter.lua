local langauge = require('util.language')

langauge.handler('parsers', function (opts)
    return {
        'nvim-treesitter',
        opts = {
            ensure_installed = opts
        }
    }
end)

return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'LazyFile',
    opts = {
        -- Is extended by specs in `language`
        ensure_installed = {
            -- Recommented to be always installed by treesitter
            'vim',
            'vimdoc',
            'query',
            'markdown',
            'markdown_inline',
            -- My own recommendations
            'diff',
            'regex',
            'comment'
        },
        highlight = {
            enable = true,
            -- Is extended by specs in `language`
            disable = {},
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
            -- Is extended by specs in `language`
            disable = {},
        }
    },
    opts_extend = {
        'ensure_installed',
        'highlight.disable',
        'indent.disable',
    },
    main = 'nvim-treesitter.configs',
}
