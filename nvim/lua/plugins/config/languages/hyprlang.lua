local language = require('utils.language')

return language.register {
    parsers = {
        'hyprlang',
    },
    scripts = {
        before_core = function()
            vim.filetype.add {
                pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang' },
            }
        end,
    },
}
