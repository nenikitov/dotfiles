---------------------------------------------------------------------------
-- The `align` layout has three slots for child widgets. On its main axis, it
-- will use as much space as is available to it and distribute that to its child
-- widgets by stretching or shrinking them based on the chosen @{expand}
-- strategy.
-- On its secondary axis, the biggest child widget determines the size of the
-- layout, but smaller widgets will not be stretched to match it.
--
-- In its default configuration, the layout will give the first and third
-- widgets only the minimum space they ask for and it aligns them to the outer
-- edges. The remaining space between them is made available to the widget in
-- slot two.
--
-- This layout is most commonly used to split content into left/top, center and
-- right/bottom sections. As such, it is usually seen as the root layout in
-- @{awful.wibar}.
--
-- You may also fill just one or two of the widget slots, the @{expand} algorithm
-- will adjust accordingly.
--
--@DOC_wibox_layout_defaults_align_EXAMPLE@
--
-- @author Uli Schlachter
-- @copyright 2010 Uli Schlachter
-- @layoutmod wibox.layout.align
-- @supermodule wibox.widget.base
---------------------------------------------------------------------------

local table = table
local pairs = pairs
local type = type
local floor = math.floor
local gtable = require("gears.table")
local base = require("wibox.widget.base")

local align = {}

-- ! Rewrite this
-- Calculate the layout of an align layout.
-- @param context The context in which we are drawn.
-- @param width The available width.
-- @param height The available height.
function align:layouta(context, width, height)
    local result = {}

    -- Draw will have to deal with all four align modes and should work in a
    -- way that makes sense if one or two of the widgets are missing (if they
    -- are all missing, it won't draw anything.) It should also handle the case
    -- where the fit something that isn't set to expand (for instance the
    -- outside widgets when the expand mode is "inside" or any of the widgets
    -- when the expand mode is "none" wants to take up more space than is
    -- allowed.
    local size_first = 0
    -- start with all the space given by the parent, subtract as we go along
    local size_remains = self._private.dir == "y" and height or width
    -- This is only set & used if expand ~= "inside" and we have second width.
    -- It contains the size allocated to the second widget.
    local size_second

    -- we will prioritize the middle widget unless the expand mode is "inside"
    --  if it is, we prioritize the first widget by not doing this block also,
    --  if the second widget doesn't exist, we will prioritize the first one
    --  instead
    if (self._private.expand ~= "inside" and self._private.expand ~= "justified") and self._private.second then
        local w, h = base.fit_widget(self, context, self._private.second, width, height)
        size_second = self._private.dir == "y" and h or w
        -- if all the space is taken, skip the rest, and draw just the middle
        -- widget
        if size_second >= size_remains then
            return { base.place_widget_at(self._private.second, 0, 0, width, height) }
        else
            -- the middle widget is sized first, the outside widgets are given
            --  the remaining space if available we will draw later
            size_remains = floor((size_remains - size_second) / 2)
        end
    end
    if self._private.first then
        local w, h, _ = width, height, nil
        -- we use the fit function for the "inside" and "none" modes, but
        --  ignore it for the "outside" mode, which will force it to expand
        --  into the remaining space
        if self._private.expand ~= "outside" then
            if self._private.dir == "y" then
                _, h = base.fit_widget(self, context, self._private.first, width, size_remains)
                size_first = h
                -- for "inside", the third widget will get a chance to use the
                --  remaining space, then the middle widget. For "none" we give
                --  the third widget the remaining space if there was no second
                --  widget to take up any space (as the first if block is skipped
                --  if this is the case)
                if self._private.expand == "inside" or self._private.expand == "justified" or not self._private.second then
                    size_remains = size_remains - h
                end
            else
                w, _ = base.fit_widget(self, context, self._private.first, size_remains, height)
                size_first = w
                if self._private.expand == "inside" or self._private.expand == "justified" or not self._private.second then
                    size_remains = size_remains - w
                end
            end
        else
            if self._private.dir == "y" then
                h = size_remains
            else
                w = size_remains
            end
        end
        table.insert(result, base.place_widget_at(self._private.first, 0, 0, w, h))
    end
    -- size_remains will be <= 0 if first used all the space
    if self._private.third and size_remains > 0 then
        local w, h, _ = width, height, nil
        if self._private.expand ~= "outside" then
            if self._private.dir == "y" then
                _, h = base.fit_widget(self, context, self._private.third, width, size_remains)
                -- give the middle widget the rest of the space for "inside" mode
                if self._private.expand == "inside" or self._private.expand == "justified" then
                    size_remains = size_remains - h
                end
            else
                w, _ = base.fit_widget(self, context, self._private.third, size_remains, height)
                if self._private.expand == "inside" or self._private.expand == "justified" then
                    size_remains = size_remains - w
                end
            end
        else
            if self._private.dir == "y" then
                h = size_remains
            else
                w = size_remains
            end
        end
        local x, y = width - w, height - h
        table.insert(result, base.place_widget_at(self._private.third, x, y, w, h))
    end
    -- here we either draw the second widget in the space set aside for it
    -- in the beginning, or in the remaining space, if it is "inside" or "justified"
    if self._private.second and size_remains > 0 then
        local x, y, w, h = 0, 0, width, height
        if self._private.expand == "inside" or self._private.expand == "justified" then
            if self._private.dir == "y" then
                h = size_remains
                x, y = 0, size_first
            else
                w = size_remains
                x, y = size_first, 0
            end
        else
            local _
            if self._private.dir == "y" then
                _, h = base.fit_widget(self, context, self._private.second, width, size_second)
                y = floor( (height - h)/2 )
            else
                w, _ = base.fit_widget(self, context, self._private.second, size_second, height)
                x = floor( (width -w)/2 )
            end
        end
        table.insert(result, base.place_widget_at(self._private.second, x, y, w, h))
    end
    return result
end

-- ! Delete this later
local naughty = require('naughty')
local function pr(c)
    naughty.notify {
        text = tostring(c)
    }
end


-- Calculate the layout of an align layout.
-- @param context The context in which we are drawn.
-- @param width The available width.
-- @param height The available height.
function align:layout(context, width, height)
    local result = {}
    local size_remains = self._private.dir == "y" and height or width

    -- Get the minimum required size of a child widget
    local function get_size(child, max_size)
        if not child then
            return 0
        end

        local is_vert = self._private.dir == "y"
        local width_remains = is_vert and width or max_size
        local height_remains = is_vert and max_size or height

        local w, h = base.fit_widget(
            self, context, self._private[child],
            width_remains, height_remains
        )
        return is_vert and h or w
    end
    -- Place a child widget inside the layout
    local function place_child(child, offset, size)
        if size_remains <= 0 then
            return
        end

        size = math.min(size, size_remains)

        local is_vert = self._private.dir == "y"
        local child_width = is_vert and width or size
        local child_height = is_vert and size or height

        local x_offset = (not is_vert) and offset or 0
        local y_offset = (not is_vert) and 0 or offset

        table.insert(
            result,
            base.place_widget_at(
                self._private[child],
                x_offset, y_offset,
                child_width, child_height
            )
        )

        size_remains = size_remains - size
    end

    -- Get the minimum sizes of all widgets
    local size_first  = get_size("first",  size_remains)
    local size_second = get_size("second", size_remains)
    local size_third  = get_size("third",  size_remains)

    -- Size of the layout before any placements
    local total_size  = size_remains

    -- No widget is expanded, second is prioritized
    if self._private.expand == "none" then
        local size_without_second = total_size - size_second
        -- Second widget is prioritized
        place_child(
            "second",
            -- Center of the layout
            (size_remains - size_second) / 2,
            -- Not expanded, just minimum size
            size_second
        )
        -- First follows
        place_child(
            "first",
            -- Beginning of the layout
            0,
            -- Minimum size
            -- or until the second widget if can't fit
            math.min(size_first, size_second / 2)
        )
        -- Third follows
        place_child(
            "third",
            -- End of the layout (offset to fit its size)
            -- or right after second widget if can't fit
            math.max(total_size - size_third, size_without_second / 2 + size_second),
            -- Minimum size
            -- or until the end of the layout it can't fit
            math.min(size_third, size_without_second / 2)
        )
    -- Center expanded, side widgets are prioritized
    elseif self._private.expand == "inside" then
        -- First widget is prioritized
        place_child(
            "first",
            -- Beginning of the layout
            0,
            -- Minimum size
            size_first
        )
        -- Third follows
        place_child(
            "third",
            -- End of the layout (offset to fit its size)
            -- or right after first widget if no center widget
            math.max(total_size - size_third, size_first),
            -- Minimum size
            size_third
        )
        place_child(
            "second",
            -- After the first
            size_first,
            -- Whatever is left - expand
            size_remains
        )
    -- Sides expanded, center is prioritized
    elseif self._private.expand == "outside" then
        -- Second widget is prioritized
        place_child(
            "second",
            -- Center of the layout
            (size_remains - size_second) / 2,
            -- Minimum size
            size_second
        )
        -- First follows
        place_child(
            "first",
            -- Begging of the layout
            0,
            -- Half of the remaining size - expand
            -- because placing the center widget leaves space on 2 sides
            size_remains / 2
        )
        place_child(
            "third",
            -- Right after the second
            -- because size_remains is only for 1 side now and we add size of the second
            size_remains + size_second,
            -- Whatever is left - expand
            size_remains
        )
    -- Center expanded, side widgets are prioritized, but kept the same size
    elseif self._private.expand == "justified" then
        -- Determine which of the sides is larger
        if size_first > size_third then
            -- First is prioritized because it is larger
            place_child(
                "first",
                -- Begging of the layout
                0,
                -- Minimum size
                size_first
            )
            -- Third follows
            place_child(
                "third",
                -- End of the layout
                -- or right after first widget if no center widget
                math.max(size_remains, size_first),
                -- Same size as first - expand
                size_first
            )
            -- Second follows
            place_child(
                "second",
                -- Right after first widget
                size_first,
                -- Whatever is left - expand
                size_remains
            )
        else
            -- Third is prioritized because it is larger
            place_child(
                "third",
                -- End of the layout (offset to fit its size)
                total_size - size_third,
                -- Minimum size
                size_third
            )
            -- First follows
            place_child(
                "first",
                -- Beginning of the layout
                0,
                -- Same as the third - expand
                -- or until the third widget if no center widget
                math.min(size_third, size_remains)
            )
            place_child(
                "second",
                -- Right after first widget
                size_third,
                -- Whatever is left - expand
                size_remains
            )
        end
    end

    return result
end

--- The widget in slot one.
--
-- This is the widget that is at the left/top.
--
-- @property first
-- @tparam widget first
-- @propemits true false

function align:set_first(widget)
    if self._private.first == widget then
        return
    end
    self._private.first = widget
    self:emit_signal("widget::layout_changed")
    self:emit_signal("property::first", widget)
end

--- The widget in slot two.
--
-- This is the centered one.
--
-- @property second
-- @tparam widget second
-- @propemits true false

function align:set_second(widget)
    if self._private.second == widget then
        return
    end
    self._private.second = widget
    self:emit_signal("widget::layout_changed")
    self:emit_signal("property::second", widget)
end

--- The widget in slot three.
--
-- This is the widget that is at the right/bottom.
--
-- @property third
-- @tparam widget third
-- @propemits true false

function align:set_third(widget)
    if self._private.third == widget then
        return
    end
    self._private.third = widget
    self:emit_signal("widget::layout_changed")
    self:emit_signal("property::third", widget)
end

for _, prop in ipairs {"first", "second", "third", "expand" } do
    align["get_"..prop] = function(self)
        return self._private[prop]
    end
end

function align:get_children()
    return gtable.from_sparse {self._private.first, self._private.second, self._private.third}
end

function align:set_children(children)
    self:set_first(children[1])
    self:set_second(children[2])
    self:set_third(children[3])
end

-- Fit the align layout into the given space. The align layout will
-- ask for the sum of the sizes of its sub-widgets in its direction
-- and the largest sized sub widget in the other direction.
-- @param context The context in which we are fit.
-- @param orig_width The available width.
-- @param orig_height The available height.
function align:fit(context, orig_width, orig_height)
    local used_in_dir = 0
    local used_in_other = 0

    for _, v in pairs{self._private.first, self._private.second, self._private.third} do
        local w, h = base.fit_widget(self, context, v, orig_width, orig_height)

        local max = self._private.dir == "y" and w or h
        if max > used_in_other then
            used_in_other = max
        end

        used_in_dir = used_in_dir + (self._private.dir == "y" and h or w)
    end

    if self._private.dir == "y" then
        return used_in_other, used_in_dir
    end
    return used_in_dir, used_in_other
end

--- Set the expand mode, which determines how child widgets expand to take up
-- unused space.
--
-- The following values are valid:
--
-- * `"inside"`: The widgets in slot one and three are set to their minimal
--   required size. The widget in slot two is then given the remaining space.
--   This is the default behaviour.
-- * `"outside"`: The widget in slot two is set to its minimal required size and
--   placed in the center of the space available to the layout. The other
--   widgets are then given the remaining space on either side.
--   If the center widget requires all available space, the outer widgets are
--   not drawn at all.
-- * `"justified"`: The widgets in the slots one and three are set to the same
--   size, which is the maximum of their minimal required sizes. The second
--   widget takes the remaining space in the middle. The longest side widget
--   gets priority
-- * `"none"`: All widgets are given their minimal required size or the
--   remaining space, whichever is smaller. The center widget gets priority.
--
-- Attempting to set any other value than one of those three will fall back to
-- `"inside"`.
--
-- @property expand
-- @tparam[opt="inside"] string mode How to use unused space.

function align:set_expand(mode)
    if mode == "none" or mode == "outside" or mode == "justified" then
        self._private.expand = mode
    else
        self._private.expand = "inside"
    end
    self:emit_signal("widget::layout_changed")
    self:emit_signal("property::expand", mode)
end

function align:reset()
    for _, v in pairs({ "first", "second", "third" }) do
        self[v] = nil
    end
    self:emit_signal("widget::layout_changed")
end

local function get_layout(dir, first, second, third)
    local ret = base.make_widget(nil, nil, {enable_properties = true})
    ret._private.dir = dir

    for k, v in pairs(align) do
        if type(v) == "function" then
            rawset(ret, k, v)
        end
    end

    ret:set_expand("inside")
    ret:set_first(first)
    ret:set_second(second)
    ret:set_third(third)

    -- An align layout allow set_children to have empty entries
    ret.allow_empty_widget = true

    return ret
end

--- Returns a new horizontal align layout.
--
-- The three widget slots are aligned left, center and right.
--
-- Additionally, this creates the aliases `set_left`, `set_middle` and
-- `set_right` to assign @{first}, @{second} and @{third} respectively.
-- @constructorfct wibox.layout.align.horizontal
-- @tparam[opt] widget left Widget to be put in slot one.
-- @tparam[opt] widget middle Widget to be put in slot two.
-- @tparam[opt] widget right Widget to be put in slot three.
function align.horizontal(left, middle, right)
    local ret = get_layout("x", left, middle, right)

    rawset(ret, "set_left"  , ret.set_first  )
    rawset(ret, "set_middle", ret.set_second )
    rawset(ret, "set_right" , ret.set_third  )

    return ret
end

--- Returns a new vertical align layout.
--
-- The three widget slots are aligned top, center and bottom.
--
-- Additionally, this creates the aliases `set_top`, `set_middle` and
-- `set_bottom` to assign @{first}, @{second} and @{third} respectively.
-- @constructorfct wibox.layout.align.vertical
-- @tparam[opt] widget top Widget to be put in slot one.
-- @tparam[opt] widget middle Widget to be put in slot two.
-- @tparam[opt] widget bottom Widget to be put in slot three.
function align.vertical(top, middle, bottom)
    local ret = get_layout("y", top, middle, bottom)

    rawset(ret, "set_top"   , ret.set_first  )
    rawset(ret, "set_middle", ret.set_second )
    rawset(ret, "set_bottom", ret.set_third  )

    return ret
end

--@DOC_fixed_COMMON@

return align

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
