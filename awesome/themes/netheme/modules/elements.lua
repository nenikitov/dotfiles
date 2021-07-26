-- Standard Awesome libraries
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local utils = require("themes.netheme.modules.utils")

-- {{{ Generate widgets that are the same on all the screens
-- Current keyboard layout
local keyboardlayout = awful.widget.keyboardlayout()
-- Clock
local textclock = wibox.widget.textclock()
-- Systray for background applications
local systray = wibox.widget.systray()
-- systray.base_size = 26
-- }}}


function theme.at_screen_connect(s)
    -- {{{ Generate widgets that are unique for each screen
    -- New taglist if rc.lua passed button info
    local taglist;
    if theme.taglist_buttons ~= nil
    then
        taglist = awful.widget.taglist {
            screen = s,
            filter = awful.widget.taglist.filter.all,
            buttons = theme.taglist_buttons,
            widget_template = {
                {
                    {
                        {
                            widget = wibox.widget.textbox,
            
                            id = "text_role"
                        },
                        {
                            widget = wibox.widget.imagebox,
            
                            id = "icon_role"
                        },
            
                        layout = wibox.layout.fixed.horizontal 
                    },
            
                    widget = wibox.container.margin,
            
                    left = 5,
                    right = 5
                },
            
                widget = wibox.container.background,
                
                id = "background_role",
            }
        }
    else
        taglist = s.taglist
    end
    -- New tasklist if rc.lua passed button info
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

    -- Launcher menu
    local launcher = awful.widget.launcher({
        image = theme.awesome_icon,
        menu = rc.menu
    });
    -- }}}

    -- {{{ Change wibox settings
    s.wibox.ontop = true
    --s.wibox.shape = gears.shape.rounded_rect
    -- }}}

    -- {{{ Create widget groups
    local left_widgets = {
        launcher,
        taglist,
        s.promptbox,

        layout = wibox.layout.fixed.horizontal,
    }
    local middle_widgets = tasklist
    local right_widgets = {
        keyboardlayout,
        systray,
        textclock,
        s.layoutbox,

        layout = wibox.layout.fixed.horizontal,
    }
    -- }}}


    -- {{{ Add widgets to the wibox
    s.wibox:setup {
        create_pill(left_widgets, "#00000070", 5, true),
        create_pill(middle_widgets, "#00000070", 5, true),
        create_pill(right_widgets, "#00000070", 5, true),

        layout = wibox.layout.align.horizontal,
    }
    -- }}}
end

function theme.client_setup(c)
    -- Set the shape to be rounded rectangle
    c.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, 15)
    end
end

function theme.titlebar_setup(c)
    awful.titlebar(c):setup {
        -- Left
        {
            awful.titlebar.widget.iconwidget(c),
            buttons = theme.titlebar_buttons,
            layout = wibox.layout.fixed.horizontal
        },
        -- Middle
        {
            -- Title
            {
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = theme.titlebar_buttons,
            layout = wibox.layout.flex.horizontal
        },
        -- Right
        {
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }

    --[[
                awful.titlebar(c, { position = "top" }):setup {
            widget = wibox.container.background,
            shape = gears.shape.cross
        }

        awful.titlebar(c, { position = "bottom" }):setup {
            -- Left
            {
                awful.titlebar.widget.iconwidget(c),
                buttons = theme.titlebar_buttons,
                layout = wibox.layout.fixed.horizontal
            },
            -- Middle
            {
                -- Title
                {
                    align = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = theme.titlebar_buttons,
                layout = wibox.layout.flex.horizontal
            },
            -- Right
            {
                awful.titlebar.widget.floatingbutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.ontopbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
    ]]
end
