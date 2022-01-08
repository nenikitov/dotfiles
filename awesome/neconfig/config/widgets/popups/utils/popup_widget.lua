-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')


-- Container for class members
local popup_widget = {}


--#region Helper methods
--#endregion


function popup_widget:new(args)
    -- Reference to arguments and default values
    -- Additional variables


    -- Generate a popup
    self = awful.popup {

    }

    return self
end

return setmetatable(
    {},
    { __call = function(_, ...) return popup_widget:new(...) end }
)
