--#region Helpers

--- Module return.
local M = {}

-- Shortcut to `vim.log.levels`
local l = vim.log.levels

--#endregion



--#region Log

--- Log a message as an info.
---@param message string Message to log.
function M.info(message)
    vim.notify(message, l.INFO)
end

--- Log a message as a warning.
---@param message string Message to log.
function M.warning(message)
    vim.notify(message, l.WARN)
end

--- Log a message as an error.
---@param message string Message to log.
function M.error(message)
    vim.notify(message, l.ERROR)
end

--#endregion



--#region Exports

return M

--#endregion
