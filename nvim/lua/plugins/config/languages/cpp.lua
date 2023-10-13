local language = require('utils.language')

return {
    language.mason {
        -- Language server
        'clangd',
    },
    language.treesitter {
        'c',
        'cpp',
    },
    language.servers {
        clangd = {}
    },
}
