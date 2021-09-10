-- Load librareis
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
-- Load custom modules
local user_menu = require('neconfig.config.user.user_menu')
local user_vars_conf = require('neconfig.config.user.user_vars_conf')
require('neconfig.config.utils.widget_utils')
require('neconfig.config.utils.bar_utils')

-- Get variables
-- From theme
local bar_info = beautiful.user_vars_theme.statusbar
local section_content_size = bar_info.height - bar_info.margin.edge * 4
-- Precalculate
local section_style = {
    background_color = '#ff0000ff',
    contents_size = section_content_size,
    margin = bar_info.margin,
    spacing = bar_info.spacing,
    corner_radius = bar_info.corner_radius
}

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
            position = bar_info.position,
            screen = s,
            height = bar_info.height
        }
        s.statusbar.wibar:setup {
            layout = wibox.layout.flex.horizontal
        }
        
        -- Here is a better solution to sections
        local previous = nil
        for i=1, 2 do
            local p2 = awful.popup {
                widget = wibox.widget {
                    text   = '| '..i..' |',
                    widget = wibox.widget.textbox
                },
                preferred_positions = 'right',
                placement           = (not previous) and awful.placement.top_left or nil,
                offset = {
                    x = 10
                },
                screen = s,
            }

            p2:move_next_to(previous)
            previous = p2
        end

        -- TODO remove this later
        local keyboardlayout = require('neconfig.config.bars.statusbar.widgets.keyboard.keyboard_init')
        local clock = require('neconfig.config.bars.statusbar.widgets.textclock.textclock_init')
        local taglist = require('neconfig.config.bars.statusbar.widgets.taglist.taglist_init')(s)
        local menu = require('neconfig.config.bars.statusbar.widgets.menu.menu_init')
        local promptbox = awful.widget.prompt()
        local systray = wibox.widget.systray()

        --[[
        add_section {
            name = 'kb',
            widgets = {
                keyboardlayout,
            },
            position = {
                side = bar_info.position,
                section = 1
            },
            style = section_style,
            screen = s,
            info_table = s.statusbar.sections
        }

        add_section {
            name = 'taglist',
            widgets = {
                taglist,
            },
            position = {
                side = bar_info.position,
                section = 1
            },
            style = section_style,
            screen = s,
            info_table = s.statusbar.sections
        }

        add_section {
            name = 'clock',
            widgets = {
                clock,
            },
            position = {
                side = bar_info.position,
                section = 3
            },
            style = section_style,
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
            style = section_style,
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
