local language = require('utils.language')

return language.register {
    tools = {
        'hyprls',
    },
    parsers = {
        'hyprlang',
    },
    servers = {
        hyprls = function()
            local lspconfig_util = require('lspconfig.util')
            return {
                filetypes = { 'hyprlang' },
                root_dir = lspconfig_util.root_pattern('hyprland.conf'),
            }
        end,
    },
    scripts = {
        before_core = function()
            vim.filetype.add {
                pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang' },
            }
        end,
    },
}
