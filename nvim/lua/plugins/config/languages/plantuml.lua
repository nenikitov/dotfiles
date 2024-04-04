local language = require('utils.language')

return language.register {
    plugins = {
        before_core = {
            'aklt/plantuml-syntax',
        },
    },
}
