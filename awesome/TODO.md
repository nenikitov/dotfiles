# Wibar
## General
- [ ] Set up the correct background and pill colors
- [ ] **?** Set up 2 wibars **OR** reorganize to have all widgets in 1
## Tag list
- [X] Organize tags
- [x] Find icons for tags
## Task list
- [X] Add spacing
- [ ] **?** Making task occupy less space **OR** adapt to the available space
- [ ] Improve active and minimized border
## Language
- [ ] Add an icon
- [ ] Change the color
## Date and time
- [ ] Add an icon
- [ ] Change the color
- [ ] **?** Separate into 2 widgets
## Current layout
- [ ] Change the color
## More widgets
- [ ] Add CPU usage widget
- [ ] Add Internet usage widget
- [ ] Add volume widget
- [ ] Add music player widget

# Client
- [ ] Create rounder border (the one that can use anti-aliasing)
- [ ] Use correct colors

# Titlebar
- [ ] Use correct colors

# Graphics
## Layout
- [ ] Redraw "fair" icons
- [ ] Redraw "floating" icon
- [ ] Redraw "magnifier" icon
- [ ] Redraw "max" icon
- [ ] Redraw "fullscreen" icon
- [ ] Redraw "tile" icons
- [ ] Redraw "spiral" icon
- [ ] Redraw "dwindle" icon
- [ ] Redraw "corner" icons
## Titlebar
- [ ] Redraw "close" icon
- [ ] Redraw "minimize" icon
- [ ] Redraw "maximized" icon
- [ ] Redraw "ontop" icon
- [ ] Redraw "sticky" icon
- [ ] Redraw "floating" icon
## Taglist
- [ ] Redraw "sel" icon
- [ ] Redraw "unsel" icon

# Binds
## Floating workflow
- [ ] Middle click on the taskbar application closes it
- [ ] Dragging fullscreen applications moves it
## Tiling workflow
- [ ] Better cycling
## General
- [ ] More consistent shortcuts

# File structure
```cpp
myconfig
    config
        user
            uservars.lua
        client
            buttons.lua
            init.lua
            keys.lua
            rules.lua
            signals.lua
        globalbind
            buttons.lua
            keys.lua
            tagbind.lua
        bars
            bottombar
                buttons.lua
                keys.lua
                layout.lua
            titlebar
                buttons.lua
                keys.lua
                layout.lua
            topbar
                buttons.lua
                keys.lua
                layout.lua
        main
            autostart.lua
            errorhandling.lua
            tag.lua
----
```
