local function ternary(...)
  local args = table.pack(...)

  if args.n == 0 then error("No default case", 2) end

  for i = 1, args.n do
    local arg = args[i]

    -- Reached last default case
    if i == args.n then return arg end

    if type(arg) ~= "table" or next(arg, 2) ~= nil then error(string.format("Argument %d is not a table { condition, value }", i), 2) end
    if arg[1] then return arg[2] end
  end
end

local function switch(value, ...)
  local args = table.pack(...)

  if args.n == 0 then error("No default case", 2) end

  for i = 1, args.n do
    local arg = args[i]

    -- Reached last default case
    if i == args.n then return arg end

    if type(arg) ~= "table" or next(arg, 2) ~= nil then error(string.format("Argument %d is not a table { case, value }", i), 2) end
    if arg[1] == value then return arg[2] end
  end
end

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
  scrolling = {
    direction = "right"
  }
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
      indicator_height = 2,
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

local function get_layout_and_group_directions()
  local workspace = hl.get_active_workspace()
  if not workspace then return end

  local layout, group = {"l", "r"}, {"u", "d"}

  if workspace.tiled_layout == "scrolling" then
    local dir = hl.get_config("scrolling.direction")
    if dir == "up" or dir == "down" then
      layout, group = group, layout
    end
    layout = switch(dir,
      {"left", {"r", "l"}},
      {"up",   {"d", "u"}},
      layout
    )
  end

  return layout, group
end

local function focus_in_direction_or_group(dir)
  return function()
    local window = hl.get_active_window()
    if not window then return end

    local layout_dir, group_dir = get_layout_and_group_directions()
    local layout = ternary({window.floating, nil}, window.workspace.tiled_layout)
    local group = window.group

    -- Inside group and along group - cycle in group
    if group then
      if dir == group_dir[1] and group.current_index ~= 1 then
        return hl.dispatch(hl.dsp.group.prev())
      elseif dir == group_dir[2] and group.current_index ~= group.size then
        return hl.dispatch(hl.dsp.group.next())
      end
    end

    -- Monocle and along layout - cycle windows
    if layout == "monocle" then
      if dir == layout_dir[1] then
        return hl.dispatch(hl.dsp.layout("cycleprev"))
      elseif dir == layout_dir[2] then
        return hl.dispatch(hl.dsp.layout("cyclenext"))
      end
    end

    -- Scrolling - scrolling specific dispatcher
    if layout == "scrolling" then
      -- HACK: `focus direction` uses relative l/r/u/d that depend on `scrolling.direction`
      local dir_relative = switch(
        hl.get_config("scrolling.direction"),
        {"left", switch(dir, {"l", "r"}, {"r", "l"}, dir)},
        {"up", switch(dir, {"u", "d"}, {"d", "u"}, dir)},
        dir
      )

      return hl.dispatch(hl.dsp.layout("focus " .. dir_relative))
    end

    -- Fallback
    return hl.dispatch(hl.dsp.focus { direction = dir })
  end
end

local function move_in_direction_or_group(dir)
  return function()
    local window = hl.get_active_window()
    if not window then return end

    local layout_dir, group_dir = get_layout_and_group_directions()
    local layout = ternary({window.floating, nil}, window.workspace.tiled_layout)
    local group = window.group

    -- Floating - move by pixels
    if window.floating then
      local factor = 20
      local x = switch(dir, {"l", -factor}, {"r", factor}, 0)
      local y = switch(dir, {"u", -factor}, {"d", factor}, 0)
      return hl.dispatch(hl.dsp.window.move {x = x, y = y, relative = true})
    end

    -- Inside group and along group - cycle in group
    if group then
      if dir == group_dir[1] and group.current_index ~= 1 then
        return hl.dispatch(hl.dsp.group.move_window{forward = false})
      elseif dir == group_dir[2] and group.current_index ~= group.size then
        return hl.dispatch(hl.dsp.group.move_window{forward = true})
      end
    end

    -- Scrolling
    if layout == "scrolling" then
      -- Not in a group and across layout - new or into existing column
      if not group then
        if dir == layout_dir[1] then
          return hl.dispatch(hl.dsp.layout("consume_or_expel prev"))
        elseif dir == layout_dir[2] then
          return hl.dispatch(hl.dsp.layout("consume_or_expel next"))
        end
      -- Out of a group - new column or into current column
      else
        -- HACK: `group_aware` move is borked in scrolling layout and always generates a column on the right no matter the direction
        -- To remove this branch completely when [this](https://github.com/hyprwm/Hyprland/discussions/14960) gets resolved

        -- Count tiled windows in a stack
        local is_vertical = layout_dir[1] == "u" or layout_dir[1] == "d"
        local scroll_axis = ternary({is_vertical, "y"}, "x")
        local stack_axis = ternary({is_vertical, "x"}, "y")
        local stack_dir = ternary({is_vertical, "l"}, "u")

        -- HACK: `window.at` accounts for groupbar height, but to find windows sitting on the same stack we don't need to account for it
        local function get_window_or_groupbar_position(window)
          if not window.group then return window.at end

          local height = ternary(
            {hl.get_config("group.groupbar.render_titles"), hl.get_config("group.groupbar.height")},
            hl.get_config("group.groupbar.indicator_height") + hl.get_config("group.groupbar.gaps_out")
          )
          local elements = ternary(
            {hl.get_config("group.groupbar.stacked"), window.group.size},
            1
          )
          return {x = window.at.x, y = window.at.y - height * elements}
        end

        local after_seen = {}
        local after_size = 0
        local window_at = get_window_or_groupbar_position(window)
        for _, w in ipairs(window.workspace:get_windows()) do
          local w_at = get_window_or_groupbar_position(w)

          if not w.floating
            and window_at[scroll_axis] == w_at[scroll_axis]
            and window_at[stack_axis] < w_at[stack_axis]
            and not after_seen[w_at[stack_axis]]
          then
            after_seen[w_at[stack_axis]] = true
            after_size = after_size + 1
          end
        end

        if group.size == 1 then
          return hl.dispatch(hl.dsp.group.toggle())
        end

        hl.dispatch(hl.dsp.window.move { out_of_group = layout_dir[2] })

        if dir == layout_dir[1] then
          -- TODO: Sometimes the column spawned is not the immediately next one but the last one, not sure why
          return hl.dispatch(hl.dsp.layout("swapcol l"))
        elseif dir == layout_dir[2] then
          return
        else
          hl.dispatch(hl.dsp.layout("consume_or_expel prev"))
          for _ = 1, after_size + ternary({dir == stack_dir, 1}, 0) do
            hl.dispatch(hl.dsp.window.move { direction = stack_dir, group_aware = false })
          end
          return
        end
      end
    end

    -- Fallback
    return hl.dispatch(hl.dsp.window.move { direction = dir, group_aware = true })
  end
end

hl.workspace_rule{workspace = "6", layout = "dwindle"}

for dir, key in pairs(key_window) do
  bind({mod, key}, focus_in_direction_or_group(dir), {repeating = true})
  bind(
    {mod, "SHIFT", key},
    move_in_direction_or_group(dir),
    {repeating = true}
  )
end
-- Window resize
bind({mod, "R"}, hl.dsp.layout("colresize +conf"))
bind({mod, "SHIFT", "R"}, hl.dsp.layout("fit expand"))
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
