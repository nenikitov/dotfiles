local lspconfig_status, _ = pcall(require, 'lspconfig')
if not lspconfig_status then
    vim.notify('LSP not available', vim.log.levels.ERROR)
    return
end

require('neconfig.plugins.external.lsp.config')

