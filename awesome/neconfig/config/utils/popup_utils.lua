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

    local popup = awful.popup {
        widget = widgets[2],
        placement = awful.placement.centered,
        screen = screen
    }


    popup:connect_signal(
        'mouse::leave',
        function ()
            popup.visible = false
        end
    )

    info_table[name] = popup
end

-- TODO
-- ! TEST Remove this
--[[
-- This is how to create a keygrabber
awful.keygrabber {
    keybindings = {
        awful.key {
            modifiers = { 'Mod1' },
            key =       'Tab',
            on_press = function ()
                naughty.notify {
                    text = 'Alt tab pressed'
                }
            end
        }
    },
    stop_key = 'k',
    stop_event = 'release',
    autostart = 'true'
}
]]

--[[
mousegrabber.run(
    function(mouse)
        if mouse.x > 1000 then

            return false
        end
        return true
    end,
    'left_ptr'
)
]]
