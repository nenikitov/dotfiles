-- Load libraries
local gears = require('gears')
local awful = require('awful')


-- Create button binds for task list
local tasklist_buttons = {
    -- Minimize / Restore on LMB
    awful.button(
        { }, 1,
        function (c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal(
                    'request::activate',
                    'tasklist',
                    { raise = true }
                )
            end
        end
    ),
    -- Close on MMB
    awful.button(
        { }, 2,
        function (c)
            c:kill()
        end
    ),
    -- Display client list on RMB
    awful.button(
        { }, 3,
        function()
            awful.menu.client_list {
                theme = {
                    width = 250
                }
            }
        end
    ),
    -- Go to next task on SCROLL UP
    awful.button(
        { }, 4,
        function ()
            awful.client.focus.byidx(1)
        end
    ),
    -- Go to previous task on SCROLL DOWN
    awful.button(
        { }, 5,
        function ()
            awful.client.focus.byidx(-1)
        end
    )
}

return tasklist_buttons
