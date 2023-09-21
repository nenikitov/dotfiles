local keymaps = require('user.keymaps')
local icons = require('user.icons')
local languages = require('languages.lsp')

return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/cmp-nvim-lsp',
        'folke/neodev.nvim',
    },
    config = function()
        local mason_lspconfig = require('mason-lspconfig')
        local lspconfig = require('lspconfig')

        require('neodev').setup()

        mason_lspconfig.setup {
            ensure_installed = vim.tbl_keys(languages)
        }

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        mason_lspconfig.setup_handlers {
            function(server_name)
                local config = languages[server_name] or {}

                lspconfig[server_name].setup {
                    capabilities = capabilities,
                    settings = config,
                    filetypes = config.filetypes,
                    on_attach = config.on_attach,
                }
            end
        }

        keymaps.diagnostics()

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function (environment)
                --vim.
            end
        })
    end
}
