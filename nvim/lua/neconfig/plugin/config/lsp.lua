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
    },
    config = function()
        local neodev = require('neodev')
        local mason = require('mason')
        local mason_lspconfig = require('mason-lspconfig')
        local lspconfig = require('lspconfig')

        -- Installer
        neodev.setup()
        mason.setup()
        mason_lspconfig.setup {
            ensure_installed = vim.tbl_keys(servers)
        }

        -- Configure
        local capabilities = require('cmp_nvim_lsp').default_capabilities(
            vim.lsp.protocol.make_client_capabilities()
        )
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

        -- Virtual text and floating windows
        vim.diagnostic.config {
            update_in_insert = true,
            severity_sort = true,
            virtual_text = {
                prefix = require('neconfig.user.icons').virtual_text_prefix
            },
            float = {
                header = '',
            },
            signs = false
        }

        -- Signs
        for type, icon in pairs(require('neconfig.user.icons').diagnostics) do
            local case = require('neconfig.utils.case')
            type = type == 'warning' and 'warn' or type
            local sign = 'DiagnosticSign' .. case.convert_case(type, case.cases.SNAKE, case.cases.CAMEL)
            vim.fn.sign_define(
                sign,
                {
                    text = icon,
                    texthl = sign,
                    numhl = sign
                }
            )
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
            end
        }
    end
}
