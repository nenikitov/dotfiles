---@module 'lazy'

---@type LazySpec
return {
	'kwkarlwang/bufresize.nvim',
    event = 'VeryLazy',
    opts = {
        register = { keys = {}, trigger_events = { 'WinResized' } },
        resize = { keys = {}, trigger_events = { 'VimResized' }, increment = false },
    },
}
