-- Standard Awesome libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

-- Load custom modules
local moddeco = {
    wallpaper = require("modules.deco.wallpaper"),
    taglist = require("modules.deco.taglist"),
    tasklist = require("modules.deco.tasklist")
}

-- Get taglist and tasklist buttons
local taglist_buttons = moddeco.taglist()
local tasklist_buttons = moddeco.tasklist()

-- Time and keyboard layout widgets
local mytextclock = wibox.widget.textclock()
local mykeyboardlayout = awful.widget.keyboardlayout()

awful.screen.connect_for_each_screen(
    -- Set up the status bar (top bar) for each screen
    function(s)
        -- Set wallpaper for each screen
        set_wallpaper(s)

        -- Create a promptbox for each screen
        s.mypromptbox = awful.widget.prompt()
        -- Create an imagebox widget which will contain an icon indicating which layout we're using
        s.mylayoutbox = awful.widget.layoutbox(s)
        s.mylayoutbox:buttons(gears.table.join(
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc( 1) end),
            awful.button({ }, 5, function () awful.layout.inc(-1) end)
        ))
        -- Create a taglist widget
        s.mytaglist = awful.widget.taglist {
            screen  = s,
            filter  = awful.widget.taglist.filter.all,
            buttons = taglist_buttons
        }

        -- Create a tasklist widget
        s.mytasklist = awful.widget.tasklist {
            screen  = s,
            filter  = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons,
            layout   = {
                layout  = wibox.layout.fixed.horizontal
            },
            widget_template = {
                {
                    wibox.widget.base.make_widget(),
                    forced_height = 5,
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
                    margins = 5,
                    widget  = wibox.container.margin
                },
                forced_width = 250,
                layout = wibox.layout.align.vertical,
                create_callback = function(self, c, index, objects) --luacheck: no unused args
                    self:get_children_by_id('clienticon')[1].client = c
                end,
            },
        }

        -- Create the wibox
        s.mywibox = awful.wibar({
            position = "top",
            screen = s,
            height = 40,
        })

        -- Add widgets to the wibox
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            -- Left widgets
            {
                layout = wibox.layout.fixed.horizontal,
                rc.launcher,
                s.mytaglist,
                s.mypromptbox,
            },
            -- Middle widget
            s.mytasklist, 
            -- Right widgets
            {
                layout = wibox.layout.fixed.horizontal,
                mykeyboardlayout,
                wibox.widget.systray(),
                mytextclock,
                s.mylayoutbox,
            }
        }
    end
)
