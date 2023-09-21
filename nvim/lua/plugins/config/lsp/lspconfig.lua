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

        -- Keymaps
        keymaps.diagnostics()
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(environment)
                keymaps.lsp(environment.buf)
            end
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
                end
            },
            float = {
                border = icons.border,
                header = '',
                source = true
            },
            signs = false,
        }

        -- Signs
        for type, icon in pairs {
            Error = icons.diagnostics.error,
            Warn = icons.diagnostics.warning,
            Hint = icons.diagnostics.hint,
            Info = icons.diagnostics.info
        } do
            local sign = 'DiagnosticSign' .. type
            vim.fn.sign_define(sign, { text = icon, texthl = sign, numhl = sign })
        end

        -- Only one sign in sign column
        local ns = vim.api.nvim_create_namespace('diagnostic_signs')
        local orig_signs_handler = vim.diagnostic.handlers.signs
        vim.diagnostic.handlers.signs = {
            show = function(_, bufnr, _, opts)
                local all_diagnostics = vim.diagnostic.get(bufnr)
                -- Get worst diagnostics
                local max_severity_per_line = {}
                for _, d in pairs(all_diagnostics) do
                    local m = max_severity_per_line[d.lnum]
                    if not m or d.severity < m.severity then
                        max_severity_per_line[d.lnum] = d
                    end
                end
                local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
                orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
            end,
            hide = function(_, bufnr)
                orig_signs_handler.hide(ns, bufnr)
            end,
        }
    end
}
