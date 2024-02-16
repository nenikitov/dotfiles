local language = require('utils.language')

return language.register {
    tools = {
        -- Language server
        'marksman',
        'texlab',
        -- Formatter
        'prettier',
        'latexindent',
    },
    parsers = {
        'markdown',
        'markdown_inline',
        'latex',
        'html',
        'css',
        'mermaid',
    },
    servers = {
        marksman = {},
        texlab = {},
    },
    formatters = {
        markdown = { 'injected' },
        tex = { 'latexindent' },
    },
    plugins = {
        after_core = {
            'iamcco/markdown-preview.nvim',
            build = function()
                vim.fn['mkdp#util#install']()
            end,
        },
    },
}
