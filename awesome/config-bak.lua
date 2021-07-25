-- Taglist
taglist_info.template = {
    {
        {
            {
                widget = wibox.widget.textbox,

                id = "text_role"
            },
            {
                widget = wibox.widget.textbox,

                id = "icon_role"
            },

            layout = wibox.layout.fixed.horizontal 
        },

        widget = wibox.container.margin,

        left = 5,
        right = 5
    },

    widget = wibox.container.background,
    
    id = "background_role"
}

-- Tasklist
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

-- Wibar
-- Standard Awesome libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local utils = require("modules.main.utils")

-- Load custom modules
wallpaper = require("modules.deco.wallpaper")
-- Get info about complex widgets
local taglist_info = require("modules.deco.taglist")()
local tasklist_info = require("modules.deco.tasklist")()
local layoutbox_buttons = require("modules.deco.layoutbox")()

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
-- Systray for background applications
local systray = wibox.widget.systray()
systray.base_size = 26
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
            buttons = taglist_info.buttons,
            -- widget_template = taglist_info.template
        }
        -- Tasklist
        s.tasklist = awful.widget.tasklist {
            screen  = s,
            filter  = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_info.buttons,
            layout   = {
                layout  = wibox.layout.fixed.horizontal
            },
            -- widget_template = tasklist_info.template
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
                    create_pill(launchermenu, "#00000090", true),
                    create_pill(s.taglist, "#00000090", true),
                    s.promptbox,

                    layout = wibox.layout.fixed.horizontal,
                },
                -- Middle widget
                create_pill(s.tasklist, "#00000090", true), 
                -- Right widgets
                {
                    create_pill(keyboardlayout, "#00000090", true),
                    create_pill(systray, "#00000090", true),
                    create_pill(textclock, "#00000090", true),
                    create_pill(s.layoutbox, "#00000090"),

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

-- Rounded corners
-- Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function (c)
        -- Set the shape to be rounded rectangle
        c.shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 10)
        end

        -- Set the windows at the slave (put it at the end of others instead of setting it master)
        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)