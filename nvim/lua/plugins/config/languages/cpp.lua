local language = require('utils.language')

return language.register {
    tools = {
        -- Language servers
        'clangd',
    },
    parsers = {
        'c',
        'cpp',
        'printf',
    },
    servers = {
        clangd = {},
    },
}
