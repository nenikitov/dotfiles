-- Load libraries
local awful = require('awful')
local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi
local theme_assets = require('beautiful.theme_assets')
local gfs = require('gears.filesystem')
-- Load custom modules
local user_look_desktop = require('neconfig.user.look.user_look_desktop')
local user_look_apps = require('neconfig.user.look.user_look_apps')
local user_look_colors = require('neconfig.user.look.user_look_colors')
local user_look_titlebar_widgets = require('neconfig.user.look.widgets.user_look_titlebar_widgets')

-- Get variables
local themes_path = gfs.get_themes_dir()
local config_path = awful.util.getdir('config') .. '/neconfig/'


-- Container for values
local theme = {}

theme.font          = user_look_desktop.font .. ' ' .. user_look_desktop.font_size

theme.bg_normal     = '#222222'
theme.bg_focus      = '#535d6c'
theme.bg_urgent     = '#ff0000'
theme.bg_minimize   = '#444444'
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = '#aaaaaa'
theme.fg_focus      = '#ffffff'
theme.fg_urgent     = '#ffffff'
theme.fg_minimize   = '#ffffff'

theme.useless_gap   = user_look_desktop.gaps

theme.titlebar_bg = user_look_colors.classes.normal.bg

-- Borders
theme.border_width = user_look_apps.border.width.border

for border_type, color in pairs(user_look_apps.border.colors) do
    theme['border_color_' .. border_type] = color
end



-- theme.tasklist_plain_task_name = not statusbar_user_conf.widgets.tasklist.show_task_props
-- theme.tasklist_disable_task_name = not statusbar_user_conf.widgets.tasklist.show_task_title

theme.tasklist_sticky = '▪ '
theme.tasklist_ontop = '^ '
theme.tasklist_above = '▴ '
theme.tasklist_below = '▾ '
theme.tasklist_floating = '✈ '
theme.tasklist_maximized = '+ '
theme.tasklist_maximized_horizontal = '⬌ '
theme.tasklist_maximized_vertical = '⬍ '

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = '#ff0000'

-- Generate taglist squares:
--[[
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)
]]

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path..'default/submenu.png'
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = '#cc0000'

-- Define the image to load

--#region Titlebar icons
-- TODO move to separate file
local gears = require('gears')
local cairo = require('lgi').cairo
local rsvg = require('lgi').Rsvg
local user_look_titlebar_widgets = require('neconfig.user.look.widgets.user_look_titlebar_widgets')
local icon_scale = 0.5
local titlebar_icon_path = config_path .. '/graphics/icons/titlebar/'
local titlebar_button_size = 64
local function generate_titlebar_icon(icon_path, shape_props, size)
    -- Draw background
    local img = cairo.ImageSurface(cairo.Format.ARGB32, size, size)
    local cr = cairo.Context(img)

    cr:set_source(gears.color('#00000000'))
    cr:paint()


    -- Draw shape
    local bw = shape_props.border_width
    cr:translate(bw, bw)
    shape_props.shape(cr, size - 2 * bw, size - 2 * bw)
    -- Fill
    cr:set_source(gears.color(shape_props.shape_bg))
    cr:fill_preserve()
    -- Border
    cr:set_line_width(bw)
    cr:set_source(gears.color(shape_props.border_color))
    cr:stroke()

    -- Draw icon
    local real_icon_size = size * icon_scale
    local _, icon_h = gears.surface.get_size(gears.surface.load(icon_path))
    local cr_scale = real_icon_size / icon_h
    cr:translate(-bw, -bw)
    cr:translate(
        (size - real_icon_size) / 2,
        (size - real_icon_size) / 2
    )
    cr:scale(cr_scale, cr_scale)
    local icon_mask = cairo.ImageSurface(cairo.Format.ARGB32, size, size)
    rsvg.Handle.new_from_file(icon_path):render_cairo(cairo.Context(icon_mask))
    cr:set_source(gears.color(shape_props.icon))
    cr:mask(cairo.Pattern.create_for_surface(icon_mask), 0, 0)


    return img
end
local function set_up_simple_button(icon, state)
    -- Normal
    theme['titlebar_' .. icon .. '_button_normal'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '.svg',
        user_look_titlebar_widgets.buttons[icon][state].normal,
        titlebar_button_size
    )
    -- Focus
    theme['titlebar_' .. icon .. '_button_focus'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '.svg',
        user_look_titlebar_widgets.buttons[icon][state].focus,
        titlebar_button_size
    )
    -- Press
    theme['titlebar_' .. icon .. '_button_focus_press'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '.svg',
        user_look_titlebar_widgets.buttons[icon][state].press,
        titlebar_button_size
    )
    theme['titlebar_' .. icon .. '_button_normal_press'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '.svg',
        user_look_titlebar_widgets.buttons[icon][state].press,
        titlebar_button_size
    )
    -- Hover
    theme['titlebar_' .. icon .. '_button_focus_hover'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '.svg',
        user_look_titlebar_widgets.buttons[icon][state].hover,
        titlebar_button_size
    )
    theme['titlebar_' .. icon .. '_button_focus_hover'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '.svg',
        user_look_titlebar_widgets.buttons[icon][state].hover,
        titlebar_button_size
    )
