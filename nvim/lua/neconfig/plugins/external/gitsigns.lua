--#region Helpers

-- Gitsigns
local gitsigns_status, gitsigns = pcall(require, 'gitsigns')
if not gitsigns_status then
    vim.notify('Gitsigns not available', vim.log.levels.ERROR)
    return
end

--#endregion


--#region Gitsigns

gitsigns.setup {
    signs = {
        add = {
            text = '┃'
        },
        change = {
            text = '┃'
        },
        delete = {
            text = '▶'
        },
        topdelete = {
            text = '▶'
        },
        changedelete = {
            text = '▶'
        },
        untracked = {
            text = '┋'
        },
    }
}

require('neconfig.user.keymaps').gitsigns(gitsigns)

--#endregion

