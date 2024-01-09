local language = require('utils.language')

language.mason {
    'cssls',
    'cssmodules_ls',
}
language.treesitter {
    'css',
}
language.servers {
    cssls = {},
    cssmodules_ls = {},
}

return {}
