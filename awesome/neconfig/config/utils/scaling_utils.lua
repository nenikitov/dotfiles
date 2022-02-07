-- Load modules
local dpi = require('beautiful.xresources').apply_dpi
-- Load custom modules
local user_scaling = require('neconfig.user.appearance.user_scaling')


-- Container for functions
local scaling_utils = {}

--- Initialize size values related to widget scale
---@param value number
---@return number
function scaling_utils.size(value)
    return dpi(value) * user_scaling.contents
end

--- Initialize size values related to spacing
---@param value number
---@return number
function scaling_utils.space(value)
    return dpi(value) * user_scaling.spacing
end

--- Initialize size values related to borders
---@param value number
---@return number
function scaling_utils.borders(value)
    return dpi(value) * user_scaling.borders * user_scaling.contents
end

--- Initialize size values related to corner radius
---@param value number
---@return number
function scaling_utils.radius(value)
    return dpi(value) * user_scaling.rounding * user_scaling.contents
end

return scaling_utils
