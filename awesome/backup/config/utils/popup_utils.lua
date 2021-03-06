-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local capi = { button = button }
local wibox = require('wibox')
-- Load custom modules
local widget_utils = require('neconfig.config.utils.widget_utils')

-- Get style
local style = beautiful.user_vars_theme.popup


-- Container for functions
local popup_utils = {}

--- Calculate the offset from the edge of the screen to the popup widget
---@param position string Position of the bar ('top', 'bottom', 'left', 'right')
---@return table
local function generate_offset(position)
    local offset_lookup = {
        top = {
            y = -style.offset
        },
        bottom = {
            y = style.offset
        },
        left = {
            x = -style.offset
        },
        right = {
            x = style.offset
        }
    }

    return offset_lookup[position]
end


-- TODO implement different position and size arguments
popup_utils.add_custom_popup = function(args)
    --#region Aliases for the arguments
    local name = args.name
    local widgets = args.widgets
    local tooltip = args.tooltip
    local direction = args.direction
    local position_type = args.position_type
    local position_args = args.position_args
    local toggle_visibility_widget = args.toggle_visibility_widget
    local screen = args.screen
    local info_table = args.info_table
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
        shape = widget_utils.r_rect(style.corner_radius),
        screen = screen,
        ontop = true,
        bg = style.background_color
    }
    --#endregion

    --#region Place popup
    if (position_type == 'attach')
    then
        popup.preferred_positions = position_args.position
        popup.preferred_anchors = position_args.anchor
        popup.offset = generate_offset(position_args.position)
        popup:move_next_to(position_args.target)
    elseif (position_type == 'place')
    then

    end
    --#endregion

    --#region Update visibility
    local function hide()
        popup.visible = false
    end
    -- Hide by default
    hide()
    -- Hide on mouse leave
    -- TODO make it not hide if mouse is outside after clicking a tray icon
    popup:connect_signal(
        'mouse::leave',
        function ()
            hide()
        end
    )
    -- Make popup stay if the mouse is inside
    popup:connect_signal(
        'mouse::enter',
        function ()
            capi.button.disconnect_signal('press', hide)
        end
    )
    -- Hide on ESC
    local function hide_grabber(mod, key, event)
        if (key == 'Escape' and event == 'press')
        then
            hide()
        end
        -- TODO make keygrabber pass through unknown inputs
    end
    popup:connect_signal(
        'property::visible',
        function ()
            local visible = popup.visible

            if (visible)
            then
                --awful.keygrabber.run(hide_grabber)
                capi.button.connect_signal('press', hide)
            else
                --awful.keygrabber.stop(hide_grabber)
                capi.button.disconnect_signal('press', hide)
            end

            for _,widget in pairs(widgets)
            do
                widget:emit_signal('custom::changed_popup_visibility', visible)
            end
        end
    )
    -- Toggle on click on the widget
    if (toggle_visibility_widget)
    then
        toggle_visibility_widget:connect_signal(
            'button::press',
            function ()
                -- Hide other popups if this popup will be revealed
                if (not popup.visible)
                then
                    capi.button.emit_signal('press', toggle_visibility_widget)
                end

                -- Toggle visibility
                popup.visible = not popup.visible
            end
        )
    end
    --#endregion

    --#region Add tooltip
    if (tooltip and toggle_visibility_widget)
    then
        awful.tooltip {
            objects = { toggle_visibility_widget },
            text = tooltip,
            delay_show = 1
        }
    end
    --#endregion

    info_table[name] = popup
end

return popup_utils
