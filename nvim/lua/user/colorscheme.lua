local tty = require('utils.tty')
local log = require('utils.log')

local cmd = vim.cmd

local M = {}

--M.colorscheme = tty.choose('horizon', 'slate')
M.colorscheme = 'horizon'
M.colorscheme_fallback = 'slate'

function M.apply()
    ---@diagnostic disable-next-line: param-type-mismatch `cmd` is callable
    local colorscheme_status, _ = pcall(cmd, 'colorscheme ' .. M.colorscheme)
    if not colorscheme_status then
        log.warning('Color scheme ' .. M.colorscheme .. ' not available')
        cmd('colorscheme ' .. M.colorscheme_fallback)
        return
    end
end

return M
