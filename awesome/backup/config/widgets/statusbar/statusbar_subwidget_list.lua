local statusbar_subwidget_list = {
    menu = require('neconfig.config.widgets.statusbar.subwidgets.menu.menu_init'),
    run_menu = require('neconfig.config.widgets.statusbar.subwidgets.run_menu.run_menu_init'),
    layout_box = require('neconfig.config.widgets.statusbar.subwidgets.layoutbox.layoutbox_init'),
    tag_list = require('neconfig.config.widgets.statusbar.subwidgets.taglist.taglist_init'),
    task_list = require('neconfig.config.widgets.statusbar.subwidgets.tasklist.tasklist_init'),
    keyboard = require('neconfig.config.widgets.statusbar.subwidgets.keyboard.keyboard_init'),
    notification_center = require('neconfig.config.widgets.statusbar.subwidgets.notification_center_button.notification_center_button_init'),
    system_tools = require('neconfig.config.widgets.statusbar.subwidgets.sys_tools_button.sys_tools_button_init'),
    text_clock = require('neconfig.config.widgets.statusbar.subwidgets.textclock.textclock_init')
}

return statusbar_subwidget_list
