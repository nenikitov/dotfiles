local language = require('utils.language')

language.mason {
    -- Language server
    'bashls',
}
language.treesitter {
    'bash'
}
language.servers {
    bashls = {},
}

return {}
