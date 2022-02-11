-- Load libraries
local t_widget = require('awful').titlebar.widget

local titlebar_subwidget_list = {
    -- Icon of the client
    icon = t_widget.iconwidget,
    -- Name of the client
    title = t_widget.titlewidget,

    -- Button for closing the client
    close = t_widget.closebutton,
    -- Button for maximizing the client
    maximize = t_widget.maximizedbutton,
    -- Button for minimizing the client
    minimize = t_widget.minimizebutton,
    -- Button for making the client display on top of other clients
    on_top = t_widget.ontopbutton,
    -- Button for toggling floating mode
    floating = t_widget.floatingbutton,
    -- Button for making the client display on all tags
    sticky = t_widget.stickybutton
}

return titlebar_subwidget_list
