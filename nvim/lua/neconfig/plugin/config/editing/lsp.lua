local servers = {
    -- Lua
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false }
        }
    },
    -- HTML
    html = {},
    -- CSS
    cssls = {},
    cssmodules_ls = {},
    -- JavaScript and TypeScript
    tsserver = {},
    -- JSON
    jsonls = {},
    -- Rust
    rust_analyzer = {},
    -- Python
    pyright = {},
    -- YAML
    yamlls = {
        yaml = {
            keyOrdering = false
        }
    }
}


return {
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Auto installer
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        -- Sources for Neovim
        'folke/neodev.nvim',
    },
    config = function()
        local neodev = require('neodev')
        local mason = require('mason')
        local mason_lspconfig = require('mason-lspconfig')
        local lspconfig = require('lspconfig')

        -- Installer
        neodev.setup()
        mason.setup {
            ui = {
                border = 'rounded',
                icons = {
                    package_installed   = '●',
                    package_pending     = '',
                    package_uninstalled = '○'
                },
                keymaps = require('neconfig.user.keymaps').mason()
            }
        }
        mason_lspconfig.setup {
            ensure_installed = vim.tbl_keys(servers),
        }

        -- Configure
        local capabilities = require('cmp_nvim_lsp').default_capabilities(
            vim.lsp.protocol.make_client_capabilities()
        )
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true
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

        -- Virtual text and floating windows
        vim.diagnostic.config {
            update_in_insert = true,
            severity_sort = true,
            virtual_text = {
                prefix = require('neconfig.user.icons').virtual_text_prefix
            },
            float = {
                border = 'rounded',
                header = '',
                source = 'always'
            },
            signs = false
        }

        -- Show popup on hover
        --[[
        vim.api.nvim_create_autocmd('CursorHold', {
            callback = function()
                local cursor = vim.api.nvim_win_get_cursor(0)
                local diagnostics = vim.tbl_filter(
                    function(d) return cursor[2] >= d.col and cursor[2] < d.end_col end,
                    vim.diagnostic.get(0, { lnum = cursor[1] - 1 }) or {}
                )
                if #diagnostics ~= 0 then
                    vim.diagnostic.open_float(
                        nil,
                        {
                            focusable = false,
                            close_events = {
                                'BufLeave',
                                'CursorMoved',
                                'InsertEnter',
                                'FocusLost'
                            },
                            scope = 'cursor',
                        }
                    )
                else
                    -- TODO make it silent
                    vim.lsp.buf.hover()
                end
            end
        })
        ]]

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

        require('neconfig.user.keymaps').lsp_plugin()
    end
}
