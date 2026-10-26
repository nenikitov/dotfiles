local util = require('util')
local defs = require('defs')

local M = {}

local self_module = 'config.indentexpr'

---@type string[]?
local disable_indent_cache

---@param language string
---@return boolean
local function use_treesitter(language)
	disable_indent_cache = disable_indent_cache or defs.lang.collect('treesitter').disable_indent or {}
	if vim.list_contains(disable_indent_cache, language) then
		return false
	end

	if not pcall(require, 'nvim-treesitter') then
		return false
	end

	local ok, query = pcall(vim.treesitter.query.get, language, 'indents')
	return ok and query ~= nil
end

---@param expr string
---@return string
local function unwrap(expr)
	local pattern = ("^v:lua%%.require'%s'%%.indentexpr%%('(.*)'%%)$"):format(vim.pesc(self_module))
	local inner = expr:match(pattern)
	if not inner then
		return expr
	end
	return (inner:gsub("''", "'"))
end

---@param language string
---@return string? expr
---@return string? filetype
local function builtin_language_expr(language)
	for _, filetype in ipairs(vim.treesitter.language.get_filetypes(language)) do
		local expr = vim.filetype.get_option(filetype, 'indentexpr')
		if type(expr) == 'string' then
			expr = unwrap(expr)
			if expr ~= '' then
				return expr, filetype
			end
		end
	end
	return nil
end

---@param filetype string
local function merge_indentkeys(filetype)
	local keys = vim.filetype.get_option(filetype, 'indentkeys')
	if type(keys) ~= 'string' or keys == '' then
		return
	end
	local current = vim.opt_local.indentkeys:get()
	for _, key in ipairs(vim.split(keys, ',', { plain = true })) do
		if not vim.list_contains(current, key) then
			vim.opt_local.indentkeys:append(key)
		end
	end
end

---@param expr string
---@return integer
local function evaluate(expr)
	if expr == '' then
		return -1
	end
	local ok, indent = pcall(vim.api.nvim_eval, expr)
	return ok and tonumber(indent) or -1
end

--- Uses treesitter indent if enabled, fallbacks onto Vims if not
--- Works with injected languages
---@param buffer_expr string
---@return integer
function M.indentexpr(buffer_expr)
	local line = vim.v.lnum - 1
	local ok, parser = pcall(vim.treesitter.get_parser, 0)
	if not ok or not parser then
		return evaluate(buffer_expr)
	end

	local column = #vim.fn.getline(vim.v.lnum):match('^%s*')
	local range = { line, column, line, column }

	parser:parse({ line, line + 1 })
	local tree = parser:language_for_range(range)
	local language = tree:lang()

	if language ~= parser:lang() then
		local filetype = vim.treesitter.language.get_filetypes(language)[1]
		if filetype then
			merge_indentkeys(filetype)
		end
	end

	if use_treesitter(language) then
		local syntax = tree:tree_for_range(range)
		if not (syntax and syntax:root():has_error()) then
			return require('nvim-treesitter').indentexpr()
		end
	end

	if language == parser:lang() then
		return evaluate(buffer_expr)
	end

	local expr, _ = builtin_language_expr(language)
	if not expr then
		return -1
	end
	return evaluate(expr)
end

vim.api.nvim_create_autocmd('FileType', {
	group = util.vim.augroup('context indent'),
	desc = 'Indent each line by the language that owns it, including injected languages',
	callback = function(event)
		local buf = event.buf
		local current = vim.bo[buf].indentexpr

		-- Don't reattach if we already ran FileType
		if current:find(("require'%s'"):format(self_module), 1, true) then
			return
		end

		local language = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
		if not language then
			return
		end

		local ok, parser = pcall(vim.treesitter.get_parser, buf, language)
		if not ok or not parser then
			return
		end

		local quoted = "'" .. current:gsub("'", "''") .. "'"
		vim.bo[buf].indentexpr = ("v:lua.require'%s'.indentexpr(%s)"):format(self_module, quoted)
	end,
})

return M
