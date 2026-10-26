local language = require('utils.language')

return language.register {
    tools = {
        -- Language servers
        'cssls',
        'cssmodules_ls',
    },
    parsers = {
        'css',
    },
    servers = {
        cssls = {},
        cssmodules_ls = {},
    },
}
