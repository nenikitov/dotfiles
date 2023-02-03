--#region Helpers

-- Scrollbar
local scrollbar_status, scrollbar = pcall(require, 'scrollbar')
if not scrollbar_status then
    vim.notify('Scrollbar not available', vim.log.levels.ERROR)
    return
end

local scrollbar_git_status, scrollbar_git = pcall(require, 'scrollbar.handlers.gitsigns')
if not scrollbar_git_status then
    vim.notify('Scrollbar git not available', vim.log.levels.WARN)
end

local icons = require('neconfig.user.icons').diagnostics

--#endregion


--#region Gitsigns

scrollbar.setup {
    marks = {
        Cursor = {
            text = 'I'
        }
    }
}

if scrollbar_git_status then
    scrollbar_git.setup()
end

--#endregion

