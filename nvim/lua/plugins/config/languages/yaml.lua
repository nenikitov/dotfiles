local language = require('utils.language')

language.mason {
    -- Language server
    'yamlls',
}
language.treesitter {
    'yaml',
}
language.servers {
    yamlls = {
        yaml = {
            keyOrdering = false,
        },
    },
}

return {}
