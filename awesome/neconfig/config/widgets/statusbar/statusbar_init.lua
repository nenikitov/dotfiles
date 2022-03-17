-- Load libraries
local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')

 -- Keyboard map indicator and switcher
local keyboard_layout = awful.widget.keyboardlayout()
 
 -- {{{ Wibar
 -- Create a textclock widget
local text_clock = wibox.widget.textclock()
 
 -- Create a wibox for each screen and add it
 local taglist_buttons = gears.table.join(
                     awful.button({ }, 1, function(t) t:view_only() end),
                     awful.button({ 'Mod4' }, 1, function(t)
                                               if client.focus then
                                                   client.focus:move_to_tag(t)
                                               end
                                           end),
                     awful.button({ }, 3, awful.tag.viewtoggle),
                     awful.button({ 'Mod4' }, 3, function(t)
                                               if client.focus then
                                                   client.focus:toggle_tag(t)
                                               end
                                           end),
                     awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                     awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                 )
 
 local tasklist_buttons = gears.table.join(
                      awful.button({ }, 1, function (c)
                                               if c == client.focus then
                                                   c.minimized = true
                                               else
                                                   c:emit_signal(
                                                       "request::activate",
                                                       "tasklist",
                                                       {raise = true}
                                                   )
                                               end
                                           end),
                      awful.button({ }, 3, function()
                                               awful.menu.client_list({ theme = { width = 250 } })
                                           end),
                      awful.button({ }, 4, function ()
                                               awful.client.focus.byidx(1)
                                           end),
                      awful.button({ }, 5, function ()
                                               awful.client.focus.byidx(-1)
                                           end))

awful.screen.connect_for_each_screen(
    function(s)
        -- Create a promptbox for each screen
    s.promptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.layoutbox = awful.widget.layoutbox(s)
    s.layoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.tasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.wibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.wibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.taglist,
            s.promptbox,
        },
        s.tasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            keyboard_layout,
            wibox.widget.systray(),
            text_clock,
            s.layoutbox,
        },
    }
    end
)