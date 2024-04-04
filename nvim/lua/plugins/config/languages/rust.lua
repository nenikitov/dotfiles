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
        settings = {
            ['rust-analyzer'] = {
                cargo = {
                    allFeatures = true,
                },
                check = {
                    command = 'clippy',
                },
            },
        },
    },
}
