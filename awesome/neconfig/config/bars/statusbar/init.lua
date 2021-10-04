-- Load libraries
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
-- Load custom modules
require('neconfig.config.utils.widget_utils')
require('neconfig.config.utils.bar_utils')
require('neconfig.config.utils.popup_utils')

-- Get variables
local bar_info = beautiful.user_vars_theme.statusbar
-- Get bar size
local bar_size = bar_info.contents_size + bar_info.margin.content * 2
local lookup_size_param = {
    ['top']    = {'width',  'height'},
    ['bottom'] = {'width',  'height'},
    ['left']   = {'height', 'width' },
    ['right']  = {'height', 'width' }
}
local size_param = {
    length = lookup_size_param[bar_info.position][1],
    thickness = lookup_size_param[bar_info.position][2],
}
-- Style that will be used for sections
local section_style = {
    background_color = bar_info.colors.bg_sections,
    contents_size = bar_info.contents_size,
    margin = bar_info.margin,
    spacing = bar_info.spacing,
    corner_radius = bar_info.corner_radius.sections
}
-- TODO create better separate fields for popups
local popup_style = {
    background_color = bar_info.colors.bg_sections,
    margin = bar_info.margin,
    spacing = bar_info.spacing,
    corner_radius = bar_info.corner_radius.sections
}

--#region Generate screen independent widgets
local menu = require('neconfig.config.bars.statusbar.widgets.menu.menu_init')(bar_info)
local textclock = require('neconfig.config.bars.statusbar.widgets.textclock.textclock_init')(bar_info)
local keyboard_layout = require('neconfig.config.bars.statusbar.widgets.keyboard.keyboard_init')
--#endregion


-- Set up the status bar for each screen
awful.screen.connect_for_each_screen(
    function(s)
        --#region Generate screen specific widgets
        local taglist = require('neconfig.config.bars.statusbar.widgets.taglist.taglist_init')(s, bar_info)
        local systray = wibox.widget.systray(s)
        local layoutbox = require('neconfig.config.bars.statusbar.widgets.layoutbox.layoutbox_init')(s, bar_info)
        local tasklist = require('neconfig.config.bars.statusbar.widgets.tasklist.tasklist_init')(s, bar_info)
        --#endregion


        s.statusbar = {
            sections = {},
            widgets = {}
        }


        --#region Fake wibar
        s.statusbar.wibar = awful.wibar {
            position = bar_info.position,
            screen = s,
            [size_param.thickness] = bar_size,
            [size_param.length] = s.geometry[size_param.length] - bar_info.margin.corners * 2,

            shape = r_rect(bar_info.corner_radius.bar)
        }
        -- Offset the bar
        local offset_prop = (bar_info.position == 'top' or bar_info.position == 'bottom') and 'y' or 'x'
        local offset_dir = (bar_info.position == 'top' or bar_info.position == 'left') and 1 or -1
        s.statusbar.wibar[offset_prop] = s.statusbar.wibar[offset_prop] + offset_dir * bar_info.margin.edge
        -- Modify the area where clients can be placed
        s.statusbar.wibar:struts {
            [bar_info.position] = bar_info.margin.edge + bar_size
        }
        --#endregion

        --#region 1st section
        -- Menu
        add_bar_section {
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
        -- Layout box
        add_bar_section {
            name = 'layoutbox',
            widget = layoutbox,
            position = {
                side = bar_info.position,
                section = 1
            },
            style = section_style,
            screen = s,
            info_table = s.statusbar.sections
        }
        -- Tag list
        add_bar_section {
            name = 'taglist',
            widget = taglist,
            position = {
                side = bar_info.position,
                section = 1
            },
            style = section_style,
            screen = s,
            info_table = s.statusbar.sections
        }
        --#endregion

        --#region 2nd section
        -- Task list
        add_bar_section {
            name = 'tasklist',
            widget = tasklist,
            position = {
                side = bar_info.position,
                section = 2
            },
            style = section_style,
            screen = s,
            info_table = s.statusbar.sections
        }
        --#endregion

        --#region 3rd section
        -- Clock
        add_bar_section {
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
        -- Keyboard layout
        add_bar_section {
            name = 'keyboard_layout',
            widget = keyboard_layout,
            position = {
                side = bar_info.position,
                section = 3
            },
            style = section_style,
            screen = s,
            info_table = s.statusbar.sections
        }

        -- TODO remove this later, test
        local cal = require('neconfig.config.bars.statusbar.widgets.textclock.calendar')
        add_custom_popup {
            name = 'calendar',
            widgets = {
                keyboard_layout,
                cal
            },
            attach = {
                target = s.statusbar.sections[3].clock.popup,
                position = 'bottom',
                anchor = 'middle',
                offset = 10
            },
            size = 'fit',
            style = popup_style,
            screen = s,
            info_table = s.statusbar.widgets
        }
        --#endregion

        --! Test, remove this later (place systray in a better position)
        --[[
        --#region Other
        add_bar_section {
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
        --#endregion
        ]]
    end
)


