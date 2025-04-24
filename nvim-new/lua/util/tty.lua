local M = {}

function M.is_gui()
    return os.getenv('TERM') ~= 'linux'
end

function M.gui_choose(gui, tty)
    if vim.g.enable_tty_mode then
        return gui
    else
        return tty
    end
end

return M
