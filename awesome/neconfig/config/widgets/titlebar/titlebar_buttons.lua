-- Load libraries
local awful = require('awful')
-- Load custom modules
local utils_widgets = require('neconfig.config.utils.utils_widgets')


local function titlebar_buttons(c)
    local buttons = {
        -- Move client on LMB / Toggle maximize on DOUBLE CLICK LMB
        awful.button(
            { }, 1,
            function()
                c:emit_signal('request::activate', 'titlebar', {raise = true})

                if utils_widgets.check_double_click(c) then
                    c.maximized = not c.maximized
                    c:raise()
                else
                    awful.mouse.client.move(c)
                end
            end
        ),
        -- Resize client on RMB
        awful.button(
            { }, 3,
            function()
                c:emit_signal('request::activate', 'titlebar', {raise = true})
                awful.mouse.client.resize(c)
            end
        )
    }
    return buttons
end

return titlebar_buttons
