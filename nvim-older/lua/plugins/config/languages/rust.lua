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
        rust_analyzer = {
            settings = {
                ['rust-analyzer'] = {
                    check = {
                        command = 'clippy'
                    },
                    cargo = {
                        features = 'all',
                    },
                },
            },
        }
    },
}
