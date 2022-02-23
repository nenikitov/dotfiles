-- Load custom modules
local titlebar_subwidget_list = require('neconfig.config.widgets.titlebar.titlebar_subwidget_list')


-- ▀█▀ █ ▀█▀ █   █▀▀ █▄▄ ▄▀█ █▀█
--  █  █  █  █▄▄ ██▄ █▄█ █▀█ █▀▄
local titlebar = {
    -- Position of the titlebar of the client
    position = 'top',
    -- Visible by default (if hidden can still be toggled with the shortcut)
    visible = true,
    -- Sub widgets
    layout = {
        -- Start of the bar (left for the top titlebar)
        beginning = {
            titlebar_subwidget_list.icon,
        },
        -- Center of the bar (middle for the top titlebar)
        center = {
            titlebar_subwidget_list.title,
        },
        -- End of the bar (right for the top titlebar)
        ending = {
            titlebar_subwidget_list.close,
            titlebar_subwidget_list.maximize,
            titlebar_subwidget_list.minimize,
            titlebar_subwidget_list.on_top,
            titlebar_subwidget_list.floating,
        }
    }
}

return titlebar
