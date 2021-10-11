-- Load modules
local wibox = require('wibox')
local beautiful = require('beautiful')


-- Get style variables
local font = beautiful.font
local styles = {}
styles.month   = { padding      = 5,
                   bg_color     = "#555555",
                   border_width = 2,
                   shape        = r_rect(10)
}
styles.normal  = { shape    = r_rect(5) }
styles.focus   = { fg_color = "#000000",
                   bg_color = "#ff9800",
                   markup   = function(t) return '<b>' .. t .. '</b>' end,
                   shape    = r_rect(5)
}
styles.header  = { fg_color = "#de5e1e",
                   markup   = function(t) return '<b>' .. t .. '</b>' end,
                   shape    = r_rect(10)
}
styles.weekday = { fg_color = "#7788af",
                   markup   = function(t) return '<b>' .. t .. '</b>' end,
                   shape    = r_rect(5)
}
local function decorate_cell(widget, flag, date)
    if flag=="monthheader" and not styles.monthheader then
        flag = "header"
    end
    local props = styles[flag] or {}
    if props.markup and widget.get_text and widget.set_markup then
        widget:set_markup(props.markup(widget:get_text()))
    end
    -- Change bg color for weekends
    local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
    local weekday = tonumber(os.date("%w", os.time(d)))
    local default_bg = (weekday==0 or weekday==6) and "#232323" or "#383838"
    local ret = wibox.widget {
        {
            widget,
            margins = (props.padding or 2) + (props.border_width or 0),
            widget  = wibox.container.margin
        },
        shape        = props.shape,
        border_color = props.border_color or "#b9214f",
        border_width = props.border_width or 0,
        fg           = props.fg_color or "#999999",
        bg           = props.bg_color or default_bg,
        widget       = wibox.container.background
    }
    return ret
end

return wibox.widget {
    date = os.date('*t'),
    font = font,
    spacing = 10,
    week_numbers = false,
    start_sunday = false,
    long_weekdays = false,
    fn_embed = decorate_cell,
    widget = wibox.widget.calendar.month
}
