local language = require('utils.language')

return language.register {
    parsers = {
        -- TODO(nenikitov): Re-enable once `before_core` actually loads before all core plugins
        -- 'hyprlang',
    },
    plugins = {
        before_core = {
            'luckasRanarison/tree-sitter-hyprlang',
        },
    },
}
