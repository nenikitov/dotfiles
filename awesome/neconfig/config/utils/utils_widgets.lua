-- Load libraries
local gears = require('gears')
-- Load custom modules
local user_interactions = require('neconfig.user.config.binds.user_interactions')


-- Container for functions
local utils_widgets = {}

function utils_widgets.check_double_click(object)
    if object.double_click_timer then
        object.double_click_timer:stop()
        object.double_click_timer = nil
        return true
    end

    object.double_click_timer = gears.timer.start_new(
        user_interactions.double_click_time,
        function()
            object.double_click_timer = nil
            return false
        end
    )
end

return utils_widgets
