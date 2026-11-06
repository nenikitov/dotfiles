---@module 'lazy'
---@module 'treesitter-context'

---@type LazySpec
return {
	'nvim-treesitter/nvim-treesitter-context',
    event = { 'LazyFile' },
    ---@type TSContext.UserConfig
    opts = {
        multiwindow = true
    },
}
