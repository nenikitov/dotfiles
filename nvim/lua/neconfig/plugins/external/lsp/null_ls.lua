--#region Helpers

-- Null-ls
local null_ls_status, null_ls = pcall(require, "null-ls")
if not null_ls_status then
	vim.notify("Null-ls not available", vim.log.levels.ERROR)
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local completion = null_ls.builtins.completion

local sources = {
}

--#endregion

--#region

null_ls.setup({
	sources = sources
})

--#endregion

