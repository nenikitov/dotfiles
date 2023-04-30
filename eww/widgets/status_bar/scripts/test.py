#!/bin/env python

import gi
gi.require_version('Gtk', '3.0')
gi.require_version('Gio', '2.0')
gi.require_version('GdkPixbuf', '2.0')
from gi.repository import Gio, GdkPixbuf, Gtk

custom_theme_name = "Fluent dark"

def get_app_icon_path(app_class, default_icon_name):
    theme = Gtk.IconTheme.new()
    theme.set_custom_theme(custom_theme_name)

    # First, try to get icon path from current theme
    icon_info = theme.lookup_icon(app_class, 48, 0)
    if icon_info:
        return icon_info.get_filename()

    # Next, try to get icon path from application .desktop file
    app_info = Gio.DesktopAppInfo.new(app_class)
    if app_info:
        icon = app_info.get_icon()
        if icon:
            icon_theme = Gtk.IconTheme.get_default()
            icon_info = icon_theme.lookup_by_gicon(icon, 48, Gtk.IconLookupFlags.FORCE_SIZE)
            if icon_info:
                return icon_info.get_filename()

    # Next, try to get icon path from default icon theme
    fallback_theme = Gtk.IconTheme.get_default().get_fallback()
    if fallback_theme:
        icon_info = fallback_theme.lookup_icon(app_class, 48, 0)
        if icon_info:
            return icon_info.get_filename()

    # Finally, return path of default icon if no suitable icon found
    return Gio.ThemedIcon.new(default_icon_name).choose_icon(GdkPixbuf.Pixbuf.new_from_file("/dev/null")).get_filename()

# Example usage
app_class = "pcmanfm.desktop"
default_icon_name = "application-default-icon"
icon_path = get_app_icon_path(app_class, default_icon_name)
print(f"Icon path for {app_class}: {icon_path}")

