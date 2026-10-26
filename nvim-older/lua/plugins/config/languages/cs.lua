local language = require('utils.language')

return language.register {
    tools = {
        -- Language servers
        'omnisharp',
        -- Formatters
        'csharpier',
    },
    parsers = {
        'c_sharp',
    },
    servers = {
        omnisharp = {
            cmd = { 'omnisharp' },
        },
    },
    formatters = {
        cs = { 'csharpier' },
    },
}
