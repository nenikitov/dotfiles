-- Monitors
hl.monitor({
  output = '',
  mode = 'preferred',
  position = 'auto-right',
  scale = 1,
})
hl.monitor({
  output = 'DP-4',
  mode = '1920x1080@144',
  position = '0x0',
})

hl.monitor({
  output = 'HDMI-A-2',
  mode = '1920x1080@75',
  position = 'auto-right',
})

-- Environment
hl.env("XCURSOR_SIZE", 24)
hl.env("HYPRCURSOR_SIZE", 24)

hl.config({
  ecosystem = {
    no_update_news = true,
    no_donation_nag = true,
  },
  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
  },
})

-- Layout
hl.config({
  general = { layout = "scrolling" },
  dwindle = { preserve_split = true },
  master = { new_status = "master" },
})

-- Focus
hl.config({
  general = {
    resize_on_border = true,
  },
})

-- Keyboard
hl.config({
  input = { numlock_by_default = true }
})

-- Mouse
-- TODO: Figure out how to apply settings to all mice and not affect other cursor devices
hl.config({
  input = {
    accel_profile = 'flat',
    sensitivity = 0,
  }
})

-- Touchpad
hl.config({
  input = {
    touchpad = {
      disable_while_typing = false,
      natural_scroll = true,
    }
  }
})

-- Gaps
hl.config({
  general = {
    gaps_in = 4,
    gaps_out = 8,
  },
})

-- Corners
hl.config({
  decoration = {
    rounding = 4
  }
})

-- Border
hl.config({
  general = {
    border_size = 2,
    col = {
      active_border = {
        colors = {
          "rgb(DA5261)",
          "rgb(DB8878)",
        },
        angle = 90,
      },
      inactive_border = {
        colors = {
          "rgb(555A66)",
          "rgb(20232B)",
        },
        angle = 90,
      }
    }
  }
})
hl.window_rule({
  name = "border_color_on_fullscreen",
  match = { fullscreen = true, focus = true },
  border_color = {
    colors = {
      "rgb(00FFFF)",
    },
    angle = 90,
  },
})

-- Blur
hl.config({
  decoration = {
    blur = {
      size = 8,
      passes = 4,
      noise = 0,
    }
  }
})

-- Shadow
hl.config({
  decoration = {
    shadow = {
      range = 10,
      offset = { 0, 0 }
    }
  }
})

-- Groupbar
hl.config({
  group = {
    auto_group = false,
    groupbar = {
      render_titles = false,
      round_only_edges = false,
      stacked = true,
      gaps_out = 4,
      keep_upper_gap = false,
    }
  }
})

-- Animations
hl.animation({ enabled = true, leaf = "global", speed = 2, bezier = "default" })
hl.animation({ enabled = true, leaf = "windows", speed = 2, bezier = "default", style = "popin 80%" })
hl.animation({ enabled = true, leaf = "workspaces", speed = 2, bezier = "default", style = "slidevert" })

-- Binds
hl.config({
  general = {
    no_focus_fallback = true,
  },
  binds = {
    window_direction_monitor_fallback = false,
  }
})

local key_workspace = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
local key_monitor = {l = "Y", d = "U", u = "I", r = "O"}
local key_window = {l = "H", d = "J", u = "K", r = "L"}

local mod = "SUPER"

local terminal = "alacritty"
local launcher = "rofi -show drun"

local function bind(keys, dispatcher, flags)
  hl.bind(
    table.concat(keys, " + "),
    dispatcher,
    flags or {}
  )
end

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "scroll_move",
})

-- System
-- TODO: Mod+Q to lock
bind({mod, "SHIFT", "Q"}, hl.dsp.exit()) -- TODO: Use hyprshutdown
bind({mod, "C"}, hl.dsp.window.close())
-- Spawn
bind({mod, "Return"}, hl.dsp.exec_cmd(terminal))
bind({mod, "SHIFT", "Return"}, hl.dsp.exec_cmd(launcher))
-- Monitor focus / move
for dir, key in pairs(key_monitor) do
  bind({mod, key}, hl.dsp.focus { monitor = dir }, { repeating = true })
  bind({mod, "SHIFT", key}, hl.dsp.window.move { monitor = dir }, { repeating = true })
