---@module 'lazy'
---@module 'inc_rename'

local shared = require('shared')

---@type LazySpec
return {
    'smjonas/inc-rename.nvim',
    -- Loaded before the first rename, so the command has its live preview
    event = 'LspAttach',
    ---@return inc_rename.UserConfig
    opts = function()
        local handlers = shared.plugins.handlers
        handlers.rename_symbol:set('inc-rename', function()
            vim.api.nvim_feedkeys(':IncRename ' .. vim.fn.expand('<cword>'), 'n', false)
        end)

        return {}
    end,
}
