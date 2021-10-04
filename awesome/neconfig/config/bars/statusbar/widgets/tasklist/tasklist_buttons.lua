-- Load libraries
local gears = require('gears')
local awful = require('awful')


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
        -- TODO fix this, it does not work. Mouse 4 and 5 do nothing
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
        -- TODO middle click to close
    )

    return tasklist_buttons
end

return setmetatable(
    {},
    {  __call = function(_, ...) return get_tasklist_buttons() end }
)
