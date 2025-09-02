local language = require('utils.language')

return language.register {
    tools = {
        -- Language server
        'marksman',
        -- Formatter
        'prettier',
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
    },
    formatters = {
        markdown = { 'injected' },
    },
    plugins = {
        after_core = {
            'iamcco/markdown-preview.nvim',
            build = function()
                vim.fn['mkdp#util#install']()
            end,
            config = function()
                vim.cmd([[
                    let g:mkdp_preview_options = { 'uml': { 'imageFormat': 'svg' }}
                ]])
            end
        },
    },
}
