local language = require('utils.language')

language.mason {
    -- Language server
    'clojure_lsp',
    -- Formatter
    'zprint',
}
language.treesitter {
    'clojure',
}
language.servers {
    clojure_lsp = {},
}
language.formatters {
    clojure = { 'zprint' },
}

return {}
