local language = require('utils.language')

language.mason {
    'pylsp',
}
language.treesitter {
    'python',
    'pymanifest',
}
language.servers {
    pylsp = {},
}

return {}
