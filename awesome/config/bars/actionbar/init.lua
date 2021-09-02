-- Load librareis
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')


local user_menu = require('config.user.user_menu')


-- Get info about complex widgets
local taglist_buttons = require('config.bars.actionbar.widgets.taglist_buttons')()
local tasklist_buttons = require('config.bars.actionbar.widgets.tasklist_buttons')()
local layoutbox_buttons = require('config.bars.actionbar.widgets.layoutbox_buttons')()


-- Widgets that are the same on all screen
local launcher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = user_menu
})
local keyboardlayout = awful.widget.keyboardlayout()
local textclock = wibox.widget.textclock()
local systray = wibox.widget.systray()


-- Send button info to the theme
beautiful.tasklist_buttons = tasklist_buttons
beautiful.taglist_buttons = taglist_buttons


-- Set up the action bar for each screen
awful.screen.connect_for_each_screen(
    function(s)
        -- Generate widgets that are unique for each screen
        s.promptbox = awful.widget.prompt()
        s.taglist = awful.widget.taglist {
            screen = s,
            filter = awful.widget.taglist.filter.all,
            buttons = taglist_buttons,
        }
        s.tasklist = awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons,
        }
        s.layoutbox = awful.widget.layoutbox(s)
        s.layoutbox:buttons(layoutbox_buttons)
        
        -- Generate the container
        s.wibox = awful.wibar {
            position = 'top',
            screen = s,
        }


        -- Add widgets to the wibar
        s.wibox:setup {
            -- Left widgets
            {
                launcher,
                s.taglist,
                s.promptbox,

                layout = wibox.layout.fixed.horizontal,
            },
            -- Middle widget
            s.tasklist, 
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

        -- Let the theme modify the wibar
        if beautiful.at_screen_connect ~= nil
        then
            beautiful.at_screen_connect(s)
        end
    end
)
