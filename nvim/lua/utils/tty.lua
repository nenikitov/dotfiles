local M = {}

local term = os.getenv('TERM')

function M.is_gui()
    return term ~= 'linux'
end

--- Choose a value depending if the current instance is running in tty or gui.
---@generic T
---@param gui T
---@param tty T
---@return T
function M.choose(gui, tty)
    if M.is_gui() then
        return gui
    else
        return tty
    end
end

return M
