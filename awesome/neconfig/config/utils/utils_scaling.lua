-- Load libraries
local dpi = require('beautiful.xresources').apply_dpi
-- Load custom modules
local user_look_scaling = require('neconfig.user.look.user_look_scaling')


-- Container for functions
local utils_scaling = {}

--- Initialize size values related to widget scale
---@param value number
---@return number
function utils_scaling.size(value)
    return dpi(value) * user_look_scaling.contents
end

--- Initialize size values related to spacing
---@param value number
---@return number
function utils_scaling.space(value)
    return dpi(value) * user_look_scaling.spacing
end

--- Initialize size values related to borders
---@param value number
---@return number
function utils_scaling.borders(value)
    return dpi(value) * user_look_scaling.borders * user_look_scaling.contents
end

--- Initialize size values related to corner radius
---@param value number
---@return number
function utils_scaling.radius(value)
    return dpi(value) * user_look_scaling.radius * user_look_scaling.contents
end

return utils_scaling
