--#region Helpers

-- Indent blankline
local blankline_status, blankline = pcall(require, 'indent_blankline')
if not blankline_status then
    vim.notify('Indent blankline not available', vim.log.levels.ERROR)
    return
end

--#endregion

--#region Indent lines and scope

blankline.setup {
    show_current_context = true,
}

--#endregion

