#!/bin/env python

import pywayland.client as wl
import pywayland.protocol as wp

# Connect to the Wayland compositor
client = wl.Client()
display = client.display
registry = wp.Registry(display)

# Wait for the registry to be populated
registry.sync()
if 'zwlr_foreign_toplevel_manager_v1' not in registry.interfaces:
    raise RuntimeError('The Wayland compositor does not support the wlr-foreign-toplevel-management protocol')
if 'zwlr_layer_shell_v1' not in registry.interfaces:
    raise RuntimeError('The Wayland compositor does not support the wlr-layer-shell protocol')

# Get the foreign toplevel manager and layer shell globals
foreign_toplevel_manager_global = registry.bind(
    registry.bindings['zwlr_foreign_toplevel_manager_v1'][0],
    registry.bindings['zwlr_foreign_toplevel_manager_v1'][1],
    wp.ZwlrForeignToplevelManagerV1)
layer_shell_global = registry.bind(
    registry.bindings['zwlr_layer_shell_v1'][0],
    registry.bindings['zwlr_layer_shell_v1'][1],
    wp.ZwlrLayerShellV1)

# Get the list of toplevels from the foreign toplevel manager
toplevels = foreign_toplevel_manager_global.get_toplevels()
for toplevel in toplevels:
    # Get the surface and title of the toplevel
    surface = toplevel.get_surface()
    title = surface.get_title()

    # Get the layer surface of the toplevel
    layer_surface = layer_shell_global.get_layer_surface(surface)
    layer_surface.set_anchor(wp.ZwlrLayerShellV1.Anchor.TOP | wp.ZwlrLayerShellV1.Anchor.LEFT)

    # Get the window icon of the toplevel
    window_icon = surface.get_window_icon()

    if window_icon is not None:
        # Write the icon to a file
        with open(f'{title}.png', 'wb') as f:
            f.write(window_icon.get_data())
