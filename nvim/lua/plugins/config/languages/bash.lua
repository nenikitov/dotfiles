local language = require('utils.language')

return {
    language.mason {
        -- Language server
        'bashls',
    },
    language.treesitter {
        'bash'
    },
    language.servers {
        bashls = {},
    },
}
