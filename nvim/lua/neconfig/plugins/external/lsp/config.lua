--#region Helpers

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

-- LSP config
local lspconfig = require('lspconfig')

-- Handlers
local handlers = require('neconfig.plugins.external.lsp.handlers')

local SERVERS = {
    'sumneko_lua'
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
    ensure_installed = SERVERS
}

--#endregion


--#region Display

-- Signs
local signs = {
    Error = "",
    Warn  = "",
    Hint  = "",
    Info  = ""
}
for type, icon in pairs(signs) do
    local sign = "DiagnosticSign" .. type
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
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = ''
    }
}

-- LSP borders
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, { border = 'rounded' }
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help, { border = 'rounded' }
)
--#endregion


--#region Server settings

local DEFAULT_OPTIONS = {
    on_attach = handlers.on_attach,
    capabilities = handlers.capabilities(),
}
for _, server in ipairs(SERVERS) do
    local options = DEFAULT_OPTIONS
    local custom_configuration_status, custom_configuration = pcall(require, 'neconfig.plugins.external.lsp.servers.' .. server)

    if custom_configuration_status then
        options = vim.tbl_deep_extend('keep', custom_configuration, options)
    end

    lspconfig[server].setup(options)
end

--#endregion

