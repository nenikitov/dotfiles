-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
-- Load custom modules
local user_vars_conf = require('neconfig.config.user.user_vars_conf')
require('neconfig.config.utils.statusbar_utils')

-- Get variables
-- From configs
local bar_info_theme = beautiful.user_vars_theme.statusbar
local bar_info_conf = user_vars_conf.statusbar
-- Popup direction
local bar_param_opposite_side = ({ top = 'bottom', bottom = 'top', left = 'right', right = 'left'})[bar_info_theme.position]
-- Bar size
local bar_size = bar_info_theme.contents_size + bar_info_theme.margin.content * 2
local bar_param_size = {
    length =    (bar_info_theme.position == 'top' or bar_info_theme.position == 'bottom') and 'width'  or 'height',
    thickness = (bar_info_theme.position == 'top' or bar_info_theme.position == 'bottom') and 'height' or 'width',
}
-- Bar offset
local bar_offset_dir = (bar_info_theme.position == 'top' or bar_info_theme.position == 'left') and 1 or -1
local bar_param_offset = (bar_info_theme.position == 'top' or bar_info_theme.position == 'bottom') and 'y' or 'x'

--#region Generate screen independent widgets
local menu = require('neconfig.config.bars.statusbar.widgets.menu.menu_init')(bar_info_theme)
local run_menu = require('neconfig.config.bars.statusbar.widgets.run_menu.run_menu')
local textclock = require('neconfig.config.bars.statusbar.widgets.textclock.textclock_init')(bar_info_theme)
local keyboard_layout = require('neconfig.config.bars.statusbar.widgets.keyboard.keyboard_init')
local notification_center_button = require('neconfig.config.bars.statusbar.widgets.notification_center_button.notification_center_button_init')
local sys_tools_button = require('neconfig.config.bars.statusbar.widgets.sys_tools_button.sys_tools_button_init')
--#endregion


--#region Set up the status bar for each screen
awful.screen.connect_for_each_screen(
    function(s)
        --#region Generate screen specific widgets
        local taglist = require('neconfig.config.bars.statusbar.widgets.taglist.taglist_init')(s, bar_info_theme)
        local layoutbox = require('neconfig.config.bars.statusbar.widgets.layoutbox.layoutbox_init')(s, bar_info_theme)
        local tasklist = require('neconfig.config.bars.statusbar.widgets.tasklist.tasklist_init')(s, bar_info_theme)
        --#endregion

        --#region Init object to store widgets into
        s.statusbar = {
            sections = {},
            popups = {}
        }
        --#endregion


        --#region Background wibar
        s.statusbar.wibar = awful.wibar {
            position = bar_info_theme.position,
            screen = s,
            [bar_param_size.thickness] = bar_size,
            [bar_param_size.length] = s.geometry[bar_param_size.length] - bar_info_theme.margin.corners * 2,

            shape = r_rect(bar_info_theme.corner_radius.bar),
        }
        -- Offset the bar
        s.statusbar.wibar[bar_param_offset] = s.statusbar.wibar[bar_param_offset] + bar_offset_dir * bar_info_theme.margin.edge
        -- Modify the area where clients can be placed
        s.statusbar.wibar:struts {
            [bar_info_theme.position] = bar_info_theme.margin.edge + bar_size
        }
        -- Hide all the widgets inside the wibar if wibar is hidden
        s.statusbar.wibar:connect_signal(
            'property::visible',
            function ()
                local new_visibility = s.statusbar.wibar.visible
                -- Cycle through each widget
                for _, section in pairs(s.statusbar.sections) do
                    for _, popup in pairs(section) do
                        if (popup.visible ~= nil)
                        then
                            popup.visible = new_visibility
                        end
                    end
                end
            end
        )
        --#endregion

        --#region 1st section
        -- Menu
        add_bar_section {
            name = 'menu',
            widget = menu,
            section = 1,
            visible = bar_info_conf.widgets.menu.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        -- Run menu
        add_bar_section {
            name = 'run_menu',
            widget = run_menu,
            section = 1,
            visible = bar_info_conf.widgets.run_menu.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        -- Layout box
        add_bar_section {
            name = 'layoutbox',
            widget = layoutbox,
            section = 1,
            visible = bar_info_conf.widgets.layoutbox.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        -- Tag list
        add_bar_section {
            name = 'taglist',
            widget = taglist,
            section = 1,
            visible = bar_info_conf.widgets.taglist.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        --#endregion

        --#region 2nd section
        -- Task list
        add_bar_section {
            name = 'tasklist',
            widget = tasklist,
            section = 2,
            visible = bar_info_conf.widgets.tasklist.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        --#endregion

        --#region 3rd section
        -- Clock
        add_bar_section {
            name = 'clock',
            widget = textclock,
            section = 3,
            force_interactive = true,
            visible = bar_info_conf.widgets.clock.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        -- Keyboard layout
        add_bar_section {
            name = 'keyboard_layout',
            widget = keyboard_layout,
            section = 3,
            visible = bar_info_conf.widgets.keyboard_layout.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        add_bar_section {
            name = 'notification_center_button',
            widget = notification_center_button,
            section = 3,
            force_interactive = true,
            visible = bar_info_conf.widgets.notifications_pane.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        add_bar_section {
            name = 'sys_tools_button',
            widget = sys_tools_button,
            force_interactive = true,
            section = 3,
            visible = bar_info_conf.widgets.sys_tools.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        --#endregion


        --#region Popups that are attached to statusbar
        -- Calendar
        require('neconfig.config.popups.calendar.init') {
            position = {
                target = s.statusbar.sections.all_popups.clock,
                position = bar_param_opposite_side,
                anchor = 'back',
            },
            toggle_visibility_widget = s.statusbar.sections.all_popups.clock,
            screen = s,
            info_table = s.statusbar.popups
        }
        -- Notifications pane
        -- TODO Add notifications pane
        -- System tools
        require('neconfig.config.popups.sys_tools.init') {
            position = {
                target = s.statusbar.sections.all_popups.sys_tools_button,
                position = bar_param_opposite_side,
                anchor = 'back',
            },
            toggle_visibility_widget = s.statusbar.sections.all_popups.sys_tools_button,
            screen = s,
            info_table = s.statusbar.popups
        }
        --#endregion

        -- Set statusbar visibility once all widgets were created
        s.statusbar.wibar.visible = bar_info_conf.visible
    end
)
--#endregion
