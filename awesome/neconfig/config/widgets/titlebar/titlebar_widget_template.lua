-- Load libraries
local wibox = require('wibox')
-- Load custom modules
local user_titlebar = require("neconfig.user.config.widgets.user_titlebar")
local utils_shapes  = require("neconfig.config.utils.utils_shapes")


local function titlebar_widget_template(c)
    local direction = utils_shapes.direction_of_side(user_titlebar.position)
    local beginning_section = wibox.layout.fixed[direction]()
    local middle_section = wibox.layout.fixed[direction]()
    local ending_side = wibox.layout.fixed[direction]()

end

return titlebar_widget_template