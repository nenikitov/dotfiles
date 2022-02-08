-- Load modules
local rad = math.rad
-- Load custom modules

-- Container for functions
local utils_shapes = {}

function utils_shapes.better_rect(args)
    args = args or {}

    local def_radius = 0
    local radius = args.radius or def_radius
    radius =
        type(radius) == 'table'
        and {
            tr = radius.tr or def_radius,
            tl = radius.tl or def_radius,
            br = radius.br or def_radius,
            bl = radius.bl or def_radius
        }
        or {
            tr = radius or def_radius,
            tl = radius or def_radius,
            br = radius or def_radius,
            bl = radius or def_radius
        }

    local def_cutout = 'round'
    local cutout = args.cutout or def_cutout
    cutout =
        type(cutout) == 'table'
        and {
            tr = cutout.tr or def_cutout,
            tl = cutout.tl or def_cutout,
            br = cutout.br or def_cutout,
            bl = cutout.bl or def_cutout
        }
        or {
            tr = cutout or def_cutout,
            tl = cutout or def_cutout,
            br = cutout or def_cutout,
            bl = cutout or def_cutout
        }

    return function(cr, w, h)
        cr:move_to(0, radius.tl)

        -- Top left corner
        if cutout.tl == 'round' then
            cr:arc(
                radius.tl, radius.tl,
                radius.tl, rad(180), rad(270)
            )
        else
            cr:line_to(radius.tl, 0)
        end

        -- Top right corner
        if cutout.tr == 'round' then
            cr:arc(
                w - radius.tr, radius.tr,
                radius.tr, rad(270), rad(0)
            )
        else
            cr:line_to(w - radius.tr, 0)
            cr:line_to(w, radius.tr)
        end

        -- Bottom right corner
        if cutout.br == 'round' then
            cr:arc(
                w - radius.br, h - radius.br,
                radius.br, rad(0), rad(90)
            )
        else
            cr:line_to(w, h - radius.br)
            cr:line_to(w - radius.br, h)
        end

        -- Bottom left corner
        if cutout.bl == 'round' then
            cr:arc(
                radius.bl, h - radius.bl,
                radius.bl, rad(90), rad(180)
            )
        else
            cr:line_to(radius.br, h)
            cr:line_to(0, h - radius.br)
        end



        cr:close_path()
    end
end

return utils_shapes
