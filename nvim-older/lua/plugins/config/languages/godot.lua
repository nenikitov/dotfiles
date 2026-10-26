local language = require('utils.language')

return language.register {
    tools = {
        -- Language servers, linters, formatters
        'gdtoolkit',
    },
    parsers = {
        'gdscript',
        'gdshader',
        'godot_resource',
    },
    servers = {
        gdscript = {},
        gdshader_lsp = {},
    },
    linters = {
        gd = { 'gdlint' },
        gdscript = { 'gdlint' },
    },
    formatters = {
        gd = { 'gdformat' },
        gdscript = { 'gdformat' },
    },
}
