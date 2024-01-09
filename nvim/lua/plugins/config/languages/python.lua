local language = require('utils.language')

language.mason {
    -- Lanugage server
    --'pylsp',
    'pyright',
    -- Formatter
    'black',
    'isort',
}
language.treesitter {
    'python',
    'pymanifest',
}
language.servers {
    pyright = {
        --plugins = {
        --    black = { enabled = true },
        --    isort = { enabled = true, profile = 'black' },
        --},
    },
}
language.formatters {
    python = { 'black', 'isort' },
}

return {}
