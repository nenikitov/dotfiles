local language = require('utils.language')

return language.register {
    tools = {
        'nil'
    },
    parsers = {
        'nix'
    },
    servers = {
        ['nil'] = {}
    },
    formatters = {
        nix = { 'alejandra' }
    }
}
