-- Load libraries
local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')
-- Load custom modules
local statusbar_user_conf = require('neconfig.config.user.statusbar_user_conf')
local widget_user_conf = require('neconfig.config.user.widget_user_conf')
local statusbar_theme_conf = beautiful.user_vars_theme.statusbar
local statusbar_subwidget_list = require('neconfig.config.widgets.statusbar.statusbar_subwidget_list')
local statusbar_bar = require('neconfig.config.widgets.statusbar.utils.statusbar_bar')
local widget_utils = require('neconfig.config.utils.widget_utils')
local popup_widget = require('neconfig.config.widgets.popups.utils.popup_widget')


local function set_up_taglist(screen, position)
    local direction =
        (position == 'top' or position == 'bottom')
        and 'horizontal' or 'vertical'
    local flip_decorations =
        (position == 'bottom' or position == 'right')
    local taglist_theme_conf = statusbar_theme_conf.widgets.taglist
    local taglist_user_conf = widget_user_conf.statusbar.taglist
    local taglist_args = {
        direction = direction,
        flip_decorations = flip_decorations,
        decoration_size = taglist_theme_conf.decoration_size,
        number = taglist_user_conf.number,
        client_count = taglist_user_conf.client_count,
        tag_spacing = taglist_theme_conf.spacing,
        tag_padding = taglist_theme_conf.padding,
        max_client_count = taglist_theme_conf.max_client_count
    }

    return statusbar_subwidget_list.tag_list(screen, taglist_args)
end

local function set_up_tasklist(screen, position)
    local direction =
        (position == 'top' or position == 'bottom')
        and 'horizontal' or 'vertical'
    local flip_decorations =
        (position == 'bottom' or position == 'right')
    local tasklist_theme_conf = statusbar_theme_conf.widgets.tasklist
    local tasklist_user_conf = widget_user_conf.statusbar.tasklist
    local tasklist_args = {
        direction = direction,
        flip_decorations = flip_decorations,
        decoration_size = tasklist_theme_conf.decoration_size,
        center_name = not (tasklist_user_conf.task_props or tasklist_user_conf.task_title),
        task_spacing = tasklist_theme_conf.spacing,
        task_padding = tasklist_theme_conf.padding,
        task_size = tasklist_theme_conf.task_size,
        max_size = tasklist_theme_conf.max_size
    }

    return statusbar_subwidget_list.task_list(screen, tasklist_args)
end

local function set_up_clock(screen)
    local textclock_theme_conf = statusbar_theme_conf.widgets.clock
    local textclock_user_conf = widget_user_conf.statusbar.clock
    local textclock_args = {
        direction = textclock_theme_conf.direction,
        primary_format = textclock_user_conf.primary_format,
        primary_size = textclock_theme_conf.primary_size,
        primary_weight = textclock_theme_conf.primary_weight,
        secondary_format = textclock_user_conf.secondary_format,
        secondary_size = textclock_theme_conf.secondary_size,
        secondary_weight = textclock_theme_conf.secondary_weight
    }

    return statusbar_subwidget_list.text_clock(textclock_args)
end

local function set_up_widget(screen, position, widget)
    if type(widget) == 'function' then
        if widget == statusbar_subwidget_list.tag_list then
            return set_up_taglist(screen, position)
        elseif widget == statusbar_subwidget_list.task_list then
            return set_up_tasklist(screen, position)
        elseif widget == statusbar_subwidget_list.text_clock then
            return set_up_clock(screen)
        else
            return widget(screen)
        end
    else
        return widget
    end
end

local function set_up_widget_list(screen, position, widget_list)
    local widgets = {}

    for index, widget in ipairs(widget_list) do
        widgets[index] = set_up_widget(screen, position, widget)
    end

    return widgets
end


