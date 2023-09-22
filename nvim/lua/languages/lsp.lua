-- [Language names](https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers)
-- [Language settings](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
return function()
    local schemastore = require('schemastore')

    return {
        lua_ls = {
            Lua = {
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
            }
        },
        bashls = {},
        clangd = {},
        cssls = {},
        cssmodules_ls = {},
        eslint = {},
        html = {},
        jsonls = {
            json = {
                schemas = schemastore.json.schemas(),
                validate = { enable = true }
            }
        },
        tsserver = {},
        pylsp = {},
        rust_analyzer = {},
        taplo = {},
        yamlls = {
            yaml = {
                keyOrdering = false
            },
            schemaStore = {
                enable = false,
                url = '',
            },
            schemas = schemastore.yaml.schemas()
        },
        lemminx = {}
    }
end
