-- Load libaries
local wibox = require('wibox')
local awful = require('awful')

local dpi = require("beautiful").xresources.apply_dpi
-- Load custom modulesclient.gaps,
local user_vars_conf = require('neconfig.config.user.user_vars_conf')


local function get_tasklist_widget(style)
    local widget_style = nil


    local widget_layout = {
        layout = wibox.layout.flex.horizontal,
        forced_width = 800
    }


    local widget_template = {
        {
            {
                awful.widget.clienticon,
                id = "icon_margin_role",
                left = dpi(4),
                widget = wibox.container.margin
            },
            {
                {
                    id = "text_role",
                    widget = wibox.widget.textbox,
                },
                id = "text_margin_role",
                left = dpi(4),
                right = dpi(4),
                widget = wibox.container.margin
            },
            fill_space = true,
            layout = wibox.layout.fixed.horizontal
        },
        id = "background_role",
        widget = wibox.container.background
    }

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
