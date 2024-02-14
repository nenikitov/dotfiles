local language = require('utils.language')

language.mason {
    -- Language server
    'marksman',
    'texlab',
    -- Formatter
    'prettier',
    'latexindent',
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
    texlab = {},
}
language.formatters {
    markdown = { 'injected' },
    tex = { 'latexindent' },
}

return {
    {
        'iamcco/markdown-preview.nvim',
        build = function()
            vim.fn['mkdp#util#install']()
        end,
    },
}
