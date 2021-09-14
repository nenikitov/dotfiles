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
local bar_info = beautiful.user_vars_theme.statusbar
local bar_size = bar_info.contents_size + bar_info.margin.edge + bar_info.margin.content * 2
-- Get bar size
local lookup_size_param = {
    ['top']    = {'width',  'height'},
    ['bottom'] = {'width',  'height'},
    ['left']   = {'height', 'width'},
    ['right']  = {'height', 'width'}
}
local size_param = {
    length    = lookup_size_param[bar_info.position][1],
    thickness = lookup_size_param[bar_info.position][2],
}
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

        -- TODO
        -- You can set wibars position by using s.statusbar.wibar.y
        -- However, the struts are not correct
        -- You should find how to make them better
        --
        -- Make so section accepts 1 widget
        -- Make so it resizes it automatically

        -- Create an empty wibar to constraint client position
        s.statusbar.wibar = awful.wibar {
            position = bar_info.position,
            screen = s,
            [size_param.thickness] = bar_size,
            [size_param.length] = s.geometry[size_param.length] - bar_info.margin.corners * 2,

            shape = function(cr, w, h)
                local offset = bar_info.margin.edge
                local transform_lookup = {
                    top = {
                        x = 0,
                        y = offset,
                        w = w,
                        h = h - offset
                    },
                    bottom = {
                        x = 0,
                        y = 0,
                        w = w,
                        h = h - offset
                    },
                    left = {
                        x = offset,
                        y = 0,
                        w = w - offset,
                        h = h
                    },
                    right = {
                        x = 0,
                        y = 0,
                        w = w - offset,
                        h = h
                    },
                }
                local transform = transform_lookup[bar_info.position]

                return gears.shape.transform(gears.shape.rounded_rect)
                    : translate(transform.x, transform.y)
                    (cr, transform.w, transform.h, bar_info.corner_radius.bar)
            end,
        }
        s.statusbar.wibar:setup {
            layout = wibox.layout.flex.horizontal
        }

        --#region 1st section
        add_section {
            name = 'menu',
            widget = menu,
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
            widget = textclock,
            position = {
                side = bar_info.position,
                section = 3
            },
            style = section_style,
            screen = s,
            info_table = s.statusbar.sections
        }
        --#endregion

        local systray = wibox.widget.systray(s)
        add_section {
            name = 'taglist',
            widget = systray,
            position = {
                side = 'bottom',
                section = 1
            },
            style = section_style,
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
