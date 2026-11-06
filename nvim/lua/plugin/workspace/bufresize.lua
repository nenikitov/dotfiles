---@module 'lazy'

---@type LazySpec
return {
	'kwkarlwang/bufresize.nvim',
    event = 'UIEnter',
    opts = {
        register = { keys = {}, trigger_events = { 'WinResized' } },
        resize = { keys = {}, trigger_events = { 'VimResized' }, increment = false },
    },
}
