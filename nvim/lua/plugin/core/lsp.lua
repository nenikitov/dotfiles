---@module 'lazy'

local defs = require('defs')

local icons = {
	[vim.diagnostic.severity.ERROR] = defs.icons.severity.error,
	[vim.diagnostic.severity.WARN] = defs.icons.severity.warning,
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
            signs = false,
            numhl = true,
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

        -- Handlers
        vim.diagnostic.handlers.numhl = {
            show = function(namespace, bufnr, diagnostics)
                if not vim.api.nvim_buf_is_valid(bufnr) then
                    return
                end

                local ns = vim.diagnostic.get_namespace(namespace)
                ns.user_data.numhl_ns = ns.user_data.numhl_ns or vim.api.nvim_create_namespace('')
                vim.api.nvim_buf_clear_namespace(bufnr, ns.user_data.numhl_ns, 0, -1)

                local line_count = vim.api.nvim_buf_line_count(bufnr)
                for _, diagnostic in ipairs(diagnostics) do
                    if diagnostic.lnum < line_count then
                        vim.api.nvim_buf_set_extmark(bufnr, ns.user_data.numhl_ns, diagnostic.lnum, 0, {
                            number_hl_group = highlights[diagnostic.severity],
                            priority = 100 - diagnostic.severity,
                        })
                    end
                end
            end,
            hide = function(namespace, bufnr)
                if not vim.api.nvim_buf_is_valid(bufnr) then
                    return
                end

                local ns = vim.diagnostic.get_namespace(namespace)
                if ns.user_data.numhl_ns then
                    vim.api.nvim_buf_clear_namespace(bufnr, ns.user_data.numhl_ns, 0, -1)
                end
            end,
        }

        -- Options
        vim.diagnostic.config(opts.diagnostics)
        vim.lsp.inlay_hint.enable(opts.inlay_hints)
        vim.lsp.codelens.enable(opts.codelens)
    end
}
