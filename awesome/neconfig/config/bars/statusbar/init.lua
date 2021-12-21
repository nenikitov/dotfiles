-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
-- Load custom modules
local statusbar_user_conf = require('neconfig.config.user.statusbar_user_conf')
local statusbar_utils = require('neconfig.config.utils.statusbar_utils')
local statusbar_section = require('neconfig.config.utils.statusbar_section')

-- Get variables
-- From configs
local bar_info_theme = beautiful.user_vars_theme.statusbar
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
            wibar = {},
            sections = {},
            popups = {}
        }
        --#endregion


        --#region Background wibar
        statusbar_utils.add_background_bar {
            screen = s,
            sections = s.statusbar.sections,
            info_table = s.statusbar
        }

        --#endregion

        --#region 1st section
        -- Menu
        statusbar_utils.add_bar_section {
            name = 'menu',
            widget = menu,
            section = 1,
            visible = statusbar_user_conf.widgets.menu.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        -- Run menu
        statusbar_utils.add_bar_section {
            name = 'run_menu',
            widget = run_menu,
            section = 1,
            visible = statusbar_user_conf.widgets.run_menu.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        -- Layout box
        statusbar_utils.add_bar_section {
            name = 'layoutbox',
            widget = layoutbox,
            section = 1,
            visible = statusbar_user_conf.widgets.layoutbox.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        -- Tag list
        statusbar_utils.add_bar_section {
            name = 'taglist',
            widget = taglist,
            section = 1,
            visible = statusbar_user_conf.widgets.taglist.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        --#endregion

        --#region 2nd section
        -- Task list
        statusbar_utils.add_bar_section {
            name = 'tasklist',
            widget = tasklist,
            section = 2,
            visible = statusbar_user_conf.widgets.tasklist.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        --#endregion

        --#region 3rd section
        -- Clock
        statusbar_utils.add_bar_section {
            name = 'clock',
            widget = textclock,
            section = 3,
            force_interactive = true,
            visible = statusbar_user_conf.widgets.clock.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        -- Keyboard layout
        statusbar_utils.add_bar_section {
            name = 'keyboard_layout',
            widget = keyboard_layout,
            section = 3,
            visible = statusbar_user_conf.widgets.keyboard_layout.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        statusbar_utils.add_bar_section {
            name = 'notification_center_button',
            widget = notification_center_button,
            section = 3,
            force_interactive = true,
            visible = statusbar_user_conf.widgets.notifications_pane.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        statusbar_utils.add_bar_section {
            name = 'sys_tools_button',
            widget = sys_tools_button,
            force_interactive = true,
            section = 3,
            visible = statusbar_user_conf.widgets.sys_tools.visible,
            screen = s,
            info_table = s.statusbar.sections
        }
        local t = statusbar_section {
            widget = taglist,
            screen = s,
            direction = 'horizontal',
            style = {
                shape = require('gears').shape.rounded_rect,
                bg = '#ff0000',
                padding = 5
            },
            use_real_clip = true
        }
        --#endregion


        --#region Popups that are attached to statusbar
        -- Calendar
        require('neconfig.config.popups.calendar.init') {
            position = {
                target = s.statusbar.sections.all_popups.clock,
                position = bar_param_opposite_side,
                anchor = 'middle',
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
                anchor = 'middle',
            },
            toggle_visibility_widget = s.statusbar.sections.all_popups.sys_tools_button,
            screen = s,
            info_table = s.statusbar.popups
        }
        --#endregion

        -- Set statusbar visibility once all widgets were created
        s.statusbar.wibar.visible = statusbar_user_conf.visible
    end
)
--#endregion
