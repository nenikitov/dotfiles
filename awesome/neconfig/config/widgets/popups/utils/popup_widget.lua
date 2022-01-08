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
    local widgets = args.widgets or {}
    local style = args.style or {}
    local direction = args.direction or 'vertical'
    local use_real_clip = args.use_real_clip or false
    local visible = args.visible or false
    local type = args.type or 'toolbar'
    local screen = args.screen
    -- Additional variables


    local layout = wibox.layout.fixed[direction](
        table.unpack(widgets)
    )
    layout.spacing = style.spacing

    -- Generate a popup
    self = awful.popup {
        widget = layout,
        type = type,
        screen = screen,
        visible = visible
    }

    return self
end

return setmetatable(
    {},
    { __call = function(_, ...) return popup_widget:new(...) end }
)
