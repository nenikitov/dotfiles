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
function M.is_gui_choose(gui, tty)
    if M.is_gui() then
        return gui
    else
        return tty
    end
end

--- Copy some text to system clipboard
---@param text string
function M.copy(text)
    vim.fn.setreg('+', text)
end

return M
