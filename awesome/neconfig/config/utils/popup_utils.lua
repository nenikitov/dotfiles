local awful = require('awful')
local wibox = require('wibox')
local naughty = require('naughty')
require('neconfig.config.utils.widget_utils')


-- TODO implement this
function add_custom_popup(args)
    --#region Aliases for the arguments
    local widgets = args.widgets
    local position = args.position
    local screen = args.screen
    local info_table = args.info_table
    local name = args.name
    --#endregion

    --#region Init the popup table
    info_table[name] = {}
    --#endregion


    local popup = awful.popup {
        widget = widgets[1],
        screen = screen,
        preferred_positions = 'bottom',
        offset = {
            y = 10
        }
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
