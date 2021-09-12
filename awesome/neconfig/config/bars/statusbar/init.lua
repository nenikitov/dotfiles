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
local bar_height = bar_info.contents_size + bar_info.margin.edge + bar_info.margin.content * 2
-- Style that will be usef for sections
local section_style = {
    background_color = bar_info.colors.bg_sections,
    contents_size = bar_info.contents_size,
    margin = bar_info.margin,
    spacing = bar_info.spacing,
    corner_radius = bar_info.corner_radius.sections
}


local menu = require('neconfig.config.bars.statusbar.widgets.menu.menu_init')(
    bar_info.contents_size
)
local textclock = require('neconfig.config.bars.statusbar.widgets.textclock.textclock_init')


-- Set up the action bar for each screen
awful.screen.connect_for_each_screen(
    function(s)
        s.statusbar = {}
        s.statusbar.sections = {}


        -- Create an empty wibar to constraint client position
        s.statusbar.wibar = awful.wibar {
            position = bar_info.position,
            screen = s,
            height = bar_height,
            stretch = false,
            width = s.geometry.width - bar_info.margin.corners * 2,
            shape = function(cr, w, h)
                return gears.shape.transform(gears.shape.rounded_rect)
                    : translate(0, bar_info.margin.edge)
                    (cr, w, h - bar_info.margin.edge, bar_info.corner_radius.bar)
            end,
        }
        s.statusbar.wibar:setup {
            layout = wibox.layout.flex.horizontal
        }


        --#region 1st section
        add_section {
            name = 'menu',
            widgets = {
                menu,
            },
            position = {
                side = bar_info.position,
                section = 1
            },
            style = section_style,
            screen = s,
            info_table = s.statusbar.sections
        }
        --#endregion

        --#region 3rd section
        add_section {
            name = 'clock',
            widgets = {
                textclock,
            },
            position = {
                side = bar_info.position,
                section = 3
            },
            style = section_style,
            screen = s,
            info_table = s.statusbar.sections
        }
        --#endregion

        --[[
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
            name = 'clock',
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
    end
)
