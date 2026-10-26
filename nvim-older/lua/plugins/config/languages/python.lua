local language = require('utils.language')

return language.register {
    tools = {
        -- Language server
        -- 'pylsp',
        'pyright',
        -- Formatter
        'black',
        'isort',
    },
    parsers = {
        'python',
        'pymanifest',
        'requirements',
    },
    servers = {
        pyright = {},
    },
    formatters = {
        python = { 'black', 'isort' },
    },
}
