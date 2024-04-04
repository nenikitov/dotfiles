local language = require('utils.language')

return language.register {
    tools = {
        -- Language server
        'yamlls',
    },
    parsers = {
        'yaml',
    },
    servers = {
        yamlls = {
            settings = {
                yaml = {
                    keyOrdering = false,
                },
            },
        },
    },
}
