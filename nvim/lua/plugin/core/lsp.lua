---@module 'lazy'

local defs = require('defs')

local signs = {
	[vim.diagnostic.severity.ERROR] = defs.icons.severity.error,
	[vim.diagnostic.severity.WARN] = defs.icons.severity.warn,
	[vim.diagnostic.severity.HINT] = defs.icons.severity.hint,
	[vim.diagnostic.severity.INFO] = defs.icons.severity.info,
}
local highlights = {
	[vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
	[vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
	[vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
	[vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
}

---@type LazySpec
return {
    'neovim/nvim-lspconfig',
    dependencies = {
        defs.plugins.mason,
    },
    event = 'LazyFile',
    keys = {
        defs.keys.code:k('e', 'Show diagnostic'):bind('n', vim.diagnostic.open_float):spec(),
        defs.keys.code:k('o', 'Show hover'):bind('n', vim.lsp.buf.hover):spec(),
        defs.keys.code:k('O', 'Show signature'):bind('n', vim.lsp.buf.signature_help):spec(),
        defs.keys.code:k('r', 'Show references'):bind('n', vim.lsp.buf.references):spec(),
        defs.keys.code:k('i', 'Show implementations'):bind('n', vim.lsp.buf.implementation):spec(),
        defs.keys.code:k('d', 'Show definition'):bind('n', vim.lsp.buf.definition):spec(),
        defs.keys.code:k('D', 'Show declaration'):bind('n', vim.lsp.buf.declaration):spec(),
        defs.keys.code:k('a', 'Run code actions'):bind({ 'n', 'x' }, vim.lsp.buf.code_action):spec(),
        defs.keys.code:k('A', 'Run code lens'):bind('n', vim.lsp.codelens.run):spec(),
        defs.keys.code:k('n', 'Rename'):bind('n', vim.lsp.buf.rename):spec(),
        defs.keys.code:k('v', 'Toggle inlay hints'):bind('n', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end):spec(),
        defs.keys.code:k('V', 'Toggle code lens'):bind('n', function()
            vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())
        end):spec(),
    },
    opts = {
		---@type vim.diagnostic.Opts
		diagnostics = {
			update_in_insert = true,
			severity_sort = true,
			signs = { text = signs },
			virtual_text = {
				source = 'if_many',
				prefix = function(diagnostic)
					return signs[diagnostic.severity]
				end,
			},
			float = {
				source = true,
				header = '',
				prefix = function(diagnostic)
					return signs[diagnostic.severity] .. ' ', highlights[diagnostic.severity]
				end,
			},
		},
		inlay_hints = false,
		codelens = false,
    },
    config = function(_, opts)
        -- Load servers
        for name, server in pairs(defs.lang.collect('servers')) do
            if type(server) == 'function' then
                server = server()
            end
            if server == false then
                goto continue
            end
            if server == true then
                server = {}
            end

            vim.lsp.config(name, server)
            vim.lsp.enable(name)

            ::continue::
        end

        -- Options
        vim.diagnostic.config(opts.diagnostics)
        vim.lsp.inlay_hint.enable(opts.inlay_hints)
        vim.lsp.codelens.enable(opts.codelens)
    end
}
