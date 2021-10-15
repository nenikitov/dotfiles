local awful = require('awful')
local wibox = require('wibox')
local naughty = require('naughty')
local beautiful = require('beautiful')
require('neconfig.config.utils.widget_utils')

local style = beautiful.user_vars_theme.popup


local function generate_offset(position)
    local offset_lookup = {
        top = {
            y = -style.offset
        },
        bottom = {
            y = style.offset
        },
        left = {
            x = style.offset
        },
        right = {
            x = -style.offset
        }
    }

    return offset_lookup[position]
end


-- TODO implement this
function add_custom_popup(args)
    --#region Aliases for the arguments
    local widgets = args.widgets
    local position_type = args.position_type
    local position_args = args.position_args
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


    --#region Generate popup
    local popup = awful.popup {
        widget = {
            layout,

            margins = style.padding,
            widget = wibox.container.margin,
        },
        shape = r_rect(style.corner_radius),
        screen = screen,
        ontop = true,
        bg = style.background_color,
    }
    --#endregion

    --#region Place popup
    if (position_type == 'attach')
    then
        popup.preferred_positions = position_args.position
        popup.preferred_anchors = position_args.anchor
        popup.offset = generate_offset(position_args.position)
        popup:move_next_to(position_args.target)
    end
    --#endregion 

    popup:connect_signal(
        'mouse::leave',
        function ()
            popup.visible = false
        end
    )
    --popup.visible = false

    info_table[name] = popup
end
