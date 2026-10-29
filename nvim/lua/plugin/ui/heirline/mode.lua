local defs = require('defs')

local M = {}

---@class ne.plugin.heirline.mode.Block : ne.plugin.heirline.Component
---@field icons table<string, string>
---@field names table<string, string>
---@field keys table<string, string>
---@field mode string
M.Block = {
    static = {
        icons = defs.icons.mode.icon,
        names = defs.icons.mode.name,
        keys = {
            ['n']     = 'normal',
            ['no']    = 'operator_pending',
            ['nov']   = 'operator_pending',
            ['noV']   = 'operator_pending',
            ['no\22'] = 'operator_pending',
            ['niI']   = 'normal',
            ['niR']   = 'normal',
            ['niV']   = 'normal',
            ['nt']    = 'normal',
            ['ntT']   = 'normal',
            ['v']     = 'visual',
            ['vs']    = 'visual',
            ['V']     = 'visual_line',
            ['Vs']    = 'visual_line',
            ['\22']   = 'visual_block',
            ['\22s']  = 'visual_block',
            ['s']     = 'select',
            ['S']     = 'select_line',
            ['\19']   = 'select_block',
            ['i']     = 'insert',
            ['ic']    = 'insert',
            ['ix']    = 'insert',
            ['R']     = 'replace',
            ['Rc']    = 'replace',
            ['Rx']    = 'replace',
            ['Rv']    = 'visual_replace',
            ['Rvc']   = 'visual_replace',
            ['Rvx']   = 'visual_replace',
            ['c']     = 'command',
            ['cr']    = 'command',
            ['cv']    = 'ex',
            ['cvr']   = 'ex',
            ['r']     = 'more',
            ['rm']    = 'more',
            ['r?']    = 'confirm',
            ['!']     = 'shell',
            ['t']     = 'terminal',
        },
    },
    update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function() vim.cmd.redrawstatus() end)
    }
}

function M.Block:init()
    self.mode = self.keys[vim.fn.mode(1)] or 'normal'
end

function M.Block:provider()
    return '%(' .. self.icons[self.mode] ..  self.names[self.mode] .. '%)'
end

return M
