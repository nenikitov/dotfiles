local awful = require('awful')
local wibox = require('wibox')
local naughty = require('naughty')
local beautiful = require('beautiful')
require('neconfig.config.utils.widget_utils')

local style = beautiful.user_vars_theme.popup

-- TODO implement this
function add_custom_popup(args)
    --#region Aliases for the arguments
    local widgets = args.widgets
    local position = args.position
    local direction = args.direction
    local screen = args.screen
    local info_table = args.info_table
    local name = args.name
    --#endregion

    --#region Init the popup table
    info_table[name] = {}
    --#endregion

    --#region Construct the widgets
    local layout = wibox.layout.fixed[direction]()
    for _, wi in pairs(widgets) do
        layout:add(wi)
    end
    --#endregion


    local popup = awful.popup {
        widget = layout,
        screen = screen,
        preferred_positions = 'bottom',
        ontop = true,
        offset = {
            y = 10
        },
        bg = style.background_color
    }
    popup:move_next_to(position.target)

    popup:connect_signal(
        'mouse::leave',
        function ()
            popup.visible = false
        end
    )

    info_table[name] = popup
end
