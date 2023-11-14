local keymaps = require('user.keymaps')
local icons = require('user.icons')

return {
    'folke/todo-comments.nvim',
    --dir = '~/SharedFiles/Projects/nvim/todo-comments.nvim',
    enabled = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
    },
    opts = {
        keywords = {
            FIX = { icon = icons.todo.fix },
            TODO = { icon = icons.todo.todo },
            HACK = { icon = icons.todo.hack },
            WARN = { icon = icons.todo.warning },
            PERF = { icon = icons.todo.performance },
            NOTE = { icon = icons.todo.note },
            TEST = { icon = icons.todo.test },
        },
        highlight = {
            --keyword = 'fg',
            --after = '',
            --pattern = [[.*<(KEYWORDS)(\([^\)]*\))?:]],
        },
        search = {
            --pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]],
        },
    },
}
