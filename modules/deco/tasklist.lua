local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

function gettasklist()
    local tasklist_info = {}

    -- Create buttons for task list
    tasklist_info.buttons = gears.table.join(
        -- Mimimize / Restore on LMB
        awful.button(
            { },
            1,
            function (c)
                if c == client.focus then
                    c.minimized = true
                else
                    c:emit_signal(
                        "request::activate",
                        "tasklist",
                        {raise = true}
                    )
                end
            end
        ),
        -- Display client list on RMB
        awful.button(
            { },
            3,
            function()
                awful.menu.client_list({ theme = { width = 250 } })
            end
        ),
        -- Go to next task on FTMB
        awful.button(
            { },
            4, 
            function ()
                awful.client.focus.byidx(1)
            end
        ),
        -- Go to previous task on BTMB
        awful.button(
            { },
            5,
            function ()
                awful.client.focus.byidx(-1)
            end
        )
    )

    -- Create a widget template
    tasklist_info.template = {
        {
            wibox.widget.base.make_widget(),
            forced_height = 2,
            id            = 'background_role',
            widget        = wibox.container.background,
        },
        {
            {
                {
                    id     = 'clienticon',
                    widget = awful.widget.clienticon,
                },
                {
                    id     = 'text_role',
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.fixed.horizontal
            },
            margins = 2,
            widget  = wibox.container.margin
        },
        forced_width = 250,
        layout = wibox.layout.align.vertical,
        create_callback = function(self, c, index, objects)
            self:get_children_by_id('clienticon')[1].client = c
        end,
    }

    return tasklist_info
end

return setmetatable(
    {},
    {  __call = function(_, ...) return gettasklist(...) end }
)