--#region Set up the status bar for each screen
awful.screen.connect_for_each_screen(
    function(s)
        local position = statusbar_theme_conf.position

    -- Create the wibox
    s.mywibox = awful.wibar({ position = 'top', screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            set_up_widget(s, 'top', statusbar_subwidget_list.menu),
            set_up_widget(s, 'top', statusbar_subwidget_list.layout_box),
            set_up_widget(s, 'top', statusbar_subwidget_list.tag_list),
        },
        set_up_widget(s, 'top', statusbar_subwidget_list.task_list),
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            set_up_widget(s, 'top', statusbar_subwidget_list.keyboard),
            wibox.widget.systray(),
            set_up_widget(s, 'top', statusbar_subwidget_list.text_clock),
        },
    }

        --[[
        s.statusbar = statusbar_bar {
            front_widgets = set_up_widget_list(
                s, position,
                statusbar_user_conf.layout.front
            ),
            middle_widgets = set_up_widget_list(
                s, position,
                statusbar_user_conf.layout.middle
            ),
            back_widgets = set_up_widget_list(
                s, position,
                statusbar_user_conf.layout.back
            ),
            position = position,
            contents_size = statusbar_theme_conf.contents_size,
            style = {
                bg = statusbar_theme_conf.colors.bg_bar,
                margins = statusbar_theme_conf.margins,
                padding = statusbar_theme_conf.padding
            },
            section_style = {
                spacing = statusbar_theme_conf.spacing
            },
            widget_style = {
                bg = statusbar_theme_conf.colors.bg_sections,
                padding = statusbar_theme_conf.corner_radius.sections,
                shape = widget_utils.r_rect(statusbar_theme_conf.corner_radius.sections)
            },
            use_real_clip = statusbar_theme_conf.real_clip.bar,
            section_use_real_clip = statusbar_theme_conf.real_clip.sections,
            shape = widget_utils.r_rect(statusbar_theme_conf.corner_radius.bar),
            screen = s
        }

        --[[
        popup_widget {
            screen = s,
            widgets = {
                statusbar_subwidget_list.keyboard,
                statusbar_subwidget_list.run_menu,
                set_up_clock(s)
            },
            visible = true
        }
        ]]
    end
)








        --[[
        --#region Generate screen specific widgets
        local bar_direction =
            (bar_info_theme.position == 'top' or bar_info_theme.position == 'bottom')
            and 'horizontal' or 'vertical'
        local flip_widget_decorations =
            (bar_info_theme.position == 'bottom' or bar_info_theme.position == 'right')
        -- Taglist
        local taglist_theme_conf = bar_info_theme.widgets.taglist
        local taglist_user_conf = widget_user_conf.statusbar.taglist
        local taglist_args = {
            direction = bar_direction,
            flip_decorations = flip_widget_decorations,
            decoration_size = taglist_theme_conf.decoration_size,
            number = taglist_user_conf.number,
            client_count = taglist_user_conf.client_count,
            -- TODO move to separate file
            tag_spacing = taglist_theme_conf.spacing,
            tag_padding = taglist_theme_conf.padding,
            max_client_count = taglist_theme_conf.max_client_count
        }
        -- Tasklist
        local tasklist_theme_conf = bar_info_theme.widgets.tasklist
        local tasklist_user_conf = widget_user_conf.statusbar.tasklist
        local tasklist_args = {
            direction = bar_direction,
            flip_decorations = flip_widget_decorations,
            decoration_size = tasklist_theme_conf.decoration_size,
            -- TODO move to separate file
            center_name = not (tasklist_user_conf.show_task_props or tasklist_user_conf.show_task_title),
            task_spacing = tasklist_theme_conf.spacing,
            task_padding = tasklist_theme_conf.padding,
            task_size = tasklist_theme_conf.task_size,
            max_size = tasklist_theme_conf.max_size
        }
        -- Text clock
        local textclock_theme_conf = bar_info_theme.widgets.clock
        local textclock_user_conf = widget_user_conf.statusbar.clock
        local textclock_args = {
            direction = textclock_theme_conf.direction,
            primary_format = textclock_user_conf.primary_format,
            primary_size = textclock_theme_conf.primary_size,
            primary_weight = textclock_theme_conf.primary_weight,
            secondary_format = textclock_user_conf.secondary_format,
            secondary_size = textclock_theme_conf.secondary_size,
            secondary_weight = textclock_theme_conf.secondary_weight
        }
        local taglist = require('neconfig.config.widgets.statusbar.subwidgets.taglist.taglist_init')(s, taglist_args)
        local tasklist = require('neconfig.config.widgets.statusbar.subwidgets.tasklist.tasklist_init')(s, tasklist_args)
        local textclock = require('neconfig.config.widgets.statusbar.subwidgets.textclock.textclock_init')(textclock_args)

        local layoutbox = require('neconfig.config.widgets.statusbar.subwidgets.layoutbox.layoutbox_init')(s)
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
            visible = true,
            screen = s,
            info_table = s.statusbar.sections
        }
        -- Run menu
        statusbar_utils.add_bar_section {
            name = 'run_menu',
            widget = run_menu,
            section = 1,
            visible = true,
            screen = s,
            info_table = s.statusbar.sections
        }
        -- Layout box
        statusbar_utils.add_bar_section {
            name = 'layoutbox',
            widget = layoutbox,
            section = 1,
            visible = true,
            screen = s,
            info_table = s.statusbar.sections
        }
        -- Tag list
        statusbar_utils.add_bar_section {
            name = 'taglist',
            widget = taglist,
            section = 1,
            visible = true,
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
            visible = true,
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
            visible = true,
            screen = s,
            info_table = s.statusbar.sections
        }
        -- Keyboard layout
        statusbar_utils.add_bar_section {
            name = 'keyboard_layout',
            widget = keyboard_layout,
            section = 3,
            visible = true,
            screen = s,
            info_table = s.statusbar.sections
        }
        statusbar_utils.add_bar_section {
            name = 'notification_center_button',
            widget = notification_center_button,
            section = 3,
            force_interactive = true,
            visible = true,
            screen = s,
            info_table = s.statusbar.sections
        }
        statusbar_utils.add_bar_section {
            name = 'sys_tools_button',
            widget = sys_tools_button,
            force_interactive = true,
            section = 3,
            visible = true,
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
]]
--#endregion
