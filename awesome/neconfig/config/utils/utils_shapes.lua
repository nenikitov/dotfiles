-- Load libraries
local rad = math.rad
local min = math.min


-- Container for functions
local utils_shapes = {}

--- Generate a rectangle that supports different radius for corners and different cutout types
---@param args table Radius (number) and/or round (boolean). Can also be a table with keys as:
--- - `'tr'`, `'tl'`, `'br'`, `'bl'`
--- - **OR** `'top'`, `'bottom'`,
--- - **OR** `'right'`, `'left'`
---@return function shape Shape that is compatible with `gears.shape`
function utils_shapes.better_rect(args)
    args = args or {}

    local def_radius = 0
    local radius = args.radius or def_radius
    radius =
        type(radius) == 'table'
        and {
            tr = radius.tr or radius.top or radius.right or def_radius,
            tl = radius.tl or radius.top or radius.left or def_radius,
            br = radius.br or radius.bottom or radius.right or def_radius,
            bl = radius.bl or radius.bottom or radius.left or def_radius
        }
        or {
            tr = radius or def_radius,
            tl = radius or def_radius,
            br = radius or def_radius,
            bl = radius or def_radius
        }

    local def_round = false
    local round = args.round or def_round
    round =
        type(round) == 'table'
        and {
            tr = round.tr or round.top or round.right or def_round,
            tl = round.tl or round.top or round.left or def_round,
            br = round.br or round.bottom or round.right or def_round,
            bl = round.bl or round.bottom or round.left or def_round
        }
        or {
            tr = round or def_round,
            tl = round or def_round,
            br = round or def_round,
            bl = round or def_round
        }

    return function(cr, w, h)
        local half_w = w / 2
        local half_h = h / 2

        local r = {
            tr = min(radius.tr, half_w, half_h),
            tl = min(radius.tl, half_w, half_h),
            br = min(radius.br, half_w, half_h),
            bl = min(radius.bl, half_w, half_h)
        }

        cr:move_to(0, r.tl)

        -- Top left corner
        if round.tl then
            cr:arc(
                r.tl, r.tl,
                r.tl, rad(180), rad(270)
            )
        else
            cr:line_to(r.tl, 0)
        end

        -- Top right corner
        if round.tr then
            cr:arc(
                w - r.tr, r.tr,
                r.tr, rad(270), rad(0)
            )
        else
            cr:line_to(w - r.tr, 0)
            cr:line_to(w, r.tr)
        end

        -- Bottom right corner
        if round.br then
            cr:arc(
                w - r.br, h - r.br,
                r.br, rad(0), rad(90)
            )
        else
            cr:line_to(w, h - r.br + 1)
            cr:line_to(w - r.br, h)
        end

        -- Bottom left corner
        if round.bl then
            cr:arc(
                r.bl, h - r.bl,
                r.bl, rad(90), rad(180)
            )
        else
            cr:line_to(r.bl, h)
            cr:line_to(0, h - r.bl + 1)
        end

        cr:close_path()
    end
end

--- Get the side opposite to a side
---@param side string 'top', 'bottom', 'right', 'left'
---@return string side Opposite side
function utils_shapes.opposite_side(side)
    local opposite_sides = {
        top = 'bottom',
        bottom = 'top',
        right = 'left',
        left = 'right'
    }

    return opposite_sides[side]
end

--- Get the direction perpendicular to a direction
---@param direction string 'horizontal', 'vertical'
---@return string direction Perpendicular direction
function utils_shapes.perp_direction(direction)
    local perp_directions = {
        vertical = 'horizontal',
        horizontal = 'vertical'
    }

    return perp_directions[direction]
end

--- Get the direction along a side
---@param side string 'top', 'bottom', 'right', 'left'
---@return string direction Direction
function utils_shapes.direction_of_side(side)
    local directions = {
        top = 'horizontal',
        bottom = 'horizontal',
        right = 'vertical',
        left = 'vertical'
    }

    return directions[side]
end


--- Get size property along a direction
---@param direction string 'horizontal', 'vertical'
---@return string size Size property
function utils_shapes.size_prop_of_direction(direction)
    local size_props = {
        vertical = 'height',
        horizontal = 'width'
    }

    return size_props[direction]
end

--- Get position property along a direction
---@param direction string 'horizontal', 'vertical'
---@return string pos Position property
function utils_shapes.pos_prop_of_direction(direction)
    local pos_props = {
        vertical = 'y',
        horizontal = 'x'
    }

    return pos_props[direction]
end


--- Get 2 sides along a direction
---@param direction string 'horizontal', 'vertical'
---@return string side1
---@return string side2
function utils_shapes.sides_along_direction(direction)
    local sides = {
        horizontal = { 'left', 'right' },
        vertical = { 'top', 'bottom' }
    }

    return sides[direction][1], sides[direction][2]
end


return utils_shapes
