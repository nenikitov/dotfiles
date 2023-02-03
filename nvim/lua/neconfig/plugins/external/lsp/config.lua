--#region Helpers

-- LspConfig
local lspconfig_status, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_status then
    vim.notify('LSP not available', vim.log.levels.ERROR)
    return
end

-- Mason
local mason_status, mason = pcall(require, 'mason')
if not mason_status then
    vim.notify('Mason not available', vim.log.levels.ERROR)
    return
end

-- Mason and LSP config
local masonlspconfig_status, masonlspconfig = pcall(require, 'mason-lspconfig')
if not masonlspconfig_status then
    vim.notify('Mason-lspconfig not available', vim.log.levels.ERROR)
    return
end

-- Live function signature
local lsp_signature_status, lsp_signature = pcall(require, 'lsp_signature')

-- LSP progress
local figet_status, fidget = pcall(require, 'fidget')

-- Handlers
local handlers = require('neconfig.plugins.external.lsp.handlers')

local icons = require('neconfig.user.icons').diagnostics
local utils = require('neconfig.utils')

local servers = {
    'sumneko_lua',      -- Lua
    'html',             -- HTML
    'tsserver',         -- JavaScript and TypeScript
    'jsonls',           -- JSON
    'rust_analyzer',    -- Rust
}

--#endregion


--#region Mason

mason.setup {
    ui = {
        icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗'
        }
    }
}
masonlspconfig.setup {
    ensure_installed = servers
}

--#endregion


--#region Display

-- Signs
for type, icon in pairs(icons) do
    type = type == 'warning' and 'warn' or type
    local sign = 'DiagnosticSign' .. utils.convert_case(type, utils.cases.SNAKE, utils.cases.CAMEL)
    vim.fn.sign_define(
        sign,
        {
            text = icon,
            texthl = sign,
            numhl = sign
        }
    )
end

-- Other diagnostic options
vim.diagnostic.config {
    update_in_insert = true,
    severity_sort = true,
    float = {
        focusable = false,
        style  = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = ''
    },
    virtual_text = {
        prefix = '●'
    }
}

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


-- LSP borders
local lsp_style = {
    border = 'rounded',
    width = 64
}
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, lsp_style
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help, lsp_style
)

--#endregion


--#region Server settings

local default_options = {
    on_attach = handlers.on_attach,
    capabilities = handlers.capabilities(),
}
for _, server in ipairs(servers) do
    local options = default_options
    local custom_configuration_status, custom_configuration = pcall(require, 'neconfig.plugins.external.lsp.servers.' .. server)

    if custom_configuration_status then
        vim.notify(tostring(custom_configuration.settings.Lua.diagnostics.globals[1]))
        options = vim.tbl_deep_extend('keep', custom_configuration, options)
    end

    lspconfig[server].setup(options)
end

--#endregion


--#region Other plugins

if lsp_signature_status then
    lsp_signature.setup {
        handler_opts = {
            max_width = 64
        },
        hint_enable = false
    }
else
    vim.notify('LSP signature not available', vim.log.levels.WARN)
end

if figet_status then
    fidget.setup {
        text = {
            spinner = 'dots_snake',
        },
        widow = {
            border = 'rounded'
        }
    }
else
    vim.notify('Fidget not available', vim.log.levels.WARN)
end

--#endregion

