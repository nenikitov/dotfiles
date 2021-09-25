local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')


-- Create button binds for task list
local function get_tasklist_buttons()
    local tasklist_buttons = gears.table.join(
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
                        {raise = true}
                    )
                end
            end
        ),
        -- Display client list on RMB
        awful.button(
            { }, 3,
            function()
                awful.menu.client_list({ theme = { width = 250 } })
            end
        ),
        -- Go to next task on FTMB
        awful.button(
            { }, 4,
            function ()
                awful.client.focus.byidx(1)
            end
        ),
        -- Go to previous task on BTMB
        awful.button(
            { }, 5,
            function ()
                awful.client.focus.byidx(-1)
            end
        )
    )

    return tasklist_buttons
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_tasklist_buttons(...) end }
)
