-- Standard Awesome libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local utils = require("modules.main.utils")

-- Load custom modules
wallpaper = require("modules.deco.wallpaper")

-- {{{ Generate widgets that are the same on all the screens
-- Launcher menu
local launcher = awful.widget.launcher({
    image = config_path .. "graphics/icons/arch-logo.svg",
    menu = rc.menu
});
-- Current keyboard layout
local keyboardlayout = awful.widget.keyboardlayout()
-- Clock
local textclock = wibox.widget.textclock()
-- Systray for background applications
local systray = wibox.widget.systray()
-- systray.base_size = 26
-- }}}


function theme.at_screen_connect(s)
    -- Generate new taglist if rc.lua passed button info
    local taglist;
    if theme.taglist_buttons ~= nil
    then
        taglist = awful.widget.taglist {
            screen = s,
            filter = awful.widget.taglist.filter.all,
            buttons = theme.taglist_buttons,
        }
    else
        taglist = s.taglist
    end
    -- Generate new tasklist if rc.lua passed button info
    local tasklist;
    if theme.tasklist_buttons ~= nil
    then
        tasklist = awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = theme.tasklist_buttons,
            layout = { layout = wibox.layout.fixed.horizontal },
            widget_template = {
                {
                    wibox.widget.base.make_widget(),
                    forced_height = 2,
                    id = 'background_role',
                    widget = wibox.container.background,
                },
                {
                    {
                        {
                            id = 'clienticon',
                            widget = awful.widget.clienticon,
                        },
                        {
                            id = 'text_role',
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
        }
    else
        tasklist = s.tasklist
    end

    -- Add widgets to the wibox
    s.wibox:setup {
        -- Left widgets
        {
            launcher,
            taglist,
            s.promptbox,

            layout = wibox.layout.fixed.horizontal,
        },
        -- Middle widget
        tasklist, 
        -- Right widgets
        {
            keyboardlayout,
            systray,
            textclock,
            s.layoutbox,

            layout = wibox.layout.fixed.horizontal,
        },

        layout = wibox.layout.align.horizontal,
    }
end
