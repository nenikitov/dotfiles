local awful = require('awful')
local wibox = require('wibox')
local naughty = require('naughty')
require('neconfig.config.utils.widget_utils')
local capi = { button = button, mouse = mouse }


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

    --[[
    popup:connect_signal(
        'property::visible',
        function (w)
            if (not w.visible) then
            else
        end
    )]]
    --[[
    capi.button.connect_signal(
        'press',
        function ()
            naughty.notify {
                text = 'click'
            }
        end
    )
    ]]

    popup:connect_signal(
        'mouse::enter',
        function ()
            naughty.notify {
                text = 'entered'
            }
        end
    )
    popup:connect_signal(
        'mouse::leave',
        function ()
            naughty.notify {
                text = 'left'
            }
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
local mousegrabber = require('mousegrabber')
mousegrabber.run(test, 'leftbutton')

local function test()
    naughty.notify {
        text = 'left click'
    }
    mousegrabber.stop()
end
]]
