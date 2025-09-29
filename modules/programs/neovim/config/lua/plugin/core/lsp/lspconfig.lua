---@module 'lazy'

local icon = require("util.icon")
local language = require('util.language')

language.handler('servers', function (opts)
    return {
        'nvim-lspconfig',
        opts = {
            servers = opts
        }
    }
end)

language.set_lsp_plugin('nvim-lspconfig')

return {
    'neovim/nvim-lspconfig',
    event = 'LazyFile',
    dependencies = { 'mason-tool-installer.nvim' },
    opts = {
        -- Is extended by specs in `language`
        servers = {},
        ---@type vim.diagnostic.Opts
        diagnostics = {
            update_in_insert = true,
            severity_sort = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = icon.severity.error,
                    [vim.diagnostic.severity.WARN] = icon.severity.warning,
                    [vim.diagnostic.severity.HINT] = icon.severity.hint,
                    [vim.diagnostic.severity.INFO] = icon.severity.info,
                }
            },
            virtual_text = {
                source = 'if_many',
                prefix = '<SIGN>',
            },
            float = {
                source = true,
                prefix = '<SIGN>',
                header = '',
            },
        },
        inlay_hints = false,
        codelens = true,
        ---@type LazyKeysSpec[]
        keys = {
            -- Preifx
            { '<LEADER>c',  '<NOP>',                                             desc = 'code' },
            -- Diagnostic
            { '<LEADER>ce', vim.diagnostic.open_float,                           desc = 'Show diagnostic' },
            -- Lsp
            { '<LEADER>co', vim.lsp.buf.hover,                                   desc = 'Show hover' },
            { '<LEADER>cO', vim.lsp.buf.signature_help,                          desc = 'Show signature' },
            { '<LEADER>cr', vim.lsp.buf.references,                              desc = 'Show references' },
            { '<LEADER>ci', vim.lsp.buf.implementation,                          desc = 'Show implementations' },
            { '<LEADER>cd', vim.lsp.buf.definition,                              desc = 'Show definition' },
            { '<LEADER>cD', vim.lsp.buf.declaration,                             desc = 'Show declaration' },
            { '<LEADER>ca', vim.lsp.buf.code_action,                             mode = { 'n', 'x' },          desc = 'Run code actions' },
            { '<LEADER>cA', vim.lsp.codelens.run,                                mode = { 'n', 'x' },          desc = 'Run code lens' },
            { '<LEADER>cn', vim.lsp.buf.rename,                                  desc = 'Rename' },
            { '<LEADER>cf', function() vim.lsp.buf.format({ async = true }) end, mode = { 'n', 'x' },          desc = 'Format' },
        },
    },
    keys = {
        -- Preifx
        { '<LEADER>c',  '<NOP>',                                                                       desc = 'code' },
        -- Toggles
        { '<LEADER>cv', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, desc = 'Toggle inlay hint visibility' },
        {
            '<LEADER>cV',
            function()
                vim.g.code_lens = not vim.g.code_lens
                if not vim.g.code_lens then
                    vim.lsp.codelens.clear()
                end
            end,
            desc = 'Toggle code lens visibility'
        },
    },
    config = function(_, opts)
        for server, config in pairs(opts.servers) do
            if type(config) == 'function' then
                config = config()
            end
            if config == true then
                config = {}
            end
            if config == false then
                goto continue
            end

            vim.lsp.enable(server)
            vim.lsp.config(server, config)

            ::continue::
        end

        local function on_diagnostic(severity, error, warning, hint, info)
            return ({
                [vim.diagnostic.severity.ERROR] = error,
                [vim.diagnostic.severity.WARN] = warning,
                [vim.diagnostic.severity.HINT] = hint,
                [vim.diagnostic.severity.INFO] = info,
            })[severity]
        end

        if type(opts.diagnostics.virtual_text) == 'table' and opts.diagnostics.virtual_text.prefix == '<SIGN>' then
            opts.diagnostics.virtual_text.prefix = function(d)
                return on_diagnostic(
                    d.severity,
                    icon.severity.error,
                    icon.severity.warning,
                    icon.severity.hint,
                    icon.severity.info
                )
            end
        end
        if type(opts.diagnostics.float) == 'table' and opts.diagnostics.float.prefix == '<SIGN>' then
            opts.diagnostics.float.prefix = function(d)
                return unpack(on_diagnostic(
                    d.severity,
                    { icon.severity.error, 'DiagnosticSignError' },
                    { icon.severity.warning, 'DiagnosticSignWarn' },
                    { icon.severity.hint, 'DiagnosticSignHint' },
                    { icon.severity.info, 'DiagnosticSignInfo' }
                ))
            end
        end
        vim.diagnostic.config(opts.diagnostics)

        if opts.inlay_hints then
            vim.lsp.inlay_hint.enable()
        end

        vim.g.code_lens = opts.codelens
        vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
            callback = function()
                if vim.g.code_lens then
                    vim.lsp.codelens.refresh()
                end
            end
        })

        local group = vim.api.nvim_create_augroup('lsp keys', { clear = true })
        vim.api.nvim_create_autocmd('LspAttach', {
            group = group,
            callback = function(event)
                local Keys = require('lazy.core.handler.keys')
                local keymaps = Keys.resolve(opts.keys)
                for _, keymap in pairs(keymaps) do
                    local key_opts = Keys.opts(keymap)
                    vim.keymap.set(keymap.mode or 'n', keymap.lhs, keymap.rhs,
                        vim.tbl_extend('force', key_opts, { buffer = event.buf }))
                end
            end
        })
        vim.api.nvim_create_autocmd('LspDetach', {
            group = group,
            callback = function(event)
                vim.api.nvim_clear_autocmds({ group = 'lsp keys', bufnr = event.buf })
            end
        })
    end,
}
