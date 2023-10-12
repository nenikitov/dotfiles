local M = {}

-- jfldsjfldj
local term = os.getenv('TERM')

function M.is_gui()
    return term ~= 'linux'
end

function M.choose(gui, tty)
    if M.is_gui() then
        return gui
    else
        return tty
    end
end

return M
