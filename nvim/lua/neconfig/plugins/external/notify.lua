--#region Helpers

-- Notify
local notify_status, notify = pcall(require, 'notify')
if not notify_status then
    vim.notify('Notify not available', vim.log.levels.ERROR)
    return
end

--#endregion


--#region Notify

notify.setup {
    stages = 'slide',
    timeout = 2000,
    top_down = false
}

-- Replace default vim notify function with custom one
vim.notify = notify

--#endregion

