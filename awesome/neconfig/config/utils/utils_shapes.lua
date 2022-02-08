-- Load modules
local rad = math.rad
-- Load custom modules

-- Container for functions
local utils_shapes = {}

function utils_shapes.better_rect(args)
    local radius = args.radius
    radius =
        type(radius) == 'table'
        and {
            tr = radius.tr or 0,
            tl = radius.tl or 0,
            br = radius.br or 0,
            bl = radius.bl or 0
        }
        or {
            tr = radius or 0,
            tl = radius or 0,
            br = radius or 0,
            bl = radius or 0
        }

    local cutout = args.cutout
    cutout =
        type(radius) == 'table'
        and {
            tr = cutout.tr or 'cutout',
            tl = cutout.tl or 'cutout',
            br = cutout.br or 'cutout',
            bl = cutout.bl or 'cutout'
        }
        or {
            tr = cutout or 'none',
            tl = cutout or 'none',
            br = cutout or 'none',
            bl = cutout or 'none'
        }

end

return utils_shapes
