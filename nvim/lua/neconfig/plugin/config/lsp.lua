local servers = {
    -- Lua
    lua_ls = {
        Lua = {
            workspace = { checkThridParty = false },
            telemetry = { enable = false }
        }
    },
    -- HTML
    html = {},
    -- CSS
    cssls = {},
    -- JavaScript and TypeScript
    tsserver = {},
    -- JSON
    jsonls = {},
    -- Rust
    rust_analyzer = {},
    -- Python
    pyright = {}
}


return {
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Auto installer
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        -- Auto configuration
        'folke/neodev.nvim',
        -- Progress
        'j-hui/fidget.nvim'
    },
    config = function()
        local neodev = require('neodev')
        local mason = require('mason')
        local mason_lspconfig = require('mason-lspconfig')
        local lspconfig = require('lspconfig')

        local capabilities = require('cmp_nvim_lsp').default_capabilities(
            vim.lsp.protocol.make_client_capabilities()
        )

        neodev.setup()
        mason.setup()
        mason_lspconfig.setup {
            ensure_installed = vim.tbl_keys(servers)
        }
        mason_lspconfig.setup_handlers {
            function(server_name)
                lspconfig[server_name].setup {
                    capabilities = capabilities,
                    on_attach = function()
                        require('neconfig.user.keymaps').lsp()
                    end,
                    settings = servers[server_name]
                }
            end
        }
    end
}
