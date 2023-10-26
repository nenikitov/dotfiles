local language = require('utils.language')

language.mason {
    -- Language server
    'marksman',
    -- Linter
    'prettier',
}
language.treesitter {
    'markdown',
    'markdown_inline',
    'latex',
}
language.servers {
    marksman = {},
}
language.formatters {
    markdown = { 'injected', 'prettier' },
}

return {}
