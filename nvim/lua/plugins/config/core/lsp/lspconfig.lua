local keymaps = require('user.keymaps')
local icons = require('user.icons')
local language = require('utils.language')

return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/cmp-nvim-lsp',
        'folke/neoconf.nvim',
        -- TODO(nenikitov): This is before LSP, make this before everything in core
        language.plugins_before_core(),
    },
    config = function(_, opts)
        -- TODO(nenikitov): This is before LSP, make this before everything in core
        for _, f in ipairs(language.scripts_before_core()) do
            f()
        end

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
                if type(config) == 'function' then
                    config = config()
                end
                if type(config.capabilities) == 'function' then
                    config.capabilities =
                        config.capabilities(vim.tbl_deep_extend('force', capabilities, {}))
                end

                lspconfig[server_name].setup(config)
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
                source = 'if_many',
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
                source = true,
                prefix = function(diagnostic)
                    local icon = ({
                        [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
                        [vim.diagnostic.severity.WARN] = icons.diagnostics.warning,
                        [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
                        [vim.diagnostic.severity.INFO] = icons.diagnostics.info,
                    })[diagnostic.severity] .. '  '
                    local highlight = 'DiagnosticSign'
                        .. ({
                            [vim.diagnostic.severity.ERROR] = 'Error',
                            [vim.diagnostic.severity.WARN] = 'Warn',
                            [vim.diagnostic.severity.HINT] = 'Hint',
                            [vim.diagnostic.severity.INFO] = 'Info',
                        })[diagnostic.severity]

                    return icon, highlight
                end,
            },
            signs = true,
        }

        -- Borders
        require('lspconfig.ui.windows').default_options.border = icons.border
        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = icons.border,
        })

        vim.lsp.handlers['textDocument/signatureHelp'] =
            vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = icons.border,
            })

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

        -- TODO(nenikitov): This is after LSP, make this after everything in core
        for _, f in ipairs(language.scripts_after_core()) do
            f()
        end
    end,
    opts = {
        servers = language.servers(),
    },
}
