local language = require('utils.language')

language.mason {
    -- Language server
    'tsserver',
    'eslint',
}
language.treesitter {
    'javascript',
    'jsdoc',
    'tsx',
    'typescript',
}
language.servers {
    tsserver = {},
}

return {}
