return {
    'kwkarlwang/bufresize.nvim',
    opts = {
        register = {
            keys = {},
            trigger_events =  { 'BufWinEnter', 'WinEnter', 'WinResized' },
        },
        resize = {
            trigger_events = { 'VimResized' }
        }
    },
    event = 'VeryLazy'
}
