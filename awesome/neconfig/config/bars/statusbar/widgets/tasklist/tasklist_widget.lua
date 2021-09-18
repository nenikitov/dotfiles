-- Load libaries
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local clienticon = require("awful.widget.clienticon")
local wmargin = require("wibox.container.margin")
local wtextbox = require("wibox.widget.textbox")
local wfixed = require("wibox.layout.fixed")
local wbackground = require("wibox.container.background")
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
                clienticon,
                id = "icon_margin_role",
                left = dpi(4),
                widget = wmargin
            },
            {
                {
                    id = "text_role",
                    widget = wtextbox,
                },
                id = "text_margin_role",
                left = dpi(4),
                right = dpi(4),
                widget = wmargin
            },
            fill_space = true,
            layout = wfixed.horizontal
        },
        id = "background_role",
        widget = wbackground
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
