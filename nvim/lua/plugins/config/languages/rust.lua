local language = require('utils.language')

language.mason {
    -- Language server
    'rust-analyzer',
}
language.treesitter {
    'rust',
    'toml',
}
language.servers {
    ['rust-analyzer'] = {
        cargo = {
            allFeatures = true,
        },
    },
}

return {}