end
local function set_up_state_button(icon)
    -- Normal
    theme['titlebar_' .. icon .. '_button_normal_active'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '_active.svg',
        user_look_titlebar_widgets.buttons[icon].active.normal,
        titlebar_button_size
    )
    -- Focus
    theme['titlebar_' .. icon .. '_button_focus_active'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '_active.svg',
        user_look_titlebar_widgets.buttons[icon].active.focus,
        titlebar_button_size
    )
    -- Press
    theme['titlebar_' .. icon .. '_button_focus_active_press'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '_active.svg',
        user_look_titlebar_widgets.buttons[icon].active.press,
        titlebar_button_size
    )
    theme['titlebar_' .. icon .. '_button_normal_active_press'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '_active.svg',
        user_look_titlebar_widgets.buttons[icon].active.press,
        titlebar_button_size
    )
    -- Hover
    theme['titlebar_' .. icon .. '_button_focus_active_hover'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '_active.svg',
        user_look_titlebar_widgets.buttons[icon].active.hover,
        titlebar_button_size
    )
    theme['titlebar_' .. icon .. '_button_focus_active_hover'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '_active.svg',
        user_look_titlebar_widgets.buttons[icon].active.hover,
        titlebar_button_size
    )

    -- Normal
    theme['titlebar_' .. icon .. '_button_normal_inactive'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '_inactive.svg',
        user_look_titlebar_widgets.buttons[icon].inactive.normal,
        titlebar_button_size
    )
    -- Focus
    theme['titlebar_' .. icon .. '_button_focus_inactive'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '_inactive.svg',
        user_look_titlebar_widgets.buttons[icon].inactive.focus,
        titlebar_button_size
    )
    -- Press
    theme['titlebar_' .. icon .. '_button_focus_inactive_press'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '_inactive.svg',
        user_look_titlebar_widgets.buttons[icon].inactive.press,
        titlebar_button_size
    )
    theme['titlebar_' .. icon .. '_button_normal_inactive_press'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '_inactive.svg',
        user_look_titlebar_widgets.buttons[icon].inactive.press,
        titlebar_button_size
    )
    -- Hover
    theme['titlebar_' .. icon .. '_button_focus_inactive_hover'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '_inactive.svg',
        user_look_titlebar_widgets.buttons[icon].inactive.hover,
        titlebar_button_size
    )
    theme['titlebar_' .. icon .. '_button_focus_inactive_hover'] = generate_titlebar_icon(
        titlebar_icon_path .. icon .. '_inactive.svg',
        user_look_titlebar_widgets.buttons[icon].inactive.hover,
        titlebar_button_size
    )
end
-- Close
set_up_simple_button('close', 'active')
-- Maximize
set_up_state_button('maximized')
-- Minimize
set_up_simple_button('minimize', 'inactive')
-- On top
set_up_state_button('ontop')
-- Floating
set_up_state_button('floating')
-- Sticky
set_up_state_button('sticky')
--#endregion

-- theme.titlebar_maximized_button_focus_inactive = config_path .. 'graphics/icons/maximize_inactive.png'



theme.wallpaper = themes_path..'default/background.png'

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path..'default/layouts/fairhw.png'
theme.layout_fairv = themes_path..'default/layouts/fairvw.png'
theme.layout_floating  = themes_path..'default/layouts/floatingw.png'
theme.layout_magnifier = themes_path..'default/layouts/magnifierw.png'
theme.layout_max = themes_path..'default/layouts/maxw.png'
theme.layout_fullscreen = themes_path..'default/layouts/fullscreenw.png'
theme.layout_tilebottom = themes_path..'default/layouts/tilebottomw.png'
theme.layout_tileleft   = themes_path..'default/layouts/tileleftw.png'
theme.layout_tile = themes_path..'default/layouts/tilew.png'
theme.layout_tiletop = themes_path..'default/layouts/tiletopw.png'
theme.layout_spiral  = themes_path..'default/layouts/spiralw.png'
theme.layout_dwindle = themes_path..'default/layouts/dwindlew.png'
theme.layout_cornernw = themes_path..'default/layouts/cornernww.png'
theme.layout_cornerne = themes_path..'default/layouts/cornernew.png'
theme.layout_cornersw = themes_path..'default/layouts/cornersww.png'
theme.layout_cornerse = themes_path..'default/layouts/cornersew.png'

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)
theme.system_icon = config_path .. 'graphics/icons/system_logo.svg'

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = user_look_desktop.gtk_icon_theme

return theme