end
-- Workspace focus / move
bind({mod, "mouse_down"}, hl.dsp.focus { workspace = "r-1" })
bind({mod, "mouse_up"}, hl.dsp.focus { workspace = "r+1" })
hl.gesture({
  fingers = 3,
  direction = "vertical",
  action = "workspace",
})
for i, key in ipairs(key_workspace) do
  bind({mod, key}, hl.dsp.focus { workspace = "r~" .. i})
  bind({mod, "SHIFT", key}, hl.dsp.window.move { workspace = "r~" .. i, follow = false})
end
-- Window focus / move
bind({mod, "mouse_left"}, hl.dsp.focus{ direction = "l" })
bind({mod, "SHIFT", "mouse_down"}, hl.dsp.focus{ direction = "l" })
bind({mod, "mouse_right"}, hl.dsp.focus{ direction = "r" })
bind({mod, "SHIFT", "mouse_up"}, hl.dsp.focus{ direction = "r" })
bind({mod, "mouse:272"}, hl.dsp.window.drag(), { mouse = true })
bind({mod, "mouse:273"}, hl.dsp.window.resize(), { mouse = true })
bind({mod, "G"}, hl.dsp.group.toggle())
for dir, key in pairs(key_window) do
  bind({mod, key}, function()
    local window = hl.get_active_window()
    if not window then return end

    if window.group
      and ((dir == "u" and window.group.current_index ~= 1)
      or (dir == "d" and window.group.current_index ~= window.group.size))
    then
      local target = dir == "u" and hl.dsp.group.prev() or hl.dsp.group.next()
      hl.dispatch(target)
    else
      hl.dispatch(hl.dsp.focus {direction = dir})
    end
  end, {repeating = true})
  bind(
    {mod, "SHIFT", key},
    function()
      local window = hl.get_active_window()
      if not window then return end

      if window.floating then
        local factor = 20
        local x = (dir == "l" and -factor) or (dir == "r" and factor) or 0
        local y = (dir == "u" and -factor) or (dir == "d" and factor) or 0
        hl.dispatch(hl.dsp.window.move{x = x, y = y, relative = true})
      elseif
        window.group
        and ((dir == "u" and window.group.current_index ~= 1)
        or (dir == "d" and window.group.current_index ~= window.group.size))
      then
        local target = dir == "u" and hl.dsp.group.move_window{forward = false} or hl.dsp.group.move_window{forward = true}
        hl.dispatch(target)
      elseif not window.group and window.workspace.tiled_layout == "scrolling" and (dir == "l" or dir == "r") then
        local target = dir == "l" and "prev" or "next"
        hl.dispatch(hl.dsp.layout("consume_or_expel " .. target))
      elseif window.group and window.workspace.tiled_layout == "scrolling" then
        -- TODO: group_aware move direction is borked in scrolling layout and always generates a column on the right
        -- if dir == "l" or dir == "r" then
        --   hl.dispatch(hl.dsp.window.move {out_of_group = "r"})
        --   if dir == "l" then hl.dispatch(hl.dsp.layout("swapcol l")) end
        -- else
        --   local below = {}
        --   for _, w in ipairs(window.workspace:get_windows()) do
        --     if not w.floating and window.at.x == w.at.x and window.at.y < w.at.y then
        --       below[w.at.y] = true
        --     end
        --   end

        --   hl.dispatch(hl.dsp.window.move{direction = "r", group_aware = true})
        --   hl.dispatch(hl.dsp.layout("consume_or_expel prev"))
        --   for _, _ in pairs(below) do
        --     hl.dispatch(hl.dsp.window.move{direction = "u"})
        --   end
        --   if dir == "u" then
        --     hl.dispatch(hl.dsp.window.move{direction = "u"})
        --   end
        -- end
      else
        hl.dispatch(hl.dsp.window.move{direction = dir, group_aware = true})
      end
    end,
    {repeating = true}
  )
end
-- Window resize
bind({mod, "R"}, hl.dsp.layout("colresize +conf"))
bind({mod, "SHIFT", "R"}, hl.dsp.layout("fit visible"))
bind({mod, "F"}, function ()
  local window = hl.get_active_window()
  if not window then return end

  if not window.floating and window.workspace.tiled_layout == "scrolling" then
    local width = window.size.x / window.monitor.width <= 0.95 and "1.0" or hl.get_config("scrolling.column_width")
    hl.dispatch(hl.dsp.layout("colresize " .. width))
  else
    hl.dispatch(hl.dsp.window.fullscreen({ mode = "maximized" }))
  end
end)
bind({mod, "SHIFT", "F"}, hl.dsp.window.fullscreen({ mode = "fullscreen" }))
