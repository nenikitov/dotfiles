local language = require('utils.language')

language.mason {
    -- Language server
    'clangd',
    'cpplint',
}
language.treesitter {
    'c',
    'cpp',
}
language.servers {
    clangd = {},
}

return {}
