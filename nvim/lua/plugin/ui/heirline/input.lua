local defs = require('defs')
local basic = require('plugin.ui.heirline.basic')

local M = {}

---@type ne.util.vim.AutocmdEvent[]
M.events = {
    'ModeChanged',
    'RecordingEnter',
    'RecordingLeave',
}

local mode_keys = {
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
}

---@return string
local function current_mode()
    return mode_keys[vim.fn.mode(1)] or 'normal'
end

---@class ne.plugin.heirline.input.Context : ne.plugin.heirline.basic.Component
---@field mode string

M.context = basic.context(
    ---@param self ne.plugin.heirline.input.Context
    function(self)
        self.mode = current_mode()
    end
)

---@class ne.plugin.heirline.input.ModeProps
---@field icon? boolean
---@field text? boolean

---@param props? ne.plugin.heirline.input.ModeProps
---@return ne.plugin.heirline.basic.Component
function M.mode(props)
    props = vim.tbl_extend('force', { icon = true, text = true }, props or {})

    ---@class ne.plugin.heirline.input.Mode : ne.plugin.heirline.input.Context

    local component = basic.joined(' ', {
        --- Icon
        condition = function()
            return props.icon and basic.icon(defs.icons.mode.icon[current_mode()]) ~= ''
        end,
        ---@param self ne.plugin.heirline.input.Mode
        provider = function(self)
            return basic.icon(defs.icons.mode.icon[self.mode])
        end,
    }, {
        --- Text
        condition = function()
            return props.text
        end,
        ---@param self ne.plugin.heirline.input.Mode
        provider = function(self)
            return defs.icons.mode.name[self.mode]
        end,
    })

    return M.context(component)
end

---@return ne.plugin.heirline.basic.Component
function M.selection()
    ---@class ne.plugin.heirline.input.Selection : ne.plugin.heirline.input.Context
    local component = {}

    function component:condition()
        local mode = current_mode()
        return mode == 'visual' or mode == 'visual_line' or mode == 'visual_block'
    end

    function component:provider()
        local lines = math.abs(vim.fn.line('.') - vim.fn.line('v')) + 1

        if self.mode == 'visual_block' then
            local columns = math.abs(vim.fn.virtcol('.') - vim.fn.virtcol('v')) + 1
            return lines .. 'x' .. columns
        elseif self.mode == 'visual_line' or lines > 1 then
            return tostring(lines)
        else
            return tostring(math.abs(vim.fn.charcol('.') - vim.fn.charcol('v')) + 1)
        end
    end

    return M.context(component)
end

---@class ne.plugin.heirline.input.RecordingProps
---@field icon? boolean

---@param props? ne.plugin.heirline.input.RecordingProps
---@return ne.plugin.heirline.basic.Component
function M.recording(props)
    props = vim.tbl_extend('force', { icon = true }, props or {})

    local function recording()
        return vim.fn.reg_recording() ~= ''
    end

    return basic.joined(' ', {
        --- Icon
        condition = function()
            return props.icon and recording()
        end,
        provider = basic.icon(defs.icons.mode.recording),
    }, {
        --- Register
        condition = recording,
        provider = function()
            return vim.fn.reg_recording()
        end,
    })
end

return M
