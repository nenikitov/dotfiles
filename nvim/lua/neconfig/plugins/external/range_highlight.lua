--#region Helpers

-- Range highlight
local range_highlight_status, range_highlight = pcall(require, 'range-highlight')
if not range_highlight_status then
    vim.notify('Range highlight not available', vim.log.levels.ERROR)
    return
end

--#endregion

--#region Range highlight

range_highlight.setup()

--#endregion

