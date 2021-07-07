-- Standard Awesome libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local utils = require("modules.main.utils")

-- Load custom modules
local moddeco = {
    wallpaper = require("modules.deco.wallpaper"),
    taglist = require("modules.deco.taglist"),
    tasklist = require("modules.deco.tasklist"),
    layoutbox = require("modules.deco.layoutbox")
}

-- Get taglist and tasklist buttons
local taglist_buttons = moddeco.taglist()
local tasklist_buttons = moddeco.tasklist()
local layoutbox_buttons = moddeco.layoutbox()

-- {{{ Generate widgets that are the same on all the screens
-- Launcher menu
local launchermenu = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = rc.menu
})
-- Current keyboard layout
local keyboardlayout = awful.widget.keyboardlayout()
-- Clock
local textclock = wibox.widget.textclock()
-- }}}


awful.screen.connect_for_each_screen(
    -- Set up the status bar (top bar) for each screen
    function(s)
        -- Set wallpaper for each screen
        set_wallpaper(s)

        -- {{{ Generate widgets that are unique for each screen
        -- Promptbox 
        s.promptbox = awful.widget.prompt()
        -- Taglist
        s.taglist = awful.widget.taglist {
            screen  = s,
            filter  = awful.widget.taglist.filter.all,
            buttons = taglist_buttons
        }
        -- Tasklist
        s.tasklist = awful.widget.tasklist {
            screen  = s,
            filter  = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons,
            layout   = {
                layout  = wibox.layout.fixed.horizontal
            },
            widget_template = {
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
            },
        }
        -- Current layout indicator
        s.layoutbox = awful.widget.layoutbox(s)
        s.layoutbox:buttons(layoutbox_buttons)
        -- Wibar on top that will display previous widgets
        s.wibox = awful.wibar {
            position = "top",
            ontop = true,
            screen = s,
            height = 30
        }
        -- }}}

        -- Add widgets to the wibox
        s.wibox:setup {
            {
                -- Left widgets
                {
                    createpill(launchermenu, "#00000090"),
                    createpill(s.taglist, theme.border_marked),
                    s.promptbox,

                    layout = wibox.layout.fixed.horizontal,
                },
                -- Middle widget
                s.tasklist, 
                -- Right widgets
                {
                    keyboardlayout,
                    wibox.widget.systray(),
                    textclock,
                    s.layoutbox,

                    layout = wibox.layout.fixed.horizontal,
                },

                layout = wibox.layout.align.horizontal,
            },
            widget = wibox.container.margin,

            top = 2,
            bottom = 2,
            left = 4,
            right = 4
        }
    end
)
