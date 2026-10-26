local icon = require('util.icon')
local map = require('util.map')

local signs = {
    add = { text = icon.diff_bar.added },
    change = { text = icon.diff_bar.changed },
    delete = { text = icon.diff_bar.deleted },
    topdelete = { text = icon.diff_bar.deleted },
    changedelete = { text = icon.diff_bar.changed },
    untracked = { text = icon.diff_bar.untracked },
}

return {
    'lewis6991/gitsigns.nvim',
    opts = {
        signs = signs,
        signs_staged = signs,
        on_attach = function(buf)
            local gitsigns = require('gitsigns')
            local opts = { bufffer = buf }

            -- Prefix
            map('n', '<LEADER>v', '<NOP>', 'version control')
            -- Navigation
            map('', '[H', function() gitsigns.nav_hunk('prev') end, 'Previous hunk')
            map('', ']H', function() gitsigns.nav_hunk('next') end, 'Next hunk')
            map({'o','x'}, 'iH', gitsigns.select_hunk, 'Hunk')
            -- Manipulation
            map('n', '<LEADER>vd', gitsigns.preview_hunk, 'Preview differences in current hunk')
            map('n', '<LEADER>vb', gitsigns.blame_line, 'Blame on current line')
            map('n', '<LEADER>vs', gitsigns.stage_hunk, 'Stage hunk')
            map('v', '<leader>vs', function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Stage hunk')
            map('n', '<LEADER>vr', gitsigns.reset_hunk, 'Reset hunk')
            map('v', '<leader>vr', function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Reset hunk')
            map('n', '<LEADER>vS', gitsigns.stage_buffer, 'Stage buffer')
            map('n', '<LEADER>vR', gitsigns.reset_buffer, 'Reset buffer')
        end
    },
    event = 'VeryLazy',
}
