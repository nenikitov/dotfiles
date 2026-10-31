---@module 'plugin.ui.heirline.modules.basic'

local M = {}

---@type ne.util.vim.AutocmdEvent[]
M.events = {}

---@param code string
---@param width integer
---@param left? boolean
---@return string
local function item(code, width, left)
    if width <= 0 then
        return '%' .. code
    end
    return '%' .. (left and '-' or '') .. width .. code
end

---@class ne.plugin.heirline.modules.cursor.LocationProps
---@field line_width? integer
---@field column_width? integer

---@param props? ne.plugin.heirline.modules.cursor.LocationProps
---@return ne.plugin.heirline.modules.basic.Component
function M.location(props)
    props = vim.tbl_extend('force', { line_width = 4, column_width = 3 }, props or {})

    ---@type ne.plugin.heirline.modules.basic.Component
    local component = {
        provider = item('l', props.line_width) .. ':' .. item('v', props.column_width, true),
    }

    return component
end

---@class ne.plugin.heirline.modules.cursor.ScrollProps
---@field width? integer

---@param props? ne.plugin.heirline.modules.cursor.ScrollProps
---@return ne.plugin.heirline.modules.basic.Component
function M.scroll(props)
    props = vim.tbl_extend('force', { width = 3 }, props or {})

    ---@type ne.plugin.heirline.modules.basic.Component
    local component = {
        provider = item('P', props.width),
    }

    return component
end

return M
