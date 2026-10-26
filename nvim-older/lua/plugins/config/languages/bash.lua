local language = require('utils.language')

return language.register {
    tools = {
        -- Language servers
        'bashls',
    },
    parsers = {
        'bash',
    },
    servers = {
        bashls = {},
    },
}
