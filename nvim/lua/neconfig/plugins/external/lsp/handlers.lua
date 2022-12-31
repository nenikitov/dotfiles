--#region Helpers

-- LSP config
local lspconfig_status, _ = pcall(require, 'lspconfig')
if not lspconfig_status then
    vim.notify('LSP not available', vim.log.levels.ERROR)
    return
end

-- LSP config
local cmp_lsp_status, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
-- Luasnip
local luasnip_status, luasnip = pcall(require, 'luasnip')

-- Container
local H = {}

--#endregion


function H.on_attach(client, _)
    require('neconfig.user.keymaps').lsp()
end

function H.capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if cmp_lsp_status then
        capabilities = cmp_lsp.default_capabilities(capabilities)
    else
        vim.notify('CMP LSP not available', vim.log.levels.WARN)
    end

    if luasnip_status then
        capabilities.textDocument.completion.completionItem.snippetSupport = true
    else
        vim.notify('LuaSnip not available', vim.log.levels.WARN)
    end
    return capabilities
end

return H

