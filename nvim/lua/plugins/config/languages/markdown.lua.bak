local language = require('utils.language')

return {
    language.mason {
        -- Language server
        'marksman',
        -- Linter
        'markdownlint',
    },
    language.treesitter {
        'markdown',
        'markdown_inline',
        'latex',
    },
    language.servers {
        marksman = {}
    },
    language.formatters {
        markdown = { 'injected' },
    },
}
