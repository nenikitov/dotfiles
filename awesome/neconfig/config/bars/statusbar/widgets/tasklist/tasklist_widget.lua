-- Load libaries
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')


local function get_tasklist_widget(style)
    local widget_style = nil


    local widget_layout = {
        layout = wibox.layout.fixed.horizontal,
        forced_width = 800
    }


    local widget_template = nil

    return {
        style = widget_style,
        layout = widget_layout,
        widget_template = widget_template
    }
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_tasklist_widget(...) end }
)
