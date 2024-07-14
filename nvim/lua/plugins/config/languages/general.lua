local language = require('utils.language')

return language.register {
    tools = {
        -- 'typos_lsp',
    },
    servers = {
        -- typos_lsp = {
        --     init_options = {
        --         diagnosticSeverity = 'hint',
        --     },
        -- },
    },
}
