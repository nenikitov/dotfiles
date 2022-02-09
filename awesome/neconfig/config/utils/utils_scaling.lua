-- Load modules
local dpi = require('beautiful.xresources').apply_dpi
-- Load custom modules
local user_scaling = require('neconfig.user.appearance.user_scaling')


-- Container for functions
local utils_scaling = {}

--- Initialize size values related to widget scale
---@param value number
---@return number
function utils_scaling.size(value)
    return dpi(value) * user_scaling.contents
end

--- Initialize size values related to spacing
---@param value number
---@return number
function utils_scaling.space(value)
    return dpi(value) * user_scaling.spacing
end

--- Initialize size values related to borders
---@param value number
---@return number
function utils_scaling.borders(value)
    return dpi(value) * user_scaling.borders * user_scaling.contents
end

--- Initialize size values related to corner radius
---@param value number
---@return number
function utils_scaling.radius(value)
    return dpi(value) * user_scaling.radius * user_scaling.contents
end

return utils_scaling
