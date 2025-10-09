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
            build = ":call mkdp#util#install()",
            config = function()
                vim.cmd([[
                    let g:mkdp_preview_options = { 'uml': { 'imageFormat': 'svg' } }
                ]])
            end
        },
    },
}
