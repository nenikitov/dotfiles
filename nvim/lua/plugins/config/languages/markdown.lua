local language = require('utils.language')

language.mason {
    -- Language server
    'marksman',
    -- Formatter
    'prettier',
}
language.treesitter {
    'markdown',
    'markdown_inline',
    'latex',
    'html',
    'css',
}
language.servers {
    marksman = {},
}
language.formatters {
    markdown = { 'injected', 'prettier' },
}

return {
    {
        'iamcco/markdown-preview.nvim',
        build = function()
            vim.fn['mkdp#util#install']()
        end,
    },
}
