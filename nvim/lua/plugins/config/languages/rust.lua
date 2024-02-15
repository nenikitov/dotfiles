local language = require('utils.language')

return language.register {
    tools = {
        -- Language server
        'rust-analyzer',
    },
    parsers = {
        'rust',
        'toml',
    },
    servers = {
        ['rust-analyzer'] = {
            cargo = {
                allFeatures = true,
            },
        },
    },
}
