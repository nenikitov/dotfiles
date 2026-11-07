local shared = require('shared')

--#region Diagnostics
local icons = {
    [vim.diagnostic.severity.ERROR] = shared.icons.severity.error,
    [vim.diagnostic.severity.WARN] = shared.icons.severity.warning,
    [vim.diagnostic.severity.HINT] = shared.icons.severity.hint,
    [vim.diagnostic.severity.INFO] = shared.icons.severity.info,
}
local highlights = {
    [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
    [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
    [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
    [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
}
-- Signs only highlight the line number: empty text for every severity hides the glyphs
local signs = {
    [vim.diagnostic.severity.ERROR] = '',
    [vim.diagnostic.severity.WARN] = '',
    [vim.diagnostic.severity.HINT] = '',
    [vim.diagnostic.severity.INFO] = '',
}

vim.diagnostic.config({
    update_in_insert = true,
    severity_sort = true,
    signs = {
        text = signs,
        numhl = highlights,
    },
    virtual_text = {
        source = 'if_many',
        prefix = function(diagnostic)
            return icons[diagnostic.severity]
        end,
    },
    float = {
        source = true,
        header = '',
        prefix = function(diagnostic)
            return icons[diagnostic.severity] .. ' ', highlights[diagnostic.severity]
        end,
    },
})
--#endregion

--#region LSP
vim.lsp.inlay_hint.enable(false)
vim.lsp.codelens.enable(false)
--#endregion

--#region Keys
shared.keys.code:k('e', 'Show diagnostic'):bind('n', vim.diagnostic.open_float):set()
shared.keys.code:k('o', 'Show hover'):bind('n', function() vim.lsp.buf.hover() end):set()
shared.keys.code:k('O', 'Show signature'):bind('n', function() vim.lsp.buf.signature_help() end):set()
shared.keys.code:k('r', 'Show references'):bind('n', vim.lsp.buf.references):set()
shared.keys.code:k('i', 'Show implementations'):bind('n', vim.lsp.buf.implementation):set()
shared.keys.code:k('d', 'Show definition'):bind('n', vim.lsp.buf.definition):set()
shared.keys.code:k('D', 'Show declaration'):bind('n', vim.lsp.buf.declaration):set()
shared.keys.code:k('a', 'Run code actions'):bind({ 'n', 'x' }, vim.lsp.buf.code_action):set()
shared.keys.code:k('A', 'Run code lens'):bind('n', vim.lsp.codelens.run):set()
shared.keys.code:k('n', 'Rename'):bind('n', shared.plugins.handlers.rename_symbol:bind()):set()
shared.keys.code:k('f', 'Format'):bind({ 'n', 'x' }, shared.plugins.handlers.format_buffer:bind()):set()
shared.keys.code:k('v', 'Toggle inlay hints'):bind('n', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end):set()
shared.keys.code:k('V', 'Toggle code lens'):bind('n', function()
    vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())
end):set()
--#endregion
