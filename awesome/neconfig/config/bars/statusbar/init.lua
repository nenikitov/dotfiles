-- Load librareis
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
-- Load custom modules
local user_menu = require('neconfig.config.user.user_menu')
local user_vars = require('neconfig.config.user.user_vars')
require('neconfig.config.utils.widget_utils')
require('neconfig.config.utils.bar_utils')

-- Get variables
-- From user_vars
local bar_position = user_vars.statusbar.position
local bar_height = user_vars.statusbar.height
-- From theme
local bar_info = beautiful.statusbar
local vertical_padding = bar_info.vertical_padding
local horizontal_padding = bar_info.horizontal_padding
local corner_radius = bar_info.corner_radius
local nested_widget_height = bar_height - vertical_padding * 2

-- Set up the action bar for each screen
awful.screen.connect_for_each_screen(
    function(s)
        --[[ TODO
        Create an empty wibar that will constraint the clients
        Create a separate popup widget for each section of the fake wibar
            Sections
                Left
                    Menu
                    Taglist
                Middle
                    Tasklist
                Right
                    Tools
                    Notifications
                    Keyboard
                    Clock
        ]]

        s.statusbar = {}
        s.statusbar.sections = {}

        -- Create an empty wibar to constraint client position
        s.statusbar.wibar = awful.wibar {
            position = bar_position,
            screen = s,
            height = user_vars.statusbar.height
        }
        s.statusbar.wibar:setup {
            layout = wibox.layout.flex.horizontal
        }

        -- TODO remove this later
        local keyboardlayout = require('neconfig.config.bars.statusbar.widgets.keyboard.keyboard_init')
        local clock = require('neconfig.config.bars.statusbar.widgets.textclock.textclock_init')
        local taglist = require('neconfig.config.bars.statusbar.widgets.taglist.taglist_init')(s)
        local menu = require('neconfig.config.bars.statusbar.widgets.menu.menu_init')
        local promptbox = awful.widget.prompt()
        local systray = wibox.widget.systray()


        add_section {
            name = 'kb',
            widgets = {
                keyboardlayout,
            },
            position = {
                side = 'top',
                section = 1
            },
            style = {
                initial_margin = 4,
                contents_size = 70,
                bar_margins = 4,
                contents_margins_to_content = 6,
                contents_margins_to_bar = 4,
                corner_radius = 4,
                background_color = '#ff0000ff'
            },
            screen = s,
            info_table = s.statusbar.sections
        }

        add_section {
            name = 'taglist',
            widgets = {
                taglist,
            },
            position = {
                side = 'top',
                section = 1
            },
            style = {
                initial_margin = 4,
                contents_size = 70,
                bar_margins = 4,
                contents_margins_to_content = 24,
                contents_margins_to_bar = 4,
                corner_radius = 4,
                background_color = '#ff0000ff'
            },
            screen = s,
            info_table = s.statusbar.sections
        }

        --[[
        add_section {
            name = 'clock',
            widgets = {
                clock,
            },
            position = {
                side = 'top',
                section = 3
            },
            style = {
                initial_margin = 4,
                contents_size = 70,
                bar_margins = 4,
                contents_margins_to_content = 24,
                contents_margins_to_bar = 4,
                corner_radius = 4,
                background_color = '#ff0000ff'
            },
            screen = s,
            info_table = s.statusbar.sections
        }

        add_section {
            name = 'systray',
            widgets = {
                systray,
            },
            position = {
                side = 'bottom',
                section = 1
            },
            style = {
                initial_margin = 4,
                contents_size = 70,
                bar_margins = 4,
                contents_margins_to_content = 6,
                contents_margins_to_bar = 4,
                corner_radius = 4,
                background_color = '#ff0000ff'
            },
            screen = s,
            info_table = s.statusbar.sections
        }
        ]]

        --[[
        s.first_popup = awful.popup {
            screen = s,
            placement = awful.placement.top_right,
            widget = {
                taglist,
                widget = wibox.container.background,
                forced_height = 30
            }
        }

        local prev_widget = s.first_popup
        s.next_popup = awful.popup {
            screen = s,
            placement = function(wi)
                return awful.placement.top_right(wi, {margins = {right = (s.geometry.width - prev_widget.x) + 5}})
            end,
            widget = {
                menu,
                widget = wibox.container.background,
                forced_width = 30,
                forced_height = 30
            }
        }

        local prev_widget = s.next_popup
        s.last_popup = awful.popup {
            screen = s,
            placement = function(wi)
                return awful.placement.top_right(wi, {margins = {right = (s.geometry.width - prev_widget.x) + 5}})
            end,
            widget = {
                keyboardlayout,
                widget = wibox.container.background,
                forced_height = 30,
            }
        }
        ]]
    end
)
