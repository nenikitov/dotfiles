---@module 'lazy'
---@module 'gitsigns'

local util = require('util')
local defs = require('defs')

---@type LazySpec
return {
	'lewis6991/gitsigns.nvim',
    event = { 'LazyFile' },
    opts = {
        signs = {
            add = { text = defs.icons.diff_bar.added },
            change = { text = defs.icons.diff_bar.changed },
            changedelete = { text = defs.icons.diff_bar.changed },
            delete = { text = defs.icons.diff_bar.deleted },
            topdelete = { text = defs.icons.diff_bar.deleted },
            untracked = { text = defs.icons.diff_bar.untracked },
        },
        signs_staged = {
            add = { text = defs.icons.diff_bar.added },
            change = { text = defs.icons.diff_bar.changed },
            changedelete = { text = defs.icons.diff_bar.changed },
            delete = { text = defs.icons.diff_bar.deleted },
            topdelete = { text = defs.icons.diff_bar.deleted },
            untracked = { text = defs.icons.diff_bar.untracked },
        },
        word_diff = true,
        attach_to_untracked = true,
        on_attach = function(buf)
            local gitsigns = require('gitsigns')

            local root_prefix = util.map:buf(buf)
            local leader_prefix = defs.keys.git:buf(buf)

            root_prefix:k('[', 'previous'):k('g', 'Hunk'):bind('', function() gitsigns.nav_hunk('prev') end):set()
            root_prefix:k(']', 'next'):k('g', 'Hunk'):bind('', function() gitsigns.nav_hunk('next') end):set()
            root_prefix:k('i', 'inside'):k('h', 'Hunk'):bind({'o', 'x'}, gitsigns.select_hunk):set()

            leader_prefix:k('o', 'Preview diff of current hunk'):bind('n', gitsigns.preview_hunk):set()
            leader_prefix:k('b', 'Blame current line'):bind('n', gitsigns.blame_line):set()
            leader_prefix:k('s', 'Stage current hunk'):bind('n', gitsigns.stage_hunk):set()
            leader_prefix:k('s', 'Stage current hunk'):bind('v', function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end):set()
            leader_prefix:k('S', 'Stage entire file'):bind('n', gitsigns.stage_buffer):set()
            leader_prefix:k('r', 'Reset current hunk'):bind('n', gitsigns.reset_hunk):set()
            leader_prefix:k('r', 'Reset current hunk'):bind('v', function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end):set()
            leader_prefix:k('R', 'Reset entire file'):bind('n', gitsigns.reset_buffer):set()
        end
    },
}
