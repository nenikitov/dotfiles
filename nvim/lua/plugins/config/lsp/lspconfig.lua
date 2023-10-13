local keymaps = require('user.keymaps')
local icons = require('user.icons')

return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/cmp-nvim-lsp',
        'folke/neodev.nvim',
    },
    config = function(_, opts)
        vim.notify('lspconfig')
        local mason_lspconfig = require('mason-lspconfig')
        local lspconfig = require('lspconfig')

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        mason_lspconfig.setup_handlers {
            function(server_name)
                local config = opts.servers[server_name] or {}
                lspconfig[server_name].setup {
                    capabilities = capabilities,
                    settings = config,
                    filetypes = config.filetypes,
                    on_attach = config.on_attach,
                }
            end,
        }

        -- Keymaps
        keymaps.diagnostics()
        keymaps.lsp_open()
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(environment)
                keymaps.lsp(environment.buf)
            end,
        })

        -- Configure
        vim.diagnostic.config {
            update_in_insert = true,
            severity_sort = true,
            virtual_text = {
                prefix = function(diagnostic)
                    return ({
                        [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
                        [vim.diagnostic.severity.WARN] = icons.diagnostics.warning,
                        [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
                        [vim.diagnostic.severity.INFO] = icons.diagnostics.info,
                    })[diagnostic.severity] .. ' '
                end,
            },
            float = {
                border = icons.border,
                header = '',
                source = 'if_many',
                prefix = function(diagnostic)
                    return ({
                        [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
                        [vim.diagnostic.severity.WARN] = icons.diagnostics.warning,
                        [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
                        [vim.diagnostic.severity.INFO] = icons.diagnostics.info,
                    })[diagnostic.severity] .. '  '
                end,
            },
            --signs = false,
            signs = true,
        }

        -- Borders
        require('lspconfig.ui.windows').default_options.border = icons.border

        -- Signs
        for type, icon in pairs {
            Error = icons.diagnostics.error,
            Warn = icons.diagnostics.warning,
            Hint = icons.diagnostics.hint,
            Info = icons.diagnostics.info,
        } do
            local sign = 'DiagnosticSign' .. type
            vim.fn.sign_define(sign, { text = icon, texthl = sign, numhl = sign })
        end
    end,
    opts = function()
        return {
            servers = {},
        }
    end,
}
